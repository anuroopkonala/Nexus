import re
with open('nexus_core.s', 'r', encoding='utf-8') as f:
    content = f.read()

debug_print = """
    push rcx
    push rdx
    push r8
    push r9
    sub rsp, 32
    lea rcx, [rip + msg_load_raw]
    call printf
    add rsp, 32
    pop r9
    pop r8
    pop rdx
    pop rcx
"""

msg_load_raw = 'msg_load_raw: .asciz "DEBUG: executing op_load_raw\\n"\\n'

content = content.replace('.section .data\n', '.section .data\n' + msg_load_raw)
content = content.replace('op_load_raw:\n    mov rax, [rsi]', 'op_load_raw:\n' + debug_print + '\n    mov rax, [rsi]')

with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(content)
