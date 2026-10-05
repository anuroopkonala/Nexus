import os
with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
c = c.replace('time_msg: .asciz', 'token_fmt: .asciz "%s\\n"\ntime_msg: .asciz')
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
