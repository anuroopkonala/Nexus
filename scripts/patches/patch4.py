with open('nexus_core.s', 'rb') as f:
    c = f.read()

import re
c = c.replace(b'str_fmt3: .asciz "Strings: [%s] vs [%s]\\n"', b'str_fmt3: .asciz "Values: [%p] vs [%p]\\n"')

old = b'''    mov r8, [r13]
    mov rdx, r11
    lea rcx, [rip + str_fmt3]
    mov eax, 0
    call printf'''

new = b'''    mov rdx, r11
    mov rdx, [rdx]
    mov r8, [r13]
    mov r8, [r8]
    lea rcx, [rip + str_fmt3]
    mov eax, 0
    call printf'''
c = c.replace(old, new)
with open('nexus_core.s', 'wb') as f:
    f.write(c)
