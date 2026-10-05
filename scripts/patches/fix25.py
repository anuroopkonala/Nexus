with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
c = re.sub(r'fmt_rcx: \.asciz "DEBUG: op_print rcx = %llu\\n"\n', '', c)
# Remove the prints inside op_print
c = re.sub(r'op_print:\n    mov rcx, \[rsi\]\n    add rsi, 8\n\n    push rsi.*?add rsp, 40\n    pop rsi\n\n    mov rcx, r8\n    movsd xmm1, \[r12 \+ rcx\*8\]', 'op_print:\n    mov rcx, [rsi]\n    add rsi, 8\n    movsd xmm1, [r12 + rcx*8]', c, flags=re.DOTALL)
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
