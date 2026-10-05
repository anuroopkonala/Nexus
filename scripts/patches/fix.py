with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
c = re.sub(r'\.print_bad_token:.*?\.parse_done:', '.print_bad_token:\n    sub rsp, 32\n    lea rcx, [rip + str_fmt]\n    lea rdx, [rip + token_buf]\n    call printf\n    mov rcx, 0\n    call fflush\n    add rsp, 32\n\n.parse_done:', c, flags=re.DOTALL)
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
