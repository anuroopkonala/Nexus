with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
c = re.sub(r'push rsi\n    sub rsp, 32', 'push rsi\n    sub rsp, 40', c)
c = re.sub(r'add rsp, 32\n    pop rsi', 'add rsp, 40\n    pop rsi', c)

# wait, op_print has:
# push rsi
# sub rsp, 32
c = re.sub(r'push rdi\n    sub rsp, 32', 'push rdi\n    sub rsp, 40', c)
c = re.sub(r'add rsp, 32\n    pop rdi', 'add rsp, 40\n    pop rdi', c)

c = re.sub(r'push rax\n    sub rsp, 32', 'push rax\n    sub rsp, 40', c)
c = re.sub(r'add rsp, 32\n    pop rax', 'add rsp, 40\n    pop rax', c)

with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
