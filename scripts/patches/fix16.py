with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
c = re.sub(r'    push rax\n    sub rsp, 32\n    lea rcx, \[rip \+ fmt_rcx\]\n    mov rdx, rax\n    call printf\n    add rsp, 32\n    pop rax\n', '', c)
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
