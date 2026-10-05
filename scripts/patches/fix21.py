with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
c = c.replace('str_fmt: .asciz "%s\\n"\\nbad_token_fmt: .asciz "BAD_TOKEN: %s\\n"\\n', 'str_fmt: .asciz "%s\\n"\\nbad_token_fmt: .asciz "BAD_TOKEN: %s\\n"\\n') # Wait, I will just replace " followed by literal newline.
