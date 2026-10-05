with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
import re
# Remove exit 5 in get_op_found
c = re.sub(r'\.get_op_found:\n    mov rcx, 5\n    call exit', '.get_op_found:\n    lea rax, [rip + op_load_raw_ptr]\n    mov [r13], rax\n    add r13, 8\n    \n    mov [r13], r15\n    add r13, 8', c)

# Clean check_GET_OP (remove hex print, remove val_buf print)
c = re.sub(r'\.check_GET_OP:\n    push rax\n    sub rsp, 40.*?add rsp, 72\n    pop rax\n    lea rcx, \[rip \+ token_buf\]', '.check_GET_OP:\n    lea rcx, [rip + token_buf]', c, flags=re.DOTALL)
c = re.sub(r'    mov rbx, rax\n\n    push rax\n    sub rsp, 40.*?add rsp, 40\n    pop rax\n\n    lea rcx, \[rip \+ val_buf\]', '    mov rbx, rax\n\n    lea rcx, [rip + val_buf]', c, flags=re.DOTALL)

# Clean read_loop (remove debug printf)
c = re.sub(r'\.read_loop:\n    mov rcx, r14\n    lea rdx, \[rip \+ scan_fmt\]\n    lea r8, \[rip \+ token_buf\]\n    call fscanf\n    cmp eax, 1\n    jne \.parse_done\n    \n    lea rcx, \[rip \+ token_buf\].*?\.not_get_op:', '.read_loop:\n    mov rcx, r14\n    lea rdx, [rip + scan_fmt]\n    lea r8, [rip + token_buf]\n    call fscanf\n    cmp eax, 1\n    jne .parse_done', c, flags=re.DOTALL)

with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
