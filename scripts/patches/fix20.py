with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
c = re.sub(r'str_fmt: \.asciz "%s\\n"', 'str_fmt: .asciz "%s\\n"\nbad_token_fmt: .asciz "BAD_TOKEN: %s\\n"\n', c)
c = re.sub(r'\.print_bad_token:\n    sub rsp, 40\n    lea rcx, \[rip \+ str_fmt\]\n    lea rdx, \[rip \+ token_buf\]\n    call printf', '.print_bad_token:\n    sub rsp, 40\n    lea rcx, [rip + bad_token_fmt]\n    lea rdx, [rip + token_buf]\n    call printf', c)
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
