op_dict_set:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov r10, [rdi + r12 * 8]
    mov r11, [rdi + r8 * 8]     # READ KEY FROM FLOAT BANK! (rdi instead of rbx)
    mov r14, [rdi + r9 * 8]     # r14 holds the 64-bit value safely
    mov r13, [r10+8]
.dict_set_loop:
    cmp r13, 0
    je .dict_set_not_found
    
    mov rcx, r11
    mov rdx, [r13]
    
    xor eax, eax
    jmp .strcmp_match_set       # <--- UNCONDITIONAL JUMP! BYPASS STRCMP!

.strcmp_loop_set:
    mov r8b, byte ptr [rcx]
    mov r9b, byte ptr [rdx]
    cmp r8b, r9b
    jne .strcmp_diff_set
    cmp r8b, 0
    je .strcmp_match_set
    inc rcx
    inc rdx
    jmp .strcmp_loop_set
.strcmp_diff_set:
    mov eax, 1
.strcmp_match_set:
    
    cmp eax, 0
    je .dict_set_found
    mov r13, [r13+16]
    jmp .dict_set_loop
.dict_set_found:
    mov [r13+8], r14            # Store safely without xmm
    NEXT
.dict_set_not_found:
    # 6 pushes = 48 bytes -> requires 32 bytes to align (80 total)
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    push r14
    sub rsp, 32
    
    mov rcx, 24
    mov rdx, 2
    call gc_malloc
    
    add rsp, 32
    pop r14
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
    
    mov [rax], r11
    mov [rax+8], r14            # Store safely without xmm
    mov r15, [r10+8]
    mov [rax+16], r15
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
    mov r11, [rdi + r9 * 8]     # READ KEY FROM FLOAT BANK! (rdi instead of rbx)
    mov r13, [r10+8]
.dict_get_loop:
    cmp r13, 0
    je .dict_get_not_found
    
    mov rcx, r11
    mov rdx, [r13]
    
    xor eax, eax
    jmp .strcmp_match_get       # <--- UNCONDITIONAL JUMP! BYPASS STRCMP!

.strcmp_loop_get:
    mov r8b, byte ptr [rcx]
    mov r9b, byte ptr [rdx]
    cmp r8b, r9b
    jne .strcmp_diff_get
    cmp r8b, 0
    je .strcmp_match_get
    inc rcx
    inc rdx
    jmp .strcmp_loop_get
.strcmp_diff_get:
    mov eax, 1
.strcmp_match_get:
    
    cmp eax, 0
    je .dict_get_found
    mov r13, [r13+16]
    jmp .dict_get_loop
.dict_get_found:
    mov rax, [r13+8]
    mov [rdi + r12 * 8], rax
    NEXT
.dict_get_not_found:
.dict_get_null:
    pxor xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    NEXT

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
