import re
with open('nexus_core.s', 'r', encoding='utf-8') as f:
    content = f.read()

print_stmt = """
    push rcx
    push rdx
    push r8
    push r9
    
    sub rsp, 32
    mov rdx, [rip + argc_store]
    lea rcx, [rip + fmt_argc]
    call printf
    add rsp, 32
    
    pop r9
    pop r8
    pop rdx
    pop rcx
"""

fmt_argc = 'fmt_argc: .asciz "ARGC=%d\\n"\n'

content = content.replace("str_fmt: .asciz \"%s\\n\"", "str_fmt: .asciz \"%s\\n\"\n" + fmt_argc)
content = content.replace("    mov rcx, [rip + argc_store]\n    cmp rcx, 1", print_stmt + "    mov rcx, [rip + argc_store]\n    cmp rcx, 1")

with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(content)
