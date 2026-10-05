with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
c = re.sub(r'\.read_loop:\n    mov rcx, r14\n    lea rdx, \[rip \+ scan_fmt\]\n    lea r8, \[rip \+ token_buf\]\n    call fscanf\n    cmp eax, 1', '.read_loop:\n    mov rcx, r14\n    lea rdx, [rip + scan_fmt]\n    lea r8, [rip + token_buf]\n    call fscanf\n    push rax\n    sub rsp, 40\n    lea rcx, [rip + str_fmt]\n    lea rdx, [rip + token_buf]\n    call printf\n    mov rcx, 0\n    call fflush\n    add rsp, 40\n    pop rax\n    cmp eax, 1', c)
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
