import re
with open('nexus_core.s', 'r', encoding='utf-8') as f:
    content = f.read()

print_stmt = """
    push rcx
    push rdx
    push r8
    push r9
    
    sub rsp, 32
    mov rdx, rcx
    lea rcx, [rip + str_fmt]
    call printf
    add rsp, 32
    
    pop r9
    pop r8
    pop rdx
    pop rcx
"""

content = content.replace("    call fopen", print_stmt + "    call fopen")
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(content)
