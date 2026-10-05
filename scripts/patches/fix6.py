with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
c = c.replace('main:\n    push rbp\n    mov rbp, rsp\n    sub rsp, 32', 'main:\n    push rbp\n    mov rbp, rsp\n    sub rsp, 32\n    lea rcx, [rip + init_msg]\n    call printf\n    mov rcx, 0\n    call fflush')
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
