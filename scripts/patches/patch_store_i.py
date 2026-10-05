import re
with open("nexus_core.s", "r", encoding="utf-8") as f:
    c = f.read()

# Add string
c = c.replace('str_STORE_F: .asciz "STORE_F"', 'str_STORE_F: .asciz "STORE_F"\nstr_STORE_I: .asciz "STORE_I"')

# Add opcode
c = c.replace('op_store_f:', """op_store_i:
    mov r8,  [rsi]       # ptr_reg
    mov r9,  [rsi+8]     # offset_reg
    mov r10, [rsi+16]    # val_reg (float bank)
    add rsi, 24
    mov rax, [rbx + r8 * 8]
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0  # offset
    movsd xmm0, [rdi + r10 * 8]
    cvttsd2si rcx, xmm0  # integer value
    mov [rax + rdx], rcx # store 64-bit int
    NEXT

op_store_f:""")

# Add check
c = c.replace('.check_STORE_F:\n    lea rcx, [rip + token_buf]', """.check_STORE_I:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_STORE_I]
    call strcmp
    cmp eax, 0
    jne .check_STORE_F
    lea rax, [rip + op_store_i]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
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

.check_STORE_F:
    lea rcx, [rip + token_buf]""")

# Add get_op
c = c.replace('.get_op_store_f:\n    lea rcx, [rip + val_buf]', """.get_op_store_i:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_STORE_I]
    call strcmp
    cmp eax, 0
    jne .get_op_store_f
    lea r15, [rip + op_store_i]
    jmp .get_op_done
.get_op_store_f:
    lea rcx, [rip + val_buf]""")

with open("nexus_core.s", "w", encoding="utf-8") as f:
    f.write(c)
