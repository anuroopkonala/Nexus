import re
with open('nexus_core.s', 'r', encoding='utf-8') as f:
    content = f.read()

debug_parse = """
    push r14
    push rcx
    push rdx
    push r8
    push r9
    sub rsp, 32
    lea rdx, [rip + token_buf]
    lea rcx, [rip + fmt_parse]
    call printf
    add rsp, 32
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop r14
"""

fmt_parse = 'fmt_parse: .asciz "DEBUG: Parsed token: %s\\n"\\n'

content = content.replace('.section .data\n', '.section .data\n' + fmt_parse)
content = content.replace('    lea rax, [rip + token_buf]\n    cmp byte ptr [rax], \'#\'', debug_parse + '\n    lea rax, [rip + token_buf]\n    cmp byte ptr [rax], \'#\'')

with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(content)
