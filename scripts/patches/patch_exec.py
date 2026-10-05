import re
with open("nexus_core.s", "r", encoding="utf-8") as f:
    c = f.read()

# Add string
c = c.replace('str_CALL: .asciz "CALL"', 'str_CALL: .asciz "CALL"\nstr_EXEC_DYNAMIC: .asciz "EXEC_DYNAMIC"')

# Add opcode
c = c.replace('op_call:', """op_exec_dynamic:
    mov rcx, [rsi]
    add rsi, 8
    lea r8, [rip + call_sp]
    mov r9, [r8]
    lea r10, [rip + call_stack]
    mov [r10 + r9 * 8], rsi
    inc r9
    mov [r8], r9
    lea rsi, [rdi + rcx * 8]
    NEXT

op_call:""")

# Add check
c = c.replace('.check_CALL:\n    lea rcx, [rip + token_buf]', """.check_EXEC_DYNAMIC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_EXEC_DYNAMIC]
    call strcmp
    cmp eax, 0
    jne .check_CALL
    lea rax, [rip + op_exec_dynamic]
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

.check_CALL:
    lea rcx, [rip + token_buf]""")

# Add get_op
c = c.replace('.get_op_call:\n    lea rcx, [rip + val_buf]', """.get_op_exec_dynamic:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_EXEC_DYNAMIC]
    call strcmp
    cmp eax, 0
    jne .get_op_call
    lea r15, [rip + op_exec_dynamic]
    jmp .get_op_done
.get_op_call:
    lea rcx, [rip + val_buf]""")

with open("nexus_core.s", "w", encoding="utf-8") as f:
    f.write(c)
