op_load_raw:
    mov rax, [rsi]     # raw 64-bit value
    add rsi, 8
    mov rcx, [rsi]     # dest reg
    add rsi, 8
    mov [rdi + rcx * 8], rax  # Write to float_bank!
    NEXT
