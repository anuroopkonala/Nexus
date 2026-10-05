with open('nexus_core.s', 'rb') as f:
    c = f.read()

import re
c = c.replace(b'str_fmt2: .asciz "strcmp(%p, %p)\\n"', b'str_fmt2: .asciz "strcmp(%p, %p) stack=%p\\n"')

old = b'''    mov r8, rdx
    mov rdx, rcx
    lea rcx, [rip + str_fmt2]
    mov eax, 0
    call printf'''
new = b'''    mov r9, rsp
    mov r8, rdx
    mov rdx, rcx
    lea rcx, [rip + str_fmt2]
    mov eax, 0
    call printf'''
c = c.replace(old, new)

with open('nexus_core.s', 'wb') as f:
    f.write(c)
