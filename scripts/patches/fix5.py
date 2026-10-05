with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
c = re.sub(r'\.print_bad_token:.*?\n\n\.parse_done:', '.print_bad_token:\n    sub rsp, 32\n    mov rcx, 1\n    call exit\n\n.parse_done:', c, flags=re.DOTALL)
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
