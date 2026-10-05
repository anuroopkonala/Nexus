with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
c = re.sub(r'    mov r12, rax\n    mov r13, rax\n    \n    # -+', '    mov r12, rax\n    mov r13, rax\n\n    # Allocate Call Stack (r15)\n    mov rcx, 65536\n    call malloc\n    mov r15, rax\n    \n    # ---------------------------------------------------------', c)
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
