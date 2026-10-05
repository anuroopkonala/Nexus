import re
with open('nexus_core.s', 'r', encoding='utf-8') as f:
    content = f.read()

debug_addrs = """
    lea rcx, [rip + fmt_addrs]
    lea rdx, [rip + op_load_raw]
    lea r8, [rip + op_print]
    call printf
"""
fmt_addrs = 'fmt_addrs: .asciz "DEBUG: op_load_raw = %p, op_print = %p\\n"\\n'

content = content.replace('.section .data\n', '.section .data\n' + fmt_addrs)
content = content.replace('lea rcx, [rip + init_msg]\n    call printf', 'lea rcx, [rip + init_msg]\n    call printf\n' + debug_addrs)

with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(content)
