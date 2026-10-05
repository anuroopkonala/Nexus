import re

with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()

# Fix the dict_set and dict_get corruptions!
c = re.sub(r'op_dict_set:\n.*?\.dict_set_loop:', 
    "op_dict_set:\n    mov r12, [rsi]\n    mov r8,  [rsi+8]\n    mov r9,  [rsi+16]\n    add rsi, 24\n    movsd xmm0, [rdi + r12 * 8]\n    cvttsd2si r10, xmm0\n    mov r11, [rbx + r8 * 8]\n    movsd xmm0, [rdi + r9 * 8]\n    mov r13, [r10+8]\n.dict_set_loop:", 
    c, flags=re.DOTALL)

c = re.sub(r'op_dict_get:\n.*?cmp r10, 0',
    "op_dict_get:\n    mov r12, [rsi]\n    mov r8,  [rsi+8]\n    mov r9,  [rsi+16]\n    add rsi, 24\n    movsd xmm0, [rdi + r8 * 8]\n    cvttsd2si r10, xmm0\n    cmp r10, 0",
    c, flags=re.DOTALL)

c = re.sub(r'\.dict_get_found:\n.*?NEXT\n\.dict_get_not_found:',
    ".dict_get_found:\n    movsd xmm0, [r13+16]\n    movsd [rdi + r12 * 8], xmm0\n    NEXT\n.dict_get_not_found:",
    c, flags=re.DOTALL)

c = re.sub(r'    mov r11, \[rbx \+ r9 \* 8\]\n.*?\n\.dict_get_loop:',
    "    mov r11, [rbx + r9 * 8]\n    mov r13, [r10+8]\n.dict_get_loop:",
    c, flags=re.DOTALL)

# Remove fmt strings
c = re.sub(r'fmt_dict_set:.*?\n', '', c)
c = re.sub(r'fmt_dict_get:.*?\n', '', c)
c = re.sub(r'fmt_dict_get_res:.*?\n', '', c)

# Save
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)

print("Fixed.")
