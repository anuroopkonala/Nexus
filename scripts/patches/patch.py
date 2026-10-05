import re

with open('nexus_core.s', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Add string constants
str_consts = """
str_EXEC_DYNAMIC: .asciz "EXEC_DYNAMIC"
str_RET_DYNAMIC: .asciz "RET_DYNAMIC"
"""
content = re.sub(r'(str_POP_PTR: \.asciz "POP_PTR"(\r?\n))', r'\1' + str_consts, content)

# 2. Add globals
globals_bss = """
argc_store: .space 8
argv_store: .space 8
"""
content = re.sub(r'(gc_threshold: \.space 8(\r?\n))', r'\1' + globals_bss, content)

# 3. Add implementations
impls = """
op_exec_dynamic:
    mov r8, [rsi]
    add rsi, 8
    lea r9, [rip + call_sp]
    mov r10, [r9]
    lea r11, [rip + call_stack]
    mov [r11 + r10 * 8], rsi
    inc r10
    mov [r9], r10
    mov rsi, [rbx + r8 * 8]
    NEXT

op_ret_dynamic:
    lea r8, [rip + call_sp]
    mov r9, [r8]
    dec r9
    mov [r8], r9
    lea r10, [rip + call_stack]
    mov rsi, [r10 + r9 * 8]
    NEXT

"""
content = re.sub(r'(op_halt:\s+jmp vm_exit(\r?\n))', r'\1\n' + impls, content)

# 4. Modify main entry
main_entry_old = """main:
    push rbp"""
main_entry_new = """main:
    mov [rip + argc_store], rcx
    mov [rip + argv_store], rdx
    push rbp"""
content = content.replace(main_entry_old, main_entry_new)

# 5. Modify argc/argv usage
# We will use regex for safety due to line endings
file_open_old = r"""    # ---------------------------------------------------------
    # ASSEMBLY LEXER & PARSER
    # Reads .nxasm file from argv\[1\] or boot\.nxasm by default
    # rbp\+16 = argc, rbp\+24 = argv on Windows x64
    # ---------------------------------------------------------
    mov rax, \[rbp \+ 16\]   # argc \(actually we need to get them differently\)
    # On Windows x64, main\(argc, argv\): rcx=argc, rdx=argv at call time
    # We saved rbp at start, so argc/argv are not directly on stack
    # We'll use a simpler trick: store argc/argv in temp regs before push
    # Actually they are passed in rcx, rdx â€” we need to save them at entry
    # For now: check if a \.nxasm file is named in argv by using saved r15
    # r15 was pushed â€” use it to store argv pointer
    # Simpler: always use boot\.nxasm \(the build script renames the file\)
    lea rcx, \[rip \+ file_name\]
    lea rdx, \[rip \+ read_mode\]
    call fopen"""

file_open_new = """    # ---------------------------------------------------------
    # ASSEMBLY LEXER & PARSER
    # Reads .nxasm file from argv[1] or boot.nxasm by default
    # ---------------------------------------------------------
    mov rcx, [rip + argc_store]
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

content = re.sub(file_open_old.replace('â€”', '.').replace('\n', '\r?\n'), file_open_new, content)

# 6. Add to parsing chain
parse_panic = """.check_PANIC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PANIC]
    call strcmp
    cmp eax, 0
    jne .parse_error"""

parse_panic_new = """.check_PANIC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PANIC]
    call strcmp
    cmp eax, 0
    jne .check_EXEC_DYNAMIC"""

content = content.replace(parse_panic, parse_panic_new)

parser_add = """

.check_EXEC_DYNAMIC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_EXEC_DYNAMIC]
    call strcmp
    cmp eax, 0
    jne .check_RET_DYNAMIC
    
    lea rax, [rip + op_exec_dynamic]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_RET_DYNAMIC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_RET_DYNAMIC]
    call strcmp
    cmp eax, 0
    jne .parse_error
    
    lea rax, [rip + op_ret_dynamic]
    mov [r13], rax
    add r13, 8
    jmp .read_loop
"""

content = content.replace("    jmp .read_loop\n.parse_error:", "    jmp .read_loop" + parser_add + "\n.parse_error:")
content = content.replace("    jmp .read_loop\r\n.parse_error:", "    jmp .read_loop" + parser_add + "\r\n.parse_error:")


with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(content)

