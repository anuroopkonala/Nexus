import re

with open('nexus_core.s', 'rb') as f:
    c = f.read()

missing = b'''
op_panic:
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    lea rcx, [rip + panic_msg]
    call printf
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    jmp vm_exit

op_alloc:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # size_reg
    add rsi, 16
    push rsi
    push rdi
    push rbx
    sub rsp, 40

    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    mov rdx, 3
    call gc_malloc
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    mov [rbx + r12 * 8], rax
    NEXT

gc_malloc:
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    sub rsp, 40
    add rcx, 32
    call malloc
    mov rdx, [rsp+88]
    mov [rax+16], rdx
    mov qword ptr [rax], 0
    lea r8, [rip + alloc_head]
    mov r9, [r8]
    mov [rax+24], r9
    mov [r8], rax
    add rax, 24
    add rsp, 40
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    ret

run_gc:
    ret

mark_if_valid:
    ret

'''

idx = c.find(b'op_free:')
c = c[:idx] + missing + c[idx:]

with open('nexus_core.s', 'wb') as f:
    f.write(c)
