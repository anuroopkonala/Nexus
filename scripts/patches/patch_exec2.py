import re
with open("nexus_core.s", "r", encoding="utf-8") as f:
    c = f.read()

c = c.replace("""op_exec_dynamic:
    mov rcx, [rsi]
    add rsi, 8
    lea r8, [rip + call_sp]
    mov r9, [r8]
    lea r10, [rip + call_stack]
    mov [r10 + r9 * 8], rsi
    inc r9
    mov [r8], r9
    lea rsi, [rdi + rcx * 8]
    NEXT""", """op_exec_dynamic:
    mov rcx, [rsi]
    add rsi, 8
    lea r8, [rip + call_sp]
    mov r9, [r8]
    lea r10, [rip + call_stack]
    mov [r10 + r9 * 8], rsi
    inc r9
    mov [r8], r9
    mov rsi, [rbx + rcx * 8]
    NEXT""")

with open("nexus_core.s", "w", encoding="utf-8") as f:
    f.write(c)
