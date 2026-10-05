with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
c = re.sub(r'\.check_GET_OP:\n    lea rcx, \[rip \+ token_buf\]\n    lea rdx, \[rip \+ str_GET_OP\]\n    call strcmp', '.check_GET_OP:\n    push rax\n    sub rsp, 40\n    lea rcx, [rip + str_hex_fmt]\n    lea rdx, [rip + token_buf]\n    movzx r8, byte ptr [rdx]\n    movzx r9, byte ptr [rdx+1]\n    movzx r10, byte ptr [rdx+2]\n    push r10\n    movzx r10, byte ptr [rdx+3]\n    push r10\n    movzx r10, byte ptr [rdx+4]\n    push r10\n    movzx r10, byte ptr [rdx+5]\n    push r10\n    call printf\n    add rsp, 72\n    pop rax\n    lea rcx, [rip + token_buf]\n    lea rdx, [rip + str_GET_OP]\n    call strcmp', c)
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
