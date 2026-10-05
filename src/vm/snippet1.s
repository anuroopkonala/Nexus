op_dict_set:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov r10, [rdi + r12 * 8]
    mov r11, [rbx + r8 * 8]
    mov r14, [rdi + r9 * 8]     # Use r14 to hold the 64-bit value safely
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
    mov [r13+8], r14            # Store safely without xmm
    NEXT
.dict_set_not_found:
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    push r14                    # Push the value to preserve it
    sub rsp, 32                 # Align to 16 bytes: 6 pushes = 48 bytes. 32 + 48 = 80. 8 + 80 = 88... WAIT!
                                # Before call: rsp % 16 = 8. 6 pushes: rsp % 16 = 8. sub 40: 48 = 0.
                                # Let's use 40!
