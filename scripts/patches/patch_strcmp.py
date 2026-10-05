with open('nexus_core.s', 'rb') as f:
    c = f.read()

old = b'''    mov rcx, r11
    mov rdx, [r13]
    call strcmp'''

new = b'''    mov rcx, r11
    mov rdx, [r13]
    
    # Custom strcmp
    xor eax, eax
.custom_strcmp_loop:
    mov r8b, [rcx]
    mov r9b, [rdx]
    cmp r8b, r9b
    jne .custom_strcmp_diff
    test r8b, r8b
    jz .custom_strcmp_match
    inc rcx
    inc rdx
    jmp .custom_strcmp_loop
.custom_strcmp_diff:
    mov eax, 1
.custom_strcmp_match:
    # eax is 0 if match, 1 if diff'''

c = c.replace(old, new)

with open('nexus_core.s', 'wb') as f:
    f.write(c)
