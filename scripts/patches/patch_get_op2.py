import re
with open("nexus_core.s", "r", encoding="utf-8") as f:
    c = f.read()

# Remove my added op_load_ptr
c = c.replace("""op_load_ptr:
    mov r8, [rsi]
    mov r9, [rsi+8]
    add rsi, 16
    mov [rdi + r9 * 8], r8
    NEXT

op_exec_dynamic:""", """op_load_raw_ptr:
    mov r8, [rsi]
    mov r9, [rsi+8]
    add rsi, 16
    mov [rdi + r9 * 8], r8
    NEXT

op_exec_dynamic:""")

# Replace op_load_ptr with op_load_raw_ptr in .get_op_found
c = c.replace("""
.get_op_found:
    lea rax, [rip + op_load_ptr]""", """
.get_op_found:
    lea rax, [rip + op_load_raw_ptr]""")

with open("nexus_core.s", "w", encoding="utf-8") as f:
    f.write(c)
