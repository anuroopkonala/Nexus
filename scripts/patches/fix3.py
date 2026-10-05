with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
c = c.replace('.print_bad_token:\n    sub rsp, 32\n    lea rcx, [rip + str_fmt]\n    lea rdx, [rip + token_buf]\n    call printf\n    mov rcx, 0\n    call fflush\n    add rsp, 32', '.print_bad_token:\n    sub rsp, 40\n    lea rcx, [rip + str_hex_fmt]\n    lea rdx, [rip + token_buf]\n    movzx r8, byte ptr [rdx]\n    movzx r9, byte ptr [rdx+1]\n    movzx r10, byte ptr [rdx+2]\n    movzx r11, byte ptr [rdx+3]\n    movzx r12, byte ptr [rdx+4]\n    movzx rax, byte ptr [rdx+5]\n    push rax\n    push r12\n    push r11\n    push r10\n    push r9\n    push r8\n    call printf\n    add rsp, 48\n    mov rcx, 0\n    call fflush\n    add rsp, 40')
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
