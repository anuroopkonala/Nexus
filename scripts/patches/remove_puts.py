import re

with open("nexus_core.s", "r", encoding="utf-8") as f:
    c = f.read()

c = c.replace("""op_dict_set:
    mov r12, [rsi]
    mov r8, [rsi+8]
    push rsi
    push rdi
    push rbx
    sub rsp, 32
    mov rcx, [rbx + r8 * 8]
    call puts
    add rsp, 32
    pop rbx
    pop rdi
    pop rsi""", """op_dict_set:
    mov r12, [rsi]""")

c = c.replace("""op_dict_get:
    mov r12, [rsi]
    mov r9, [rsi+16]
    push rsi
    push rdi
    push rbx
    sub rsp, 32
    mov rcx, [rbx + r9 * 8]
    call puts
    add rsp, 32
    pop rbx
    pop rdi
    pop rsi""", """op_dict_get:
    mov r12, [rsi]""")

with open("nexus_core.s", "w", encoding="utf-8") as f:
    f.write(c)
