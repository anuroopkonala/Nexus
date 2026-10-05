import re
content = open("nexus_core.s").read()

content = content.replace("op_dict_set:", """fmt_dict_set: .asciz "DEBUG: DICT_SET key='%s' val=%f\\n"
op_dict_set:""")

dict_set_debug = """
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    sub rsp, 40
    lea rcx, [rip + fmt_dict_set]
    mov rdx, r11
    movq r8, xmm0
    movsd [rsp+32], xmm0
    call printf
    add rsp, 40
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
"""

content = content.replace("movsd xmm0, [rdi + r9 * 8]\n    mov r13, [r10+8]", 
    "movsd xmm0, [rdi + r9 * 8]\n" + dict_set_debug + "\n    mov r13, [r10+8]")


content = content.replace("op_dict_get:", """fmt_dict_get: .asciz "DEBUG: DICT_GET key='%s' res=%f\\n"
op_dict_get:""")

dict_get_debug = """
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    sub rsp, 40
    lea rcx, [rip + fmt_dict_get]
    mov rdx, r11
    movq r8, xmm0
    movsd [rsp+32], xmm0
    call printf
    add rsp, 40
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
"""

content = content.replace("movsd xmm0, [r13+16]\n    movsd [rdi + r12 * 8], xmm0\n    NEXT\n.dict_get_not_found", 
    "movsd xmm0, [r13+16]\n" + dict_get_debug + "\n    movsd [rdi + r12 * 8], xmm0\n    NEXT\n.dict_get_not_found")


open("nexus_core.s", "w").write(content)
