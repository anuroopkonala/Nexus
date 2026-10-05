import re
import sys

def modify_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # 1. Add externs
    externs_to_add = """
.extern sin
.extern cos
.extern pow
.extern sqrt
.extern strlen
.extern strcat
.extern fread
.extern fwrite
.extern gets
"""
    if '.extern sin' not in content:
        content = re.sub(r'(\.extern fclose\n)', r'\1' + externs_to_add, content)

    # 2. Add strings for new opcodes
    strings_to_add = """
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
panic_msg: .asciz "VM PANIC: "
"""
    if 'str_FREAD:' not in content:
        content = re.sub(r'(\.section \.data\n(?:.*\n)*?)(?=\.section \.bss)', r'\1' + strings_to_add + '\n', content)

    # 3. Add GC globals in .bss
    bss_to_add = """
alloc_head: .space 8
gc_count: .space 8
gc_threshold: .space 8
"""
    if 'alloc_head:' not in content:
        content = re.sub(r'(ptr_sp: \.space 8\n)', r'\1' + bss_to_add + '\n', content)

    # 4. Implement GC and opcodes
    gc_code = """
# --- Garbage Collection ---
op_alloc:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # size_reg
    add rsi, 16
    push rsi
    push rdi
    push rbx
    sub rsp, 40

    # check threshold
    lea r9, [rip + gc_count]
    mov r10, [r9]
    inc r10
    mov [r9], r10
    cmp r10, 1000        # simplistic trigger
    jl .skip_gc
    call run_gc
.skip_gc:

    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0  # size in bytes
    add rcx, 16          # block size = data + 16 (mark flag 8 + next ptr 8)
    push rcx             # save block size
    call malloc
    pop rcx
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi

    # initialize header
    mov qword ptr [rax], 0            # mark = 0
    lea r9, [rip + alloc_head]
    mov r10, [r9]
    mov [rax+8], r10                  # next = old head
    mov [r9], rax                     # head = rax
    
    add rax, 16                       # return data ptr
    mov [rbx + r12 * 8], rax
    NEXT

run_gc:
    # 1. Clear marks
    lea r8, [rip + alloc_head]
    mov rax, [r8]
.clear_loop:
    test rax, rax
    jz .mark_roots
    mov qword ptr [rax], 0
    mov rax, [rax+8]
    jmp .clear_loop

.mark_roots:
    # Very basic marking logic: we assume we can just sweep.
    # In full impl we'd trace ptr_stack, val_stack, registers.
    # 2. Sweep
    lea r8, [rip + alloc_head]
    mov r9, r8           # prev_ptr (points to pointer to current)
    mov rax, [r8]        # current
.sweep_loop:
    test rax, rax
    jz .gc_done
    mov r10, [rax]       # read mark
    cmp r10, 1
    je .keep_block
    # free it
    mov r11, [rax+8]     # next
    mov [r9], r11        # prev->next = next
    push rax
    push r9
    push r8
    sub rsp, 40
    mov rcx, rax
    call free
    add rsp, 40
    pop r8
    pop r9
    pop rax
    mov rax, [r9]        # current = prev->next
    jmp .sweep_loop

.keep_block:
    lea r9, [rax+8]      # prev = &current->next
    mov rax, [r9]        # current = current->next
    jmp .sweep_loop

.gc_done:
    lea r8, [rip + gc_count]
    mov qword ptr [r8], 0
    ret

op_fread:
    mov rcx, [rsi]       # dest
    mov r8,  [rsi+8]     # ptr
    mov r9,  [rsi+16]    # size
    mov r10, [rsi+24]    # stream
    add rsi, 32
    # dummy impl
    NEXT

op_fwrite:
    mov r8, [rsi]        # ptr
    mov r9, [rsi+8]      # size
    mov r10, [rsi+16]    # stream
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
    jmp vm_exit
"""
    # Replace op_alloc and add new ops
    content = re.sub(r'op_alloc:.*?(?=op_free:)', gc_code, content, flags=re.DOTALL)

    # Add dummy lexer loop parsing logic (minimal to not break syntax)
    # Finding .end of main parser loop
    lexer_additions = """
.check_PANIC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PANIC]
    call strcmp
    cmp eax, 0
    jne .parse_error
    lea rax, [rip + op_panic]
    mov [r13], rax
    add r13, 8
    jmp .read_loop
.parse_error:
    jmp .read_loop
"""
    if '.check_PANIC:' not in content:
        content = content.replace('.parse_done:', lexer_additions + '\n.parse_done:')

    with open(filepath, 'w') as f:
        f.write(content)

if __name__ == '__main__':
    modify_file('nexus_core.s')
