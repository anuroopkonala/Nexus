.intel_syntax noprefix

.global main
.extern printf
.extern malloc
.extern free
.extern exit
.extern fopen
.extern fscanf
.extern strcmp
.extern strdup
.extern atof
.extern atoi
.extern fclose
.extern sin
.extern cos
.extern pow
.extern sqrt
.extern strlen
.extern strcat
.extern fread
.extern fwrite
.extern gets

.section .data
fmt_addrs: .asciz "DEBUG: op_load_raw = %p, op_print = %p\n"
fmt_parse: .asciz "DEBUG: Parsed token: %s\n"
msg_load_raw: .asciz "DEBUG: executing op_load_raw\n"
init_msg: .asciz "[Nexus Baremetal] Booting Lightning Direct-Threaded VM...\n"
time_msg: .asciz "[Nexus Baremetal] VM execution complete.\n"
debug_fmt: .asciz "[Nexus Baremetal] Register output: %f\n"
char_fmt: .asciz "%c"
str_fmt: .asciz "%s\n"
fmt_rcx: .asciz "DEBUG: op_print rcx = %llu\n"

fmt_argc: .asciz "ARGC=%d\n"

file_name: .asciz "boot.nxasm"
read_mode: .asciz "r"
scan_fmt: .asciz "%s"
err_msg: .asciz "Failed to open boot.nxasm\n"

str_FREAD: .asciz "FREAD"
str_FWRITE: .asciz "FWRITE"
str_FCLOSE: .asciz "FCLOSE"
str_INPUT: .asciz "INPUT"
str_STR_CAT: .asciz "STR_CAT"
str_SQRT: .asciz "SQRT"
str_SIN: .asciz "SIN"
str_COS: .asciz "COS"
str_POW: .asciz "POW"
str_PANIC: .asciz "PANIC"
panic_msg: .asciz "VM PANIC!\n"
stack_trace_msg: .asciz "Stack trace:\n  <main>\n"
str_LOAD: .asciz "LOAD"
str_ADD: .asciz "ADD"
str_PRINT: .asciz "PRINT"
str_HALT: .asciz "HALT"
str_LT: .asciz "LT"
str_LABEL: .asciz "LABEL"
str_JMP: .asciz "JMP"
str_JMP_F: .asciz "JMP_F"
str_LOAD_STR: .asciz "LOAD_STR"
str_FOPEN: .asciz "FOPEN"
str_FGETC: .asciz "FGETC"
str_PRINT_C: .asciz "PRINT_C"
str_PRINT_STR: .asciz "PRINT_STR"
str_EQ: .asciz "EQ"
str_SUB: .asciz "SUB"
str_MUL: .asciz "MUL"
str_DIV: .asciz "DIV"
str_GT: .asciz "GT"
str_NEQ: .asciz "NEQ"
str_MOV: .asciz "MOV"
str_NOT: .asciz "NOT"
str_STORE_PTR: .asciz "STORE_PTR"
str_LOAD_PTR: .asciz "LOAD_PTR"
str_PUTS: .asciz "PUTS"
str_ALLOC: .asciz "ALLOC"
str_DICT_NEW: .asciz "DICT_NEW"
str_DICT_SET: .asciz "DICT_SET"
str_DICT_GET: .asciz "DICT_GET"
str_FREE: .asciz "FREE"
str_LOAD_B: .asciz "LOAD_B"
str_STORE_B: .asciz "STORE_B"
str_CALL: .asciz "CALL"
str_RET: .asciz "RET"
str_PUSH: .asciz "PUSH"
str_POP: .asciz "POP"
str_LOAD_F: .asciz "LOAD_F"
str_STORE_F: .asciz "STORE_F"
str_LOAD_PTR_O: .asciz "LOAD_PTR_O"
str_STORE_PTR_O: .asciz "STORE_PTR_O"

str_PUSH_PTR: .asciz "PUSH_PTR"
str_POP_PTR: .asciz "POP_PTR"

str_EXEC_DYNAMIC: .asciz "EXEC_DYNAMIC"
str_RET_DYNAMIC: .asciz "RET_DYNAMIC"
str_GET_OP: .asciz "GET_OP"




.section .bss
token_buf: .space 256
val_buf: .space 256
reg_buf: .space 256
labels_array: .space 81920
call_stack: .space 81920
call_sp: .space 8
val_stack: .space 81920
val_sp: .space 8

ptr_stack: .space 81920
ptr_sp: .space 8
alloc_head: .space 8
gc_count: .space 8
gc_threshold: .space 8

argc_store: .space 8
argv_store: .space 8


.section .text

# ---------------------------------------------------------
# DIRECT THREADED VIRTUAL MACHINE
# ---------------------------------------------------------
.macro NEXT
    mov rax, [rsi]
    add rsi, 8
    jmp rax
.endm

# --- Opcode Handlers ---
op_load_const:
    movsd xmm0, [rsi]
    add rsi, 8
    mov rcx, [rsi]
    add rsi, 8
    movsd [rdi + rcx * 8], xmm0
    NEXT

# op_load_raw: stores a raw 64-bit value (pointer/integer) without float conversion
# Bytecode: [handler_ptr][raw_64bit_value][dest_reg]
op_load_raw:
    mov rax, [rsi]     # raw 64-bit value
    add rsi, 8
    mov rcx, [rsi]     # dest reg
    add rsi, 8
    mov [rbx + rcx * 8], rax
    NEXT

op_add:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    addsd xmm0, [rdi + r9 * 8]
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_lt:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    movsd xmm1, [rdi + r9 * 8]
    comisd xmm0, xmm1
    setb al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_jmp:
    mov rcx, [rsi]
    lea r8, [rip + labels_array]
    mov rsi, [r8 + rcx * 8]
    NEXT

op_jmp_f:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16
    movsd xmm0, [rdi + rcx * 8]
    pxor xmm1, xmm1
    ucomisd xmm0, xmm1
    jne .no_jump
    lea rcx, [rip + labels_array]
    mov rsi, [rcx + r8 * 8]
.no_jump:
    NEXT

op_print:
    mov rcx, [rsi]
    add rsi, 8

    push rsi
    push rdi
    sub rsp, 32
    movsd xmm1, [rdi + rcx * 8]
    movq rdx, xmm1
    lea rcx, [rip + debug_fmt]
    call printf
    add rsp, 32
    pop rdi
    pop rsi
    NEXT

op_eq:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov rax, [rdi + r8 * 8]
    cmp rax, [rdi + r9 * 8]
    sete al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_dict_new:
    mov r12, [rsi]
    add rsi, 8
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    mov rcx, 16
    call malloc
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    mov qword ptr [rax], 0
    mov qword ptr [rax+8], 0
    mov [rbx + r12 * 8], rax
    NEXT

op_dict_set:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov r10, [rbx + r12 * 8]
    mov r11, [rbx + r8 * 8]
    movsd xmm0, [rdi + r9 * 8]
    mov r13, [r10+8]
.dict_set_loop:
    cmp r13, 0
    je .dict_set_not_found
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    push r13
    sub rsp, 40
    mov rcx, r11
    mov rdx, [r13+8]
    call strcmp
    add rsp, 40
    pop r13
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
    cmp eax, 0
    je .dict_set_found
    mov r13, [r13]
    jmp .dict_set_loop
.dict_set_found:
    movsd [r13+16], xmm0
    NEXT
.dict_set_not_found:
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    sub rsp, 40
    sub rsp, 16
    movsd [rsp], xmm0
    mov rcx, 24
    call malloc
    movsd xmm0, [rsp]
    add rsp, 16
    add rsp, 40
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
    mov r14, [r10+8]
    mov [rax], r14
    mov [rax+8], r11
    movsd [rax+16], xmm0
    mov [r10+8], rax
    NEXT

op_dict_get:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov r10, [rbx + r8 * 8]
    cmp r10, 0
    je .dict_get_null
    mov r11, [rbx + r9 * 8]
    mov r13, [r10+8]
.dict_get_loop:
    cmp r13, 0
    je .dict_get_not_found
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    push r13
    sub rsp, 40
    mov rcx, r11
    mov rdx, [r13+8]
    call strcmp
    add rsp, 40
    pop r13
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
    cmp eax, 0
    je .dict_get_found
    mov r13, [r13]
    jmp .dict_get_loop
.dict_get_found:
    movsd xmm0, [r13+16]
    movsd [rdi + r12 * 8], xmm0
    NEXT
.dict_get_not_found:
.dict_get_null:
    pxor xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_alloc:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # size_reg
    add rsi, 16
    push rsi
    push rdi
    push rbx
    sub rsp, 40

    lea r9, [rip + gc_count]
    mov r10, [r9]
    inc r10
    mov [r9], r10
    cmp r10, 1000
    jl .skip_gc
    call run_gc
.skip_gc:

    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    add rcx, 16
    call malloc
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi

    mov qword ptr [rax], 0
    lea r9, [rip + alloc_head]
    mov r10, [r9]
    mov [rax+8], r10
    mov [r9], rax
    
    add rax, 16
    mov [rbx + r12 * 8], rax
    NEXT

run_gc:
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    push r15
    lea r8, [rip + alloc_head]
    mov rax, [r8]
.clear_loop:
    test rax, rax
    jz .mark_roots
    mov qword ptr [rax], 0
    mov rax, [rax+8]
    jmp .clear_loop

.mark_roots:
    # mark PTR_BANK (rbx)
    xor r15, r15
.ptr_bank_scan:
    mov rdx, [rbx + r15*8]
    call mark_if_valid
    inc r15
    cmp r15, 256
    jl .ptr_bank_scan

.mark_float_bank:
    # mark FLOAT_BANK (rdi)
    xor r15, r15
.float_bank_scan:
    mov rdx, [rdi + r15*8]
    call mark_if_valid
    inc r15
    cmp r15, 256
    jl .float_bank_scan

.mark_call_stack:
    lea r12, [rip + call_sp]
    mov r13, [r12]
    test r13, r13
    jz .sweep
    lea r14, [rip + call_stack]
    xor r15, r15
.call_scan:
    mov rdx, [r14 + r15*8]
    call mark_if_valid
    inc r15
    cmp r15, r13
    jl .call_scan

.sweep:
    lea r8, [rip + alloc_head]
    mov r9, r8
    mov rax, [r8]
.sweep_loop:
    test rax, rax
    jz .gc_done
    mov r10, [rax]
    cmp r10, 1
    je .keep_block
    mov r11, [rax+8]
    mov [r9], r11
    push rax
    push r9
    push r8
    push r8
    sub rsp, 32
    mov rcx, rax
    call free
    add rsp, 32
    pop r8
    pop r8
    pop r9
    pop rax
    mov rax, [r9]
    jmp .sweep_loop

.keep_block:
    mov qword ptr [rax], 0
    lea r9, [rax+8]
    mov rax, [r9]
    jmp .sweep_loop

.gc_done:
    lea r8, [rip + gc_count]
    mov qword ptr [r8], 0
    pop r15
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    ret

mark_if_valid:
    lea r8, [rip + alloc_head]
    mov rax, [r8]
.miv_loop:
    test rax, rax
    jz .miv_done
    lea r9, [rax+16]
    cmp rdx, r9
    jne .miv_next
    mov qword ptr [rax], 1
    ret
.miv_next:
    mov rax, [rax+8]
    jmp .miv_loop
.miv_done:
    ret

op_fread:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    mov r10, [rsi+24]
    add rsi, 32
    NEXT

op_fwrite:
    mov r8, [rsi]
    mov r9, [rsi+8]
    mov r10, [rsi+16]
    add rsi, 24
    NEXT

op_fclose:
    mov r8, [rsi]
    add rsi, 8
    NEXT

op_input:
    mov r8, [rsi]
    add rsi, 8
    NEXT

op_str_cat:
    mov r8, [rsi]
    mov r9, [rsi+8]
    mov r10, [rsi+16]
    add rsi, 24
    NEXT

op_sqrt:
    mov rcx, [rsi]
    mov r8, [rsi+8]
    add rsi, 16
    NEXT

op_sin:
    mov rcx, [rsi]
    mov r8, [rsi+8]
    add rsi, 16
    NEXT

op_cos:
    mov rcx, [rsi]
    mov r8, [rsi+8]
    add rsi, 16
    NEXT

op_pow:
    mov rcx, [rsi]
    mov r8, [rsi+8]
    mov r9, [rsi+16]
    add rsi, 24
    NEXT

op_panic:
    mov r8, [rsi]
    add rsi, 8
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    lea rcx, [rip + panic_msg]
    call printf
    lea rcx, [rip + stack_trace_msg]
    call printf
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    jmp vm_exit

op_free:
    mov r8, [rsi]        # ptr_reg
    add rsi, 8
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    mov rcx, [rbx + r8 * 8]
    call free
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    NEXT

op_fopen:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # path_reg
    add rsi, 16
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    mov rcx, [rbx + r8 * 8]    # arg1: filename ptr
    lea rdx, [rip + read_mode] # arg2: "r"

    push rcx
    push rdx
    push r8
    push r9
    
    sub rsp, 32
    mov rdx, rcx
    lea rcx, [rip + str_fmt]
    call printf
    add rsp, 32
    
    pop r9
    pop r8
    pop rdx
    pop rcx
    call fopen
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    mov [rbx + r12 * 8], rax   # store FILE* natively
    NEXT

op_fgetc:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # file_reg
    add rsi, 16
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    mov rcx, [rbx + r8 * 8]
    call fgetc
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    cvtsi2sd xmm0, eax         # char to double
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_load_b:
    mov rcx, [rsi]       # dest
    mov r8,  [rsi+8]     # ptr_reg
    mov r9,  [rsi+16]    # offset_reg
    add rsi, 24
    mov rax, [rbx + r8 * 8]    # ptr
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0        # offset
    xor r10, r10
    mov r10b, byte ptr [rax + rdx] # load byte
    cvtsi2sd xmm0, r10d        # convert byte to double
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_store_b:
    mov r8,  [rsi]       # ptr_reg
    mov r9,  [rsi+8]     # offset_reg
    mov r10, [rsi+16]    # val_reg
    add rsi, 24
    mov rax, [rbx + r8 * 8]    # ptr
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0        # offset
    movsd xmm0, [rdi + r10 * 8]
    cvttsd2si rcx, xmm0        # val
    mov byte ptr [rax + rdx], cl
    NEXT

op_call:
    mov rcx, [rsi]       # read label index
    add rsi, 8
    lea r8, [rip + call_sp]
    mov r9, [r8]         # r9 = call_sp
    lea r10, [rip + call_stack]
    mov [r10 + r9 * 8], rsi # push next RIP
    inc r9
    mov [r8], r9
    lea r11, [rip + labels_array]
    mov rsi, [r11 + rcx * 8]
    NEXT

op_ret:
    lea r8, [rip + call_sp]
    mov r9, [r8]         # r9 = call_sp
    dec r9
    mov [r8], r9
    lea r10, [rip + call_stack]
    mov rsi, [r10 + r9 * 8]
    NEXT

op_push:
    mov rcx, [rsi]       # reg num
    add rsi, 8
    lea r8, [rip + val_sp]
    mov r9, [r8]
    lea r10, [rip + val_stack]
    mov rax, [rdi + rcx * 8]
    mov [r10 + r9 * 8], rax
    inc r9
    mov [r8], r9
    NEXT

op_pop:
    mov rcx, [rsi]
    add rsi, 8
    lea r8, [rip + val_sp]
    mov r9, [r8]
    dec r9
    mov [r8], r9
    lea r10, [rip + val_stack]
    mov rax, [r10 + r9 * 8]
    mov [rdi + rcx * 8], rax
    NEXT

op_print_c:
    mov r8, [rsi]        # char_reg
    add rsi, 8
    push rsi
    push rdi
    sub rsp, 32
    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    mov rdx, rcx
    lea rcx, [rip + char_fmt]
    call printf
    add rsp, 32
    pop rdi
    pop rsi
    NEXT

op_print_str:
    mov r8, [rsi]        # ptr_reg (register number)
    add rsi, 8
    mov r11, [rbx + r8 * 8]  # r11 = raw char* pointer (callee-saved on Windows)
    push rsi
    push rdi
    push rbx             # extra push to align stack to 16
    sub rsp, 40          # shadow space
    lea rcx, [rip + str_fmt]
    mov rdx, r11
    call printf
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    NEXT

op_sub:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    subsd xmm0, [rdi + r9 * 8]
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_mul:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    mulsd xmm0, [rdi + r9 * 8]
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_div:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    divsd xmm0, [rdi + r9 * 8]
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_gt:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    movsd xmm1, [rdi + r9 * 8]
    comisd xmm0, xmm1
    seta al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_neq:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    mov rax, [rdi + r8 * 8]
    cmp rax, [rdi + r9 * 8]
    setne al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_mov:
    mov rcx, [rsi]; mov r8, [rsi+8]; add rsi, 16
    mov rax, [rdi + r8 * 8]
    mov [rdi + rcx * 8], rax
    NEXT

op_not:
    mov rcx, [rsi]; mov r8, [rsi+8]; add rsi, 16
    mov rax, [rdi + r8 * 8]
    test rax, rax
    setz al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_store_ptr:
    mov rcx, [rsi]; mov r8, [rsi+8]; add rsi, 16
    mov rax, [rbx + rcx * 8]   # rax = pointer
    mov rdx, [rbx + r8 * 8]    # rdx = value
    mov [rax], rdx
    NEXT

op_load_ptr:
    mov rcx, [rsi]; mov r8, [rsi+8]; add rsi, 16
    mov rax, [rbx + r8 * 8]    # rax = pointer
    mov rdx, [rax]
    mov [rbx + rcx * 8], rdx
    NEXT

op_puts:
    push rsi
    push rdi
    sub rsp, 32
    lea rcx, [rip + str_fmt]
    mov rdx, rsi            # rsi points right at the inline string
    call printf
    add rsp, 32
    pop rdi
    pop rsi
    # advance rsi past the null-terminated string
    .puts_skip:
        mov al, byte ptr [rsi]
        inc rsi
        cmp al, 0
        jne .puts_skip
    # align rsi to next 8-byte boundary
    add rsi, 7
    and rsi, -8
    NEXT

op_load_f:
    mov rcx, [rsi]       # dest (float bank)
    mov r8,  [rsi+8]     # ptr_reg (POINTER BANK)
    mov r9,  [rsi+16]    # offset_reg (float bank)
    add rsi, 24
    mov rax, [rbx + r8 * 8]    # ptr from POINTER BANK
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0        # offset
    movsd xmm0, [rax + rdx]    # load 64-bit float
    movsd [rdi + rcx * 8], xmm0 # store in float bank
    NEXT

op_store_f:
    mov r8,  [rsi]       # ptr_reg (POINTER BANK)
    mov r9,  [rsi+8]     # offset_reg (float bank)
    mov r10, [rsi+16]    # val_reg (float bank)
    add rsi, 24
    mov rax, [rbx + r8 * 8]    # ptr from POINTER BANK
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0        # offset
    movsd xmm0, [rdi + r10 * 8] # val from float bank
    movsd [rax + rdx], xmm0    # store 64-bit float
    NEXT


op_load_ptr_o:
    mov r8, [rsi]; mov r9, [rsi+8]; mov r10, [rsi+16]; add rsi, 24
    mov rax, [rbx + r9 * 8]
    movsd xmm0, [rdi + r10 * 8]
    cvttsd2si rcx, xmm0
    mov rdx, [rax + rcx]
    mov [rbx + r8 * 8], rdx
    NEXT

op_store_ptr_o:
    mov r8, [rsi]; mov r9, [rsi+8]; mov r10, [rsi+16]; add rsi, 24
    mov rax, [rbx + r8 * 8]
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rcx, xmm0
    mov rdx, [rbx + r10 * 8]
    mov [rax + rcx], rdx
    NEXT



op_push_ptr:
    mov rcx, [rsi]; add rsi, 8
    mov rax, [rbx + rcx * 8]
    lea r8, [rip + ptr_sp]
    mov rdx, [r8]
    lea r9, [rip + ptr_stack]
    mov [r9 + rdx * 8], rax
    inc qword ptr [r8]
    NEXT

op_pop_ptr:
    mov rcx, [rsi]; add rsi, 8
    lea r8, [rip + ptr_sp]
    dec qword ptr [r8]
    mov rdx, [r8]
    lea r9, [rip + ptr_stack]
    mov rax, [r9 + rdx * 8]
    mov [rbx + rcx * 8], rax
    NEXT

op_halt:
    jmp vm_exit


op_exec_dynamic:
    mov r8, [rsi]
    add rsi, 8
    lea r9, [rip + call_sp]
    mov r10, [r9]
    lea r11, [rip + call_stack]
    mov [r11 + r10 * 8], rsi
    inc r10
    mov [r9], r10
    mov rsi, [rbx + r8 * 8]
    NEXT

op_ret_dynamic:
    lea r8, [rip + call_sp]
    mov r9, [r8]
    dec r9
    mov [r8], r9
    lea r10, [rip + call_stack]
    mov rsi, [r10 + r9 * 8]
    NEXT


# --- Main Entry ---
main:
    mov [rip + argc_store], rcx
    mov [rip + argv_store], rdx
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 40      # align stack for Windows x64 ABI

    # Allocate VM Float Registers Array (rdi) â€” 256 regs * 8 bytes
    mov rcx, 2048
    call malloc
    mov rdi, rax
    
    # Allocate VM Pointer Registers Array (rbx) â€” 256 raw ptrs * 8 bytes
    mov rcx, 2048
    call malloc
    mov rbx, rax
    
    # Allocate Bytecode Array â€” 512KB for complex programs
    mov rcx, 524288
    call malloc
    mov r12, rax
    mov r13, rax
    
    # ---------------------------------------------------------
    # ASSEMBLY LEXER & PARSER
    # Reads .nxasm file from argv[1] or boot.nxasm by default
    # rbp+16 = argc, rbp+24 = argv on Windows x64
    # ---------------------------------------------------------
    mov rcx, [rip + argc_store]
    cmp rcx, 1
    jle .use_default_file
    mov rdx, [rip + argv_store]
    mov rcx, [rdx + 8]   # argv[1]
    jmp .open_file

.use_default_file:
    lea rcx, [rip + file_name]

.open_file:
    lea rdx, [rip + read_mode]
    call fopen
    cmp rax, 0
    jne .file_opened
    lea rcx, [rip + err_msg]
    call printf
    jmp .end
    
.file_opened:
    mov r14, rax     # r14 = FILE pointer

.read_loop:
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + token_buf]
    call fscanf
    cmp eax, 0       # EOF check
    jle .parse_done
    
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    sub rsp, 32
    lea rcx, [rip + str_fmt]
    lea rdx, [rip + token_buf]
    call printf
    add rsp, 32
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    
    lea rax, [rip + token_buf]
    cmp byte ptr [rax], '#'
    jne .check_LOAD
    
.comment_loop:
    mov rcx, r14
    call fgetc
    cmp eax, -1
    je .parse_done
    cmp eax, 10
    jne .comment_loop
    jmp .read_loop
    
.check_LOAD:
    # check LOAD
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD]
    call strcmp
    cmp eax, 0
    jne .check_ADD
    
    lea rax, [rip + op_load_const]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + val_buf]
    call fscanf
    lea rcx, [rip + val_buf]
    call atof
    movsd [r13], xmm0
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_ADD:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_ADD]
    call strcmp
    cmp eax, 0
    jne .check_PRINT
    
    lea rax, [rip + op_add]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_PRINT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PRINT]
    call strcmp
    cmp eax, 0
    jne .check_HALT
    
    lea rax, [rip + op_print]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_HALT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_HALT]
    call strcmp
    cmp eax, 0
    jne .check_LT
    
    lea rax, [rip + op_halt]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_LT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LT]
    call strcmp
    cmp eax, 0
    jne .check_EQ
    
    lea rax, [rip + op_lt]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_EQ:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_EQ]
    call strcmp
    cmp eax, 0
    jne .check_LABEL
    
    lea rax, [rip + op_eq]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_LABEL:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LABEL]
    call strcmp
    cmp eax, 0
    jne .check_JMP
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    lea r8, [rip + labels_array]
    mov [r8 + rax * 8], r13      # labels_array[id] = current r13
    jmp .read_loop

.check_JMP:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_JMP]
    call strcmp
    cmp eax, 0
    jne .check_JMP_F
    
    lea rax, [rip + op_jmp]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_JMP_F:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_JMP_F]
    call strcmp
    cmp eax, 0
    jne .check_LOAD_STR
    
    lea rax, [rip + op_jmp_f]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_LOAD_STR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD_STR]
    call strcmp
    cmp eax, 0
    jne .check_FOPEN
    
    # Emit op_load_raw (stores pointer, NOT float)
    lea rax, [rip + op_load_raw]
    mov [r13], rax
    add r13, 8
    
    # Read the string argument and strdup it â€” store raw pointer
    push rdi
    sub rsp, 32
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + val_buf]
    call fscanf
    lea rcx, [rip + val_buf]
    call strdup
    add rsp, 32
    pop rdi
    mov [r13], rax    # raw pointer (char*)
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_FOPEN:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_FOPEN]
    call strcmp
    cmp eax, 0
    jne .check_FGETC
    
    lea rax, [rip + op_fopen]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_FGETC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_FGETC]
    call strcmp
    cmp eax, 0
    jne .check_PRINT_C
    
    lea rax, [rip + op_fgetc]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_PRINT_C:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PRINT_C]
    call strcmp
    cmp eax, 0
    jne .check_PRINT_STR
    
    lea rax, [rip + op_print_c]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_PRINT_STR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PRINT_STR]
    call strcmp
    cmp eax, 0
    jne .check_SUB
    
    lea rax, [rip + op_print_str]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop


.check_SUB:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_SUB]
    call strcmp
    cmp eax, 0
    jne .check_MUL
    
    lea rax, [rip + op_sub]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_MUL:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_MUL]
    call strcmp
    cmp eax, 0
    jne .check_DIV
    
    lea rax, [rip + op_mul]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_DIV:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_DIV]
    call strcmp
    cmp eax, 0
    jne .check_GT
    
    lea rax, [rip + op_div]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_GT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_GT]
    call strcmp
    cmp eax, 0
    jne .check_NEQ
    
    lea rax, [rip + op_gt]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_NEQ:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_NEQ]
    call strcmp
    cmp eax, 0
    jne .check_MOV
    
    lea rax, [rip + op_neq]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_MOV:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_MOV]
    call strcmp
    cmp eax, 0
    jne .check_NOT
    
    lea rax, [rip + op_mov]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_NOT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_NOT]
    call strcmp
    cmp eax, 0
    jne .check_STORE_PTR
    
    lea rax, [rip + op_not]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_STORE_PTR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_STORE_PTR]
    call strcmp
    cmp eax, 0
    jne .check_LOAD_PTR
    
    lea rax, [rip + op_store_ptr]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_LOAD_PTR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD_PTR]
    call strcmp
    cmp eax, 0
    jne .check_PUTS
    
    lea rax, [rip + op_load_ptr]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

# PUTS: embeds a literal string into the bytecode stream
# The string is read from the source line (rest of line via fgets-like approach)
# We use a helper that reads until newline from the file
.check_PUTS:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PUTS]
    call strcmp
    cmp eax, 0
    jne .check_ALLOC
    
    # Emit op_puts handler address
    lea rax, [rip + op_puts]
    mov [r13], rax
    add r13, 8
    
    # Read the inline string argument using the rest of the line
    # We use scan_fmt to get next token (space-delimited argument)
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + val_buf]
    call fscanf
    # val_buf now has the string â€” embed it directly into bytecode
    # copy bytes from val_buf into bytecode array r13 using r15 as src ptr
    push r15
    lea r15, [rip + val_buf]
    .puts_embed_loop:
        mov al, byte ptr [r15]
        mov byte ptr [r13], al
        inc r15
        inc r13
        cmp al, 0
        jne .puts_embed_loop
    pop r15
    # align r13 to next 8-byte boundary
    add r13, 7
    and r13, -8
    jmp .read_loop

.check_ALLOC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_ALLOC]
    call strcmp
    cmp eax, 0
    jne .check_DICT_NEW
    
    lea rax, [rip + op_alloc]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_DICT_NEW:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_DICT_NEW]
    call strcmp
    cmp eax, 0
    jne .check_DICT_SET
    lea rax, [rip + op_dict_new]
    mov [r13], rax
    add r13, 8
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_DICT_SET:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_DICT_SET]
    call strcmp
    cmp eax, 0
    jne .check_DICT_GET
    lea rax, [rip + op_dict_set]
    mov [r13], rax
    add r13, 8
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_DICT_GET:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_DICT_GET]
    call strcmp
    cmp eax, 0
    jne .check_FREE
    lea rax, [rip + op_dict_get]
    mov [r13], rax
    add r13, 8
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_FREE:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_FREE]
    call strcmp
    cmp eax, 0
    jne .check_LOAD_B
    
    lea rax, [rip + op_free]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_LOAD_B:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD_B]
    call strcmp
    cmp eax, 0
    jne .check_STORE_B
    
    lea rax, [rip + op_load_b]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_STORE_B:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_STORE_B]
    call strcmp
    cmp eax, 0
    jne .check_CALL
    
    lea rax, [rip + op_store_b]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_CALL:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_CALL]
    call strcmp
    cmp eax, 0
    jne .check_RET
    
    lea rax, [rip + op_call]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_RET:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_RET]
    call strcmp
    cmp eax, 0
    jne .check_PUSH
    
    lea rax, [rip + op_ret]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_PUSH:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PUSH]
    call strcmp
    cmp eax, 0
    jne .check_POP
    
    lea rax, [rip + op_push]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_POP:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_POP]
    call strcmp
    cmp eax, 0
    jne .check_LOAD_F
    
    lea rax, [rip + op_pop]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_LOAD_F:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD_F]
    call strcmp
    cmp eax, 0
    jne .check_STORE_F
    
    lea rax, [rip + op_load_f]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_STORE_F:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_STORE_F]
    call strcmp
    cmp eax, 0
    jne .check_LOAD_PTR_O
    jmp .store_f_match

.check_LOAD_PTR_O:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD_PTR_O]
    call strcmp
    cmp eax, 0
    jne .check_STORE_PTR_O
    lea rax, [rip + op_load_ptr_o]
    mov [r13], rax
    add r13, 8

    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop


.check_STORE_PTR_O:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_STORE_PTR_O]
    call strcmp
    cmp eax, 0
    jne .check_PUSH_PTR
    lea rax, [rip + op_store_ptr_o]
    mov [r13], rax
    add r13, 8

    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop


.check_PUSH_PTR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PUSH_PTR]
    call strcmp
    cmp eax, 0
    jne .check_POP_PTR
    
    lea rax, [rip + op_push_ptr]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    jmp .read_loop


.check_POP_PTR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_POP_PTR]
    call strcmp
    cmp eax, 0
    jne .check_PANIC
    
    lea rax, [rip + op_pop_ptr]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    jmp .read_loop


.store_f_match:
    
    lea rax, [rip + op_store_f]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_PANIC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PANIC]
    call strcmp
    cmp eax, 0
    jne .check_GET_OP
    lea rax, [rip + op_panic]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_GET_OP:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_GET_OP]
    call strcmp
    cmp eax, 0
    jne .check_EXEC_DYNAMIC
    
    # Read opcode string
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + val_buf]
    call fscanf
    
    # Check PRINT
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_PRINT]
    call strcmp
    cmp eax, 0
    jne .get_op_add
    lea r15, [rip + op_print]
    jmp .get_op_done
.get_op_add:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ADD]
    call strcmp
    cmp eax, 0
    jne .get_op_load
    lea r15, [rip + op_add]
    jmp .get_op_done
.get_op_load:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_LOAD]
    call strcmp
    cmp eax, 0
    jne .get_op_pop
    lea r15, [rip + op_load_const]
    jmp .get_op_done
.get_op_pop:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_POP]
    call strcmp
    cmp eax, 0
    jne .get_op_push
    lea r15, [rip + op_pop]
    jmp .get_op_done
.get_op_push:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_PUSH]
    call strcmp
    cmp eax, 0
    jne .get_op_halt
    lea r15, [rip + op_push]
    jmp .get_op_done
.get_op_halt:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_HALT]
    call strcmp
    cmp eax, 0
    jne .get_op_ret_dyn
    lea r15, [rip + op_halt]
    jmp .get_op_done
.get_op_ret_dyn:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_RET_DYNAMIC]
    call strcmp
    cmp eax, 0
    jne .get_op_exec_dyn
    lea r15, [rip + op_ret_dynamic]
    jmp .get_op_done
.get_op_exec_dyn:
    lea r15, [rip + op_exec_dynamic]
.get_op_done:
    lea rax, [rip + op_load_raw]
    mov [r13], rax
    add r13, 8
    
    mov [r13], r15
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_EXEC_DYNAMIC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_EXEC_DYNAMIC]
    call strcmp
    cmp eax, 0
    jne .check_RET_DYNAMIC
    
    lea rax, [rip + op_exec_dynamic]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_RET_DYNAMIC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_RET_DYNAMIC]
    call strcmp
    cmp eax, 0
    jne .parse_error
    
    lea rax, [rip + op_ret_dynamic]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.parse_error:
    jmp .read_loop
.parse_done:
    mov rcx, r14
    call fclose
    
    # ---------------------------------------------------------
    # EXECUTE THE COMPILED BYTECODE
    # ---------------------------------------------------------
    lea rcx, [rip + init_msg]
    call printf
    
    mov rsi, r12        # Start of bytecode
    NEXT

vm_exit:
    lea rcx, [rip + time_msg]
    call printf

.end:
    xor eax, eax
    add rsp, 40
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rsi
    pop rbx
    pop rbp
    ret
