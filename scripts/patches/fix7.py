with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
c = re.sub(r'\.read_loop:', '    lea rcx, [rip + init_msg]\n    call printf\n    mov rcx, 0\n    call fflush\n\n.read_loop:', c, flags=re.DOTALL)
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
