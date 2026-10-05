import re
with open("nexus_core.s", "r", encoding="utf-8") as f:
    c = f.read()

# Add strings
c = c.replace('str_GET_OP: .asciz "GET_OP"', '')
c = c.replace('str_EXEC_DYNAMIC: .asciz "EXEC_DYNAMIC"', 'str_EXEC_DYNAMIC: .asciz "EXEC_DYNAMIC"\nstr_GET_OP: .asciz "GET_OP"\nstr_LOAD_PTR: .asciz "LOAD_PTR"')

# Add op_load_ptr
c = c.replace('op_exec_dynamic:', """op_load_ptr:
    mov r8, [rsi]
    mov r9, [rsi+8]
    add rsi, 16
    mov [rdi + r9 * 8], r8
    NEXT

op_exec_dynamic:""")

# Build the check_GET_OP chain
ops = ["ADD", "DICT_GET", "DICT_SET", "JMP_F_O", "JMP_O", "LOAD", "LOAD_RAW", "POP", "PRINT", "PUSH", "RET"]
chain = """.check_GET_OP:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_GET_OP]
    call strcmp
    cmp eax, 0
    jne .check_EXEC_DYNAMIC
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + val_buf]
    call fscanf
"""
for op in ops:
    chain += f"""
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_{op}]
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_{op}_next
    lea r15, [rip + op_{op.lower()}]
    jmp .get_op_found
.check_GET_OP_{op}_next:
"""
chain += """
    # If not found, crash or skip (just jump to read_loop for now)
    jmp .read_loop

.get_op_found:
    lea rax, [rip + op_load_ptr]
    mov [r13], rax
    add r13, 8
    
    mov [r13], r15
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    jmp .read_loop

.check_EXEC_DYNAMIC:"""

c = c.replace('.check_EXEC_DYNAMIC:', chain)

# wait, I need to make sure str_DICT_GET etc exist.
# str_DICT_GET exists. str_RET exists. str_POP exists. str_LOAD exists.
# Let's ensure str_LOAD_RAW exists. Yes.

with open("nexus_core.s", "w", encoding="utf-8") as f:
    f.write(c)
