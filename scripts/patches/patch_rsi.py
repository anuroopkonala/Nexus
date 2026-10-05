import re
with open('nexus_core.s', 'r', encoding='utf-8') as f:
    content = f.read()

debug_print_rsi = """
    push rcx
    push rdx
    push r8
    push r9
    
    sub rsp, 32
    mov rdx, rsi
    lea rcx, [rip + fmt_rsi]
    call printf
    add rsp, 32
    
    pop r9
    pop r8
    pop rdx
    pop rcx
"""

fmt_rsi = 'fmt_rsi: .asciz "DEBUG: op_print rsi = %p\\n"\\n'

content = content.replace('fmt_rcx: .asciz "DEBUG: op_print rcx = %llu\\n"\\n', 'fmt_rcx: .asciz "DEBUG: op_print rcx = %llu\\n"\\n' + fmt_rsi)
content = content.replace('op_print:\n    mov rcx, [rsi]\n    add rsi, 8\n', 'op_print:\n' + debug_print_rsi + '\n    mov rcx, [rsi]\n    add rsi, 8\n')

with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(content)
