import re
with open('nexus_core.s', 'rb') as f:
    c = f.read()

# I will replace all 'sub rsp, 32' followed by 'mov rcx, r11' and 'mov rdx, [r13]' and 'call strcmp' and 'add rsp, 32'
# Wait, I will just use regex to fix the exact block in op_dict_set and op_dict_get

# Clean up my patch_dump additions first, let's restore to the clean file
# I can just git checkout nexus_core.s ? It failed before.
# Let's just fix the alignment in the current file, it doesn't matter if my printf is there.
# No, let's make it clean. I will just replace the whole 'call strcmp' block.

def fix_alignment(c):
    # find all instances of:
    # sub rsp, 32
    # <maybe some printf stuff>
    # mov rcx, r11
    # mov rdx, [r13]
    # <maybe some dump stuff>
    # call strcmp
    # add rsp, 32
    
    # Actually, let's just do a simple replace:
    # "push r13\n    sub rsp, 32" -> "push r13\n    sub rsp, 40"
    # "call strcmp\n    add rsp, 32" -> "call strcmp\n    add rsp, 40"
    
    c = c.replace(b'push r13\n    sub rsp, 32', b'push r13\n    sub rsp, 40')
    c = c.replace(b'push r13\r\n    sub rsp, 32', b'push r13\r\n    sub rsp, 40')
    c = c.replace(b'call strcmp\n    add rsp, 32', b'call strcmp\n    add rsp, 40')
    c = c.replace(b'call strcmp\r\n    add rsp, 32', b'call strcmp\r\n    add rsp, 40')
    return c

c = fix_alignment(c)

with open('nexus_core.s', 'wb') as f:
    f.write(c)
