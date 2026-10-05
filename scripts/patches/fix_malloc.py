import re
with open("nexus_core.s", "r", encoding="utf-8") as f:
    c = f.read()

c = c.replace("""    sub rsp, 40
    sub rsp, 16
    movsd [rsp], xmm0
    mov rcx, 24
    call malloc
    movsd xmm0, [rsp]
    add rsp, 16
    add rsp, 40""", """    sub rsp, 16
    movsd [rsp], xmm0
    sub rsp, 40
    mov rcx, 24
    call malloc
    add rsp, 40
    movsd xmm0, [rsp]
    add rsp, 16""")

with open("nexus_core.s", "w", encoding="utf-8") as f:
    f.write(c)
