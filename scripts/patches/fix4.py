with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
c = re.sub(r'\.parse_done:.*?call exit', '.parse_done:\n    sub rsp, 32\n    mov rcx, 0\n    call exit', c, flags=re.DOTALL)
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
