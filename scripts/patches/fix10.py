with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
c = re.sub(r'cmp eax, 1.*?\n', 'push rax\n    lea rcx, [rip + token_fmt]\n    lea rdx, [rip + token_buf]\n    call printf\n    mov rcx, 0\n    call fflush\n    pop rax\n    cmp eax, 1\n', c)
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
