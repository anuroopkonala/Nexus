import re

with open('nexus_core.s', 'rb') as f:
    c = f.read()

def clean_dict(c):
    idx_set = c.find(b'op_dict_set:')
    idx_get = c.find(b'op_dict_get:')
    idx_next = c.find(b'op_dict_clear:')
    
    if idx_next == -1: idx_next = c.find(b'op_free:')
    
    clean = b'''op_dict_set:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov r10, [rdi + r12 * 8]
    mov r11, [rbx + r8 * 8]
    movsd xmm0, [rdi + r9 * 8]
    mov r13, [r10+8]
.dict_set_loop:
    cmp r13, 0
    je .dict_set_not_found
    
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    
    mov rcx, r11
    mov rdx, [r13]
    call strcmp
    
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
    
    cmp eax, 0
    je .dict_set_found
    mov r13, [r13+16]
    jmp .dict_set_loop
.dict_set_found:
    movsd [r13+8], xmm0
    NEXT
.dict_set_not_found:
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    sub rsp, 16
    movsd [rsp], xmm0
    sub rsp, 40
    mov rcx, 24
    mov rdx, 2
    call gc_malloc
    add rsp, 40
    movsd xmm0, [rsp]
    add rsp, 16
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
    mov [rax], r11
    movsd [rax+8], xmm0
    mov r14, [r10+8]
    mov [rax+16], r14
    mov [r10+8], rax
    NEXT

op_dict_get:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov r10, [rdi + r8 * 8]
    
    cmp r10, 0
    je .dict_get_null
    mov r11, [rbx + r9 * 8]
    mov r13, [r10+8]
.dict_get_loop:
    cmp r13, 0
    je .dict_get_not_found
    
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    
    mov rcx, r11
    mov rdx, [r13]
    call strcmp
    
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
    
    cmp eax, 0
    je .dict_get_found
    mov r13, [r13+16]
    jmp .dict_get_loop
.dict_get_found:
    movsd xmm0, [r13+8]
    movsd [rdi + r12 * 8], xmm0
    NEXT
.dict_get_not_found:
.dict_get_null:
    pxor xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    NEXT
    
'''
    c = c[:idx_set] + clean + c[idx_next:]
    return c

c = clean_dict(c)
with open('nexus_core.s', 'wb') as f:
    f.write(c)
