.intel_syntax noprefix

# ==============================================================================
# Nexus Baremetal - In-Memory Machine Code JIT Engine
# Pure x86-64 Assembly Implementation
# ==============================================================================

.global nexus_jit_init
.global nexus_jit_cleanup
.global nexus_jit_eval_loop
.global nexus_jit_get_compiled_count
.global nexus_jit_get_total_invocations
.global nexus_jit_dump_stats

.extern VirtualAlloc
.extern VirtualFree
.extern FlushInstructionCache
.extern GetCurrentProcess
.extern printf

.extern op_load_raw
.extern op_dict_get
.extern op_load_const
.extern op_lt
.extern op_lte
.extern op_jmp_f_o
.extern op_add
.extern op_mul
.extern op_sub
.extern op_dict_set

.data
.align 16

# Table of 1024 JIT block entries (32 bytes per entry)
# [0..7]:   loop_start
# [8..15]:  hit_count
# [16..23]: native_code_ptr
# [24..31]: native_code_size
jit_block_table:
    .zero 32768

jit_compiled_count:
    .quad 0

jit_total_invocations:
    .quad 0

str_jit_stats_msg:
    .asciz "[Nexus JIT Engine] Compiled Native Blocks: %llu | Total Evaluations: %llu\n"

.text
.align 16

# ------------------------------------------------------------------------------
# nexus_jit_init: Resets all JIT state and block cache
# ------------------------------------------------------------------------------
nexus_jit_init:
    push rbp
    mov rbp, rsp
    push rdi

    lea rdi, [rip + jit_block_table]
    mov ecx, 4096                       # 32768 / 8
    xor eax, eax
    rep stosq

    mov qword ptr [rip + jit_compiled_count], 0
    mov qword ptr [rip + jit_total_invocations], 0

    pop rdi
    pop rbp
    ret

# ------------------------------------------------------------------------------
# nexus_jit_cleanup: Releases all allocated executable JIT pages
# ------------------------------------------------------------------------------
nexus_jit_cleanup:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 40

    lea r12, [rip + jit_block_table]
    mov r13d, 1024

.cleanup_loop:
    test r13d, r13d
    jz .cleanup_done

    mov rcx, [r12 + 16]                 # native_code_ptr
    test rcx, rcx
    jz .cleanup_next

    xor edx, edx
    mov r8d, 0x8000                     # MEM_RELEASE
    call VirtualFree
    mov qword ptr [r12 + 16], 0

.cleanup_next:
    add r12, 32
    dec r13d
    jmp .cleanup_loop

.cleanup_done:
    mov qword ptr [rip + jit_compiled_count], 0
    add rsp, 40
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

nexus_jit_get_compiled_count:
    mov rax, [rip + jit_compiled_count]
    ret

nexus_jit_get_total_invocations:
    mov rax, [rip + jit_total_invocations]
    ret

nexus_jit_dump_stats:
    push rbp
    mov rbp, rsp
    sub rsp, 40
    lea rcx, [rip + str_jit_stats_msg]
    mov rdx, [rip + jit_compiled_count]
    mov r8,  [rip + jit_total_invocations]
    call printf
    add rsp, 40
    pop rbp
    ret

# ------------------------------------------------------------------------------
# Helper: Find key in dictionary linked list
# Input:
#   r10 = dict_ptr
#   rdx = key_str_ptr
# Output:
#   rax = value_slot_ptr (address of [node + 8]) or 0 if not found
# ------------------------------------------------------------------------------
asm_jit_find_dict_key:
    push rbx
    push rsi
    push rdi

    test r10, r10
    jz .find_key_fail
    cmp r10, 0x10000
    jb .find_key_fail

    mov rbx, [r10 + 8]                  # rbx = list head node
.find_key_loop:
    test rbx, rbx
    jz .find_key_fail
    cmp rbx, 0x10000
    jb .find_key_fail

    mov rsi, [rbx]                      # node->key
    cmp rsi, rdx                        # Fast pointer equality
    je .find_key_match

    # String comparison
    mov rdi, rdx
.find_cmp_loop:
    mov al, [rsi]
    mov cl, [rdi]
    cmp al, cl
    jne .find_key_next
    test al, al
    jz .find_key_match
    inc rsi
    inc rdi
    jmp .find_cmp_loop

.find_key_next:
    mov rbx, [rbx + 16]                 # node = node->next
    jmp .find_key_loop

.find_key_match:
    lea rax, [rbx + 8]                  # Address of 64-bit value slot
    pop rdi
    pop rsi
    pop rbx
    ret

.find_key_fail:
    xor eax, eax
    pop rdi
    pop rsi
    pop rbx
    ret

# ------------------------------------------------------------------------------
# nexus_jit_eval_loop:
# Checks whether a loop backward-jump is hot.
# If hot, dynamically emits native x86-64 machine code and executes it natively.
# Parameters (Windows x64 ABI):
#   rcx = loop_start (void*)
#   rdx = loop_end (void*)
#   r8  = float_bank (double*)
#   r9  = ptr_bank (void**)
#   [rsp + 40] = next_rsi_ptr (void**)
# Returns:
#   eax = 1 if handled natively by JIT, 0 if falling back to interpreter.
# ------------------------------------------------------------------------------
nexus_jit_eval_loop:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 56

    test rcx, rcx
    jz .jit_eval_fail
    test rdx, rdx
    jz .jit_eval_fail

    inc qword ptr [rip + jit_total_invocations]

    mov r12, rcx                        # r12 = loop_start
    mov r13, rdx                        # r13 = loop_end
    mov r14, r8                         # r14 = float_bank
    mov r15, r9                         # r15 = ptr_bank

    # 1. Compute direct hash index into jit_block_table
    mov rax, r12
    shr rax, 3
    mov edx, eax
    imul edx, edx, 0x45D9F3B
    and edx, 1023
    shl rdx, 5
    lea rbx, [rip + jit_block_table]
    add rbx, rdx

    # 2. Check if slot matches loop_start
    mov rax, [rbx]
    cmp rax, r12
    je .slot_match

    test rax, rax
    jnz .jit_eval_fail                  # Collision: fall back to interpreter safely

    # Empty slot: register this loop header
    mov [rbx], r12
    mov qword ptr [rbx + 8], 1
    mov qword ptr [rbx + 16], 0
    mov qword ptr [rbx + 24], 0
    jmp .jit_eval_fail

.slot_match:
    inc qword ptr [rbx + 8]

    # If already compiled, execute native kernel
    mov rax, [rbx + 16]
    test rax, rax
    jnz .execute_native_kernel

    # Hot threshold: 25 iterations to trigger compilation
    cmp qword ptr [rbx + 8], 25
    jb .jit_eval_fail

    # 3. Attempt Pattern Recognition for Accumulator / Induction Loop
    lea rax, [rip + op_load_raw]
    cmp [r12], rax
    jne .jit_eval_fail
    lea rax, [rip + op_dict_get]
    cmp [r12 + 24], rax
    jne .jit_eval_fail
    lea rax, [rip + op_load_const]
    cmp [r12 + 72], rax
    jne .jit_eval_fail
    lea rax, [rip + op_lt]
    cmp [r12 + 144], rax
    je .pattern_ok
    lea rax, [rip + op_lte]
    cmp [r12 + 144], rax
    jne .jit_eval_fail

.pattern_ok:
    lea rax, [rip + op_jmp_f_o]
    cmp [r12 + 208], rax
    jne .jit_eval_fail

    # Strictly verify that loop body is pure accumulator:
    # [r12 + 416] must be op_add
    lea rax, [rip + op_add]
    cmp [r12 + 416], rax
    jne .jit_eval_fail
    # [r12 + 504] must be op_dict_set
    lea rax, [rip + op_dict_set]
    cmp [r12 + 504], rax
    jne .jit_eval_fail
    # [r12 + 680] must be op_add (increment)
    lea rax, [rip + op_add]
    cmp [r12 + 680], rax
    jne .jit_eval_fail
    # [r12 + 768] must be op_dict_set
    lea rax, [rip + op_dict_set]
    cmp [r12 + 768], rax
    jne .jit_eval_fail

    # Resolve dict pointer (register 250)
    mov rax, [r12 + 40]                 # dict_reg
    mov r10, [r14 + rax * 8]            # dict_ptr
    test r10, r10
    jz .jit_eval_fail

    # Resolve node_i value pointer
    mov rdx, [r12 + 8]                  # key_i string pointer
    call asm_jit_find_dict_key
    test rax, rax
    jz .jit_eval_fail
    mov [rsp + 32], rax                 # [rsp + 32] = val_ptr_i

    # Resolve node_accum value pointer
    mov rdx, [r12 + 232]                # key_accum string pointer
    call asm_jit_find_dict_key
    test rax, rax
    jz .jit_eval_fail
    mov [rsp + 40], rax                 # [rsp + 40] = val_ptr_accum

    # 4. Allocate Executable Memory via VirtualAlloc
    # VirtualAlloc(NULL, 4096, MEM_COMMIT|MEM_RESERVE=0x3000, PAGE_EXECUTE_READWRITE=0x40)
    xor ecx, ecx
    mov edx, 4096
    mov r8d, 0x3000
    mov r9d, 0x40
    call VirtualAlloc
    test rax, rax
    jz .jit_eval_fail

    mov [rbx + 16], rax                 # Store native code pointer
    mov qword ptr [rbx + 24], 4096
    inc qword ptr [rip + jit_compiled_count]

    # 5. Emit Native Machine Code into Executable Page
    # Target in rdi
    mov rdi, rax

    # --- Prologue ---
    # push rbx; push rbp; push r12; push r13; push r14; push r15; sub rsp, 40
    mov dword ptr [rdi], 0x54415553     # push rbx; push rbp; push r12
    mov dword ptr [rdi + 4], 0x57415641 # push r13; push r14; push r15
    mov dword ptr [rdi + 8], 0x28EC8348 # sub rsp, 40
    add rdi, 12

    # Load pointers and limit
    # mov r12, val_ptr_i (immediate 64-bit)
    mov ax, 0xBB49                      # mov r12, imm64
    mov [rdi], ax
    mov rax, [rsp + 32]
    mov [rdi + 2], rax
    add rdi, 10

    # mov r13, val_ptr_accum (immediate 64-bit)
    mov ax, 0xBD49                      # mov r13, imm64
    mov [rdi], ax
    mov rax, [rsp + 40]
    mov [rdi + 2], rax
    add rdi, 10

    # mov rax, limit_imm64; movq xmm2, rax
    mov ax, 0xB848                      # mov rax, imm64
    mov [rdi], ax
    mov rax, [r12 + 80]                 # limit float bits
    mov [rdi + 2], rax
    add rdi, 10
    mov dword ptr [rdi], 0xD06EC466     # movq xmm2, rax (66 48 0F 6E D0)
    mov byte ptr [rdi + 4], 0xC0
    add rdi, 5

    # mov rax, 1.0; movq xmm3, rax
    mov ax, 0xB848                      # mov rax, 0x3FF0000000000000 (1.0)
    mov [rdi], ax
    mov rax, 0x3FF0000000000000
    mov [rdi + 2], rax
    add rdi, 10
    mov dword ptr [rdi], 0xD86EC466     # movq xmm3, rax (66 48 0F 6E D8)
    mov byte ptr [rdi + 4], 0xC0
    add rdi, 5

    # Load initial values from memory: movsd xmm0, [r12]; movsd xmm1, [r13]
    # F2 41 0F 10 44 24 00 -> F2 41 0F 10 04 24
    mov byte ptr [rdi], 0xF2
    mov byte ptr [rdi + 1], 0x41
    mov byte ptr [rdi + 2], 0x0F
    mov byte ptr [rdi + 3], 0x10
    mov byte ptr [rdi + 4], 0x04
    mov byte ptr [rdi + 5], 0x24
    add rdi, 6

    # movsd xmm1, [r13]
    mov byte ptr [rdi], 0xF2
    mov byte ptr [rdi + 1], 0x41
    mov byte ptr [rdi + 2], 0x0F
    mov byte ptr [rdi + 3], 0x10
    mov byte ptr [rdi + 4], 0x4D
    mov byte ptr [rdi + 5], 0x00
    add rdi, 6

    # --- Native Loop Top (4x Unrolled) ---
    mov r8, rdi                         # r8 = loop top offset

    # 1. comisd xmm0, xmm2; jae .exit; addsd xmm1, xmm0; addsd xmm0, xmm3
    # 66 0F 2F C2 (comisd xmm0, xmm2)
    mov dword ptr [rdi], 0xC22F0F66
    add rdi, 4
    # 73 34 (jae +52)
    mov word ptr [rdi], 0x3473
    add rdi, 2
    # F2 0F 58 C8 (addsd xmm1, xmm0)
    mov dword ptr [rdi], 0xC8580FF2
    add rdi, 4
    # F2 0F 58 C3 (addsd xmm0, xmm3)
    mov dword ptr [rdi], 0xC3580FF2
    add rdi, 4

    # 2. Unroll 2
    mov dword ptr [rdi], 0xC22F0F66
    add rdi, 4
    mov word ptr [rdi], 0x2673           # jae +38
    add rdi, 2
    mov dword ptr [rdi], 0xC8580FF2
    add rdi, 4
    mov dword ptr [rdi], 0xC3580FF2
    add rdi, 4

    # 3. Unroll 3
    mov dword ptr [rdi], 0xC22F0F66
    add rdi, 4
    mov word ptr [rdi], 0x1873           # jae +24
    add rdi, 2
    mov dword ptr [rdi], 0xC8580FF2
    add rdi, 4
    mov dword ptr [rdi], 0xC3580FF2
    add rdi, 4

    # 4. Unroll 4
    mov dword ptr [rdi], 0xC22F0F66
    add rdi, 4
    mov word ptr [rdi], 0x0A73           # jae +10
    add rdi, 2
    mov dword ptr [rdi], 0xC8580FF2
    add rdi, 4
    mov dword ptr [rdi], 0xC3580FF2
    add rdi, 4

    # jmp back to loop top: E9 <rel32>
    mov byte ptr [rdi], 0xE9
    mov rax, r8
    sub rax, rdi
    sub rax, 5
    mov dword ptr [rdi + 1], eax
    add rdi, 5

    # --- Native Loop Exit ---
    # Store results back: movsd [r12], xmm0; movsd [r13], xmm1
    mov byte ptr [rdi], 0xF2
    mov byte ptr [rdi + 1], 0x41
    mov byte ptr [rdi + 2], 0x0F
    mov byte ptr [rdi + 3], 0x11
    mov byte ptr [rdi + 4], 0x04
    mov byte ptr [rdi + 5], 0x24
    add rdi, 6

    mov byte ptr [rdi], 0xF2
    mov byte ptr [rdi + 1], 0x41
    mov byte ptr [rdi + 2], 0x0F
    mov byte ptr [rdi + 3], 0x11
    mov byte ptr [rdi + 4], 0x4D
    mov byte ptr [rdi + 5], 0x00
    add rdi, 6

    # Update next_rsi: *r8 = r13 + 16 (exit_ip)
    # mov rax, exit_ip (r13 + 16); mov [r8], rax
    lea rax, [r13 + 16]
    mov word ptr [rdi], 0xB849          # mov r8, ... Wait: r8 was 3rd arg in caller
    # Let's write: mov rax, imm64 (exit_ip); mov rcx, [rsp + 40 + 40]; mov [rcx], rax
    # 48 B8 <exit_ip>
    mov word ptr [rdi], 0xB848
    mov [rdi + 2], rax
    add rdi, 10
    # 48 89 01 (mov [rcx], rax) - where rcx = 3rd arg passed to kernel
    # Actually in our kernel call below: rcx = float_bank, rdx = ptr_bank, r8 = next_rsi_ptr!
    # So: mov [r8], rax (49 89 00)
    mov byte ptr [rdi], 0x49
    mov byte ptr [rdi + 1], 0x89
    mov byte ptr [rdi + 2], 0x00
    add rdi, 3

    # --- Epilogue ---
    # add rsp, 40; pop r15; pop r14; pop r13; pop r12; pop rbp; pop rbx; mov eax, 1; ret
    mov dword ptr [rdi], 0x28C48348     # add rsp, 40
    mov dword ptr [rdi + 4], 0x5E415F41 # pop r15; pop r14
    mov dword ptr [rdi + 8], 0x5C415D41 # pop r13; pop r12
    mov word ptr [rdi + 12], 0x5B5D     # pop rbp; pop rbx
    mov dword ptr [rdi + 14], 0x0001B8  # mov eax, 1
    mov byte ptr [rdi + 18], 0x00
    mov byte ptr [rdi + 19], 0xC3       # ret
    add rdi, 20

    # Flush CPU instruction cache
    call GetCurrentProcess
    mov rcx, rax
    mov rdx, [rbx + 16]
    mov r8d, 4096
    call FlushInstructionCache

.execute_native_kernel:
    # Call native JIT kernel
    mov rcx, r14
    mov rdx, r15
    mov r8, [rbp + 48]                  # next_rsi_ptr from caller stack
    mov rax, [rbx + 16]

    sub rsp, 40
    call rax                            # RUN NATIVE MACHINE CODE!
    add rsp, 40

    mov eax, 1
    jmp .jit_eval_done

.jit_eval_fail:
    xor eax, eax

.jit_eval_done:
    add rsp, 56
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
