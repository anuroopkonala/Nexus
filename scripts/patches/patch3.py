with open('nexus_core.s', 'rb') as f:
    c = f.read()

import re
c = c.replace(b'str_fmt2: .asciz "strcmp(%p, %p) stack=%p\\n"', b'str_fmt2: .asciz "strcmp(%p, %p) stack=%p\\n"\nstr_fmt3: .asciz "Strings: [%s] vs [%s]\\n"')

old = b'''    mov r9, rsp
    mov r8, rdx
    mov rdx, rcx
    lea rcx, [rip + str_fmt2]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    mov rcx, r11
    mov rdx, [r13]
    call strcmp'''

new = b'''    mov r9, rsp
    mov r8, rdx
    mov rdx, rcx
    lea rcx, [rip + str_fmt2]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [r13]
    mov rdx, r11
    lea rcx, [rip + str_fmt3]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi

    mov rcx, r11
    mov rdx, [r13]
    call strcmp'''

c = c.replace(old, new)
with open('nexus_core.s', 'wb') as f:
    f.write(c)
