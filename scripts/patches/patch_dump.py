import re
with open('nexus_core.s', 'rb') as f:
    c = f.read()

# find op_dict_get
# and insert dump before 'call strcmp' inside op_dict_get
# There's only one 'call strcmp' in op_dict_get
idx = c.find(b'op_dict_get:')
end_idx = c.find(b'op_dict_new:', idx)
if end_idx == -1: end_idx = len(c)

part = c[idx:end_idx]

dump_code = b'''    # Dump 8 bytes of r11
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
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
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
    
    # Dump 8 bytes of [r13]
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
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
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
    
    call strcmp'''

part = part.replace(b'    call strcmp', dump_code)
c = c[:idx] + part + c[end_idx:]

with open('nexus_core.s', 'wb') as f:
    f.write(c)
