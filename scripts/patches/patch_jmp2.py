import re
with open("nexus_core.s", "r", encoding="utf-8") as f:
    c = f.read()

# Add check block
c = c.replace('.check_JMP_F:\n    lea rcx, [rip + token_buf]', """.check_JMP_O:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_JMP_O]
    call strcmp
    cmp eax, 0
    jne .check_JMP_F_O
    lea rax, [rip + op_jmp_o]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_JMP_F_O:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_JMP_F_O]
    call strcmp
    cmp eax, 0
    jne .check_JMP_F
    lea rax, [rip + op_jmp_f_o]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_JMP_F:
    lea rcx, [rip + token_buf]""")

# Add get_op block
c = c.replace('.get_op_jmp_f:\n    lea rcx, [rip + val_buf]', """.get_op_jmp_o:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_JMP_O]
    call strcmp
    cmp eax, 0
    jne .get_op_jmp_f_o
    lea r15, [rip + op_jmp_o]
    jmp .get_op_done
.get_op_jmp_f_o:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_JMP_F_O]
    call strcmp
    cmp eax, 0
    jne .get_op_jmp_f
    lea r15, [rip + op_jmp_f_o]
    jmp .get_op_done
.get_op_jmp_f:
    lea rcx, [rip + val_buf]""")

with open("nexus_core.s", "w", encoding="utf-8") as f:
    f.write(c)
