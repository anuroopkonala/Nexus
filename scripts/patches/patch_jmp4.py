import re
with open("nexus_core.s", "r", encoding="utf-8") as f:
    c = f.read()

c = c.replace("""op_jmp_o:
    mov rcx, [rsi]
    lea rsi, [rdi + rcx]
    NEXT

op_jmp_f_o:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16
    movsd xmm0, [rdi + rcx * 8]
    pxor xmm1, xmm1
    ucomisd xmm0, xmm1
    jne .no_jump_f_o
    lea rsi, [rdi + r8]
.no_jump_f_o:
    NEXT""", """op_jmp_o:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9, [rbx + rcx * 8]
    lea rsi, [r9 + r8]
    NEXT

op_jmp_f_o:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r10, [rsi+16]
    add rsi, 24
    movsd xmm0, [rdi + rcx * 8]
    pxor xmm1, xmm1
    ucomisd xmm0, xmm1
    jne .no_jump_f_o
    mov r9, [rbx + r8 * 8]
    lea rsi, [r9 + r10]
.no_jump_f_o:
    NEXT""")

with open("nexus_core.s", "w", encoding="utf-8") as f:
    f.write(c)
