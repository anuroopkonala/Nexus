with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
c = c.replace('.parse_done:\n    mov rcx, r14\n    call fclose\n    \n    # ---------------------------------------------------------\n    # EXECUTE THE COMPILED BYTECODE\n    # ---------------------------------------------------------\n    mov rcx, r13\n    sub rcx, r12\n    shr rcx, 3\n    mov rdx, rcx\n    lea rcx, [rip + debug_fmt]\n    call printf\n    lea rcx, [rip + init_msg]\n    call printf\n    mov rcx, 0\n    mov rcx, 0\n    call exit', '.parse_done:\n    sub rsp, 32\n    mov rcx, r14\n    call fclose\n    mov rcx, r13\n    sub rcx, r12\n    shr rcx, 3\n    mov rdx, rcx\n    lea rcx, [rip + debug_fmt]\n    call printf\n    lea rcx, [rip + init_msg]\n    call printf\n    mov rcx, 0\n    call fflush\n    mov rcx, 0\n    call exit')
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
