import re
with open('nexus_core.s', 'r', encoding='utf-8') as f:
    content = f.read()

# Find the block starting with "mov rax, [rbp + 16]" and ending with "call fopen"
old_block = r'    mov rax, \[rbp \+ 16\].*?call fopen'
new_block = """    mov rcx, [rip + argc_store]
    cmp rcx, 1
    jle .use_default_file
    mov rdx, [rip + argv_store]
    mov rcx, [rdx + 8]   # argv[1]
    jmp .open_file

.use_default_file:
    lea rcx, [rip + file_name]

.open_file:
    lea rdx, [rip + read_mode]
    call fopen"""

content = re.sub(old_block, new_block, content, flags=re.DOTALL)
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(content)
