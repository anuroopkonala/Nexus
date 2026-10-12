.intel_syntax noprefix

.global main
.extern printf
.extern malloc
.extern free
.extern exit
.extern fopen
.extern fscanf
.extern strcmp
.extern strdup
.extern atof
.extern atoi
.extern fclose
.extern sin
.extern cos
.extern pow
.extern sqrt
.extern strlen
.extern strcat
.extern fread
.extern fwrite
.extern gets

.section .data
fmt_addrs: .asciz "DEBUG: op_load_raw = %p, op_print = %p\n"
fmt_parse: .asciz "DEBUG: Parsed token: %s\n"
msg_load_raw: .asciz "DEBUG: executing op_load_raw\n"
init_msg: .asciz "[Nexus Baremetal] Booting Lightning Direct-Threaded VM...\n"
token_fmt: .asciz "%s\n"
time_msg: .asciz "[Nexus Baremetal] VM execution complete.\n"
debug_fmt: .asciz "[Nexus Baremetal] Register output: %f\n"
char_fmt: .asciz "%c"
str_fmt: .asciz "%s\n"
str_fmt2: .asciz "strcmp(%p, %p) stack=%p\n"
str_fmt3: .asciz "Values: [%p] vs [%p]\n"
bad_token_fmt: .asciz "BAD_TOKEN: %s\n"


fmt_argc: .asciz "ARGC=%d\n"

vm_debug: .long 0
cli_source_file: .quad 0
target_asm_file: .quad 0
default_compiler: .asciz "src/compiler/compiler_full.nxasm"

file_name: .asciz "tests/vm/boot.nxasm"
read_mode: .asciz "r"
scan_fmt: .asciz "%s"
str_hex_fmt: .asciz ""
err_msg: .asciz "Failed to open input file: %s\n"

str_FREAD: .asciz "FREAD"
str_FWRITE: .asciz "FWRITE"
str_FCLOSE: .asciz "FCLOSE"
str_INPUT: .asciz "INPUT"
str_STR_CAT: .asciz "STR_CAT"
str_SQRT: .asciz "SQRT"
str_SIN: .asciz "SIN"
str_COS: .asciz "COS"
str_POW: .asciz "POW"
str_ABS: .asciz "ABS"
str_EXIT: .asciz "EXIT"
str_PANIC: .asciz "PANIC"
panic_msg: .asciz "VM PANIC!\n"
stack_trace_msg: .asciz "Stack trace:\n  <main>\n"
str_LOAD: .asciz "LOAD"
str_ADD: .asciz "ADD"
str_PRINT: .asciz "PRINT"
str_HALT: .asciz "HALT"
str_LT: .asciz "LT"
str_LABEL: .asciz "LABEL"
str_JMP: .asciz "JMP"
str_JMP_F: .asciz "JMP_F"
str_LOAD_STR: .asciz "LOAD_STR"
str_FOPEN: .asciz "FOPEN"
str_FGETC: .asciz "FGETC"
str_PRINT_C: .asciz "PRINT_C"
str_PRINT_STR: .asciz "PRINT_STR"
str_CALL_O: .asciz "CALL_O"
str_EQ: .asciz "EQ"
str_LTE: .asciz "LTE"
str_GTE: .asciz "GTE"
str_SUB: .asciz "SUB"
str_MUL: .asciz "MUL"
str_DIV: .asciz "DIV"
str_GT: .asciz "GT"
str_NEQ: .asciz "NEQ"
str_MOV: .asciz "MOV"
str_NOT: .asciz "NOT"
str_STORE_PTR: .asciz "STORE_PTR"
str_LOAD_PTR: .asciz "LOAD_PTR"
str_PUTS: .asciz "PUTS"
str_ALLOC: .asciz "ALLOC"
str_DICT_NEW: .asciz "DICT_NEW"
str_DICT_SET: .asciz "DICT_SET"
str_DICT_GET: .asciz "DICT_GET"
str_FREE: .asciz "FREE"
str_LOAD_B: .asciz "LOAD_B"
str_STORE_B: .asciz "STORE_B"
str_EXEC_DYNAMIC: .asciz "EXEC_DYNAMIC"
val_true: .double 1.0
val_false: .double 0.0
str_JMP_O: .asciz "JMP_O"
str_JMP_F_O: .asciz "JMP_F_O"
str_STORE_I: .asciz "STORE_I"
str_GET_OP: .asciz "GET_OP"
str_LOAD_RAW_PTR: .asciz "LOAD_RAW_PTR"
str_LOAD_RAW: .asciz "LOAD_RAW"
str_CALL: .asciz "CALL"
str_RET: .asciz "RET"
str_PUSH: .asciz "PUSH"
str_POP: .asciz "POP"
str_LOAD_F: .asciz "LOAD_F"
str_STORE_F: .asciz "STORE_F"
str_LOAD_PTR_O: .asciz "LOAD_PTR_O"
str_STORE_PTR_O: .asciz "STORE_PTR_O"

str_PUSH_PTR: .asciz "PUSH_PTR"
str_POP_PTR: .asciz "POP_PTR"





.section .bss
token_buf: .space 256
val_buf: .space 256
reg_buf: .space 256
labels_array: .space 81920
call_stack: .space 81920


call_sp: .space 8
val_stack: .space 81920
val_sp: .space 8

ptr_stack: .space 81920
ptr_sp: .space 8
alloc_head: .space 8
gc_count: .space 8
gc_threshold: .space 8

argc_store: .space 8
argv_store: .space 8


.section .text

# ---------------------------------------------------------
# DIRECT THREADED VIRTUAL MACHINE
# ---------------------------------------------------------
.data
in_exec: .long 0
vm_stack_base: .quad 0
parse_done_msg: .asciz "Parse Done!\n"
next_fmt: .asciz "Executing: %p\n"

.text
.macro NEXT
    mov rax, [rsi]
    add rsi, 8
    
    mov edx, [rip + vm_debug]
    cmp edx, 1
    jne 1f
    
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    push rax
    sub rsp, 32
    
    mov rdx, rax
    lea rcx, [rip + next_fmt]
    call printf
    mov rcx, 0
    call fflush

    add rsp, 32
    pop rax
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi

1:
    jmp rax
.endm

# --- Opcode Handlers ---
op_load_const:
    movsd xmm0, [rsi]
    add rsi, 8
    mov rcx, [rsi]
    add rsi, 8
    movsd [rdi + rcx * 8], xmm0
    NEXT

# op_load_raw: stores a raw 64-bit value (pointer/integer) without float conversion
# Bytecode: [handler_ptr][raw_64bit_value][dest_reg]
op_load_raw:
    mov rax, [rsi]     # raw 64-bit value
    add rsi, 8
    mov rcx, [rsi]     # dest reg
    add rsi, 8
    mov [rdi + rcx * 8], rax  # Write to float_bank!
    mov [rbx + rcx * 8], rax  # Also write to ptr_bank!
    NEXT
op_add:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov rax, [rdi + r8 * 8]
    mov r10, 0x7FF0000000000000
    test rax, r10
    jnz .add_float
    cmp rax, 0x10000
    jb .add_float
    mov r10, 0x00007FFFFFFFFFFF
    cmp rax, r10
    ja .add_float
    sub rsi, 24
    jmp op_str_cat
.add_float:
    movsd xmm0, [rdi + r8 * 8]
    addsd xmm0, [rdi + r9 * 8]
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_lt:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    movsd xmm1, [rdi + r9 * 8]
    comisd xmm0, xmm1
    setb al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_jmp:
    mov rcx, [rsi]
    lea r8, [rip + labels_array]
    mov rsi, [r8 + rcx * 8]
    NEXT

op_jmp_f:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16
    movsd xmm0, [rdi + rcx * 8]
    pxor xmm1, xmm1
    ucomisd xmm0, xmm1
    jne .no_jump
    lea rcx, [rip + labels_array]
    mov rsi, [rcx + r8 * 8]
.no_jump:
    NEXT

op_print:
    mov rcx, [rsi]
    add rsi, 8
    
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    movsd xmm1, [rdi + rcx * 8]
    movq rdx, xmm1

    mov rax, rdx
    mov r8, 0x7FF0000000000000
    test rax, r8
    jnz .print_float
    cmp rax, 0x10000
    jb .print_float
    mov r8, 0x00007FFFFFFFFFFF
    cmp rax, r8
    ja .print_float

    lea rcx, [rip + str_fmt]
    call printf
    jmp .print_done

.print_float:
    movq xmm1, rdx
    lea rcx, [rip + debug_fmt]
    call printf

.print_done:
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    NEXT

op_eq:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov rax, [rdi + r8 * 8]
    cmp rax, [rdi + r9 * 8]
    sete al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_dict_new:
    mov r12, [rsi]
    add rsi, 8
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    mov rcx, 16
    mov rdx, 1
    call gc_malloc
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    mov qword ptr [rax], 0
    mov qword ptr [rax+8], 0
    mov [rdi + r12 * 8], rax
    NEXT

op_dict_set:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov r10, [rdi + r12 * 8]
    mov r11, [rdi + r8 * 8]     # READ KEY FROM FLOAT BANK! (rdi instead of rbx)
    mov r14, [rdi + r9 * 8]     # r14 holds the 64-bit value safely
    mov r13, [r10+8]
.dict_set_loop:
    cmp r13, 0
    je .dict_set_not_found
    
    mov rcx, r11
    mov rdx, [r13]
    
    xor eax, eax
.strcmp_loop_set:
    mov r8b, byte ptr [rcx]
    mov r9b, byte ptr [rdx]
    cmp r8b, r9b
    jne .strcmp_diff_set
    cmp r8b, 0
    je .strcmp_match_set
    inc rcx
    inc rdx
    jmp .strcmp_loop_set
.strcmp_diff_set:
    mov eax, 1
.strcmp_match_set:
    
    cmp eax, 0
    je .dict_set_found
    mov r13, [r13+16]
    jmp .dict_set_loop
.dict_set_found:
    mov [r13+8], r14            # Store safely without xmm
    NEXT
.dict_set_not_found:
    # 6 pushes = 48 bytes -> requires 32 bytes to align (80 total)
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    push r14
    sub rsp, 32
    
    mov rcx, 24
    mov rdx, 2
    call gc_malloc
    
    add rsp, 32
    pop r14
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
    
    mov [rax], r11
    mov [rax+8], r14            # Store safely without xmm
    mov r15, [r10+8]
    mov [rax+16], r15
    mov [r10+8], rax
    NEXT

op_dict_get:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov r10, [rdi + r8 * 8]
    
    cmp r10, 0
    je .dict_get_null
    mov r11, [rdi + r9 * 8]     # READ KEY FROM FLOAT BANK!
    cmp r11, 0
    je .dict_get_not_found
    mov r13, [r10+8]
.dict_get_loop:
    cmp r13, 0
    je .dict_get_not_found
    
    mov rcx, r11
    mov rdx, [r13]
    
    xor eax, eax
.strcmp_loop_get:
    mov eax, [rip + vm_debug]
    cmp eax, 1
    jne .skip_dict_debug

    push rax
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    
    sub rsp, 40
    mov r8, rdx
    mov rdx, rcx
    lea rcx, [rip + str_fmt3]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rax
.skip_dict_debug:
    # -------------------------------------------

    mov r8b, byte ptr [rcx]
    mov r9b, byte ptr [rdx]
    cmp r8b, r9b
    jne .strcmp_diff_get
    cmp r8b, 0
    je .strcmp_match_get
    inc rcx
    inc rdx
    jmp .strcmp_loop_get
.strcmp_diff_get:
    mov eax, 1
.strcmp_match_get:
    
    cmp eax, 0
    je .dict_get_found
    mov r13, [r13+16]
    jmp .dict_get_loop
.dict_get_found:
    mov rax, [r13+8]
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax
    NEXT
.dict_get_not_found:
.dict_get_null:
    pxor xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    mov qword ptr [rbx + r12 * 8], 0
    NEXT

op_panic:
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    lea rcx, [rip + panic_msg]
    call printf
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    jmp vm_exit

op_alloc:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # size_reg
    add rsi, 16
    push rsi
    push rdi
    push rbx
    sub rsp, 40

    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    mov rdx, 3
    call gc_malloc
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

gc_malloc:
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    sub rsp, 40
    add rcx, 32
    call malloc
    mov rdx, [rsp+88]
    mov [rax+16], rdx
    mov qword ptr [rax], 0
    lea r8, [rip + alloc_head]
    mov r9, [r8]
    mov [rax+24], r9
    mov [r8], rax
    add rax, 32
    add rsp, 40
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    ret

run_gc:
    ret

mark_if_valid:
    ret
op_free:
    mov r8, [rsi]        # ptr_reg
    add rsi, 8
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    mov rcx, [rbx + r8 * 8]
    call free
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    NEXT

op_fopen:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # path_reg
    add rsi, 16
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    mov rcx, [rbx + r8 * 8]    # arg1: filename ptr
    lea rdx, [rip + read_mode] # arg2: "r"

    mov eax, [rip + vm_debug]
    cmp eax, 1
    jne .skip_fopen_debug
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
.skip_fopen_debug:
    call fopen
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    mov [rbx + r12 * 8], rax   # store FILE* natively
    NEXT

op_fgetc:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # file_reg
    add rsi, 16
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    mov rcx, [rbx + r8 * 8]
    cmp rcx, 0
    jne .do_fgetc
    mov eax, -1
    jmp .fgetc_done
.do_fgetc:
    call fgetc
.fgetc_done:
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    cvtsi2sd xmm0, eax         # char to double
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_load_b:
    mov rcx, [rsi]       # dest
    mov r8,  [rsi+8]     # ptr_reg
    mov r9,  [rsi+16]    # offset_reg
    add rsi, 24
    mov rax, [rbx + r8 * 8]    # ptr
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0        # offset
    xor r10, r10
    mov r10b, byte ptr [rax + rdx] # load byte
    cvtsi2sd xmm0, r10d        # convert byte to double
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_store_b:
    mov r8,  [rsi]       # ptr_reg
    mov r9,  [rsi+8]     # offset_reg
    mov r10, [rsi+16]    # val_reg
    add rsi, 24
    mov rax, [rbx + r8 * 8]    # ptr
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0        # offset
    movsd xmm0, [rdi + r10 * 8]
    cvttsd2si rcx, xmm0        # val
    mov byte ptr [rax + rdx], cl
    NEXT

op_exec_dynamic:
    mov rcx, [rsi]
    add rsi, 8
    lea r8, [rip + call_sp]
    mov r9, [r8]
    lea r10, [rip + call_stack]
    mov [r10 + r9 * 8], rsi
    inc r9
    mov [r8], r9
    mov rsi, [rbx + rcx * 8]

    NEXT

op_jmp_o:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9, [rbx + rcx * 8]
    lea rsi, [r9 + r8]
    NEXT

op_jmp_f_o:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r10, [rsi+16]
    add rsi, 24
    movsd xmm0, [rdi + rcx * 8]
    pxor xmm1, xmm1
    ucomisd xmm0, xmm1
    jne .no_jump_f_o
    mov r9, [rbx + r8 * 8]
    lea rsi, [r9 + r10]
.no_jump_f_o:
    NEXT

op_store_i:
    mov r8,  [rsi]
    mov r9,  [rsi+8]
    mov r10, [rsi+16]
    add rsi, 24
    mov rax, [rbx + r8 * 8]
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0
    movsd xmm0, [rdi + r10 * 8]
    cvttsd2si rcx, xmm0
    mov [rax + rdx], rcx
    NEXT

op_load_raw_ptr:
    mov r8, [rsi]
    mov r9, [rsi+8]
    add rsi, 16
    mov [rdi + r9 * 8], r8
    NEXT

op_call_o:
    mov rcx, [rsi]
    mov r8, [rsi+8]
    add rsi, 16
    lea r10, [rip + call_sp]
    mov r11, [r10]
    lea r12, [rip + call_stack]
    mov [r12 + r11 * 8], rsi
    inc r11
    mov [r10], r11
    mov r9, [rbx + rcx * 8]
    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rax, xmm0
    lea rsi, [r9 + rax]
    NEXT

op_call:
    mov rcx, [rsi]       # read label index
    add rsi, 8
    lea r8, [rip + call_sp]
    mov r9, [r8]         # r9 = call_sp
    lea r10, [rip + call_stack]
    mov [r10 + r9 * 8], rsi # push next RIP
    inc r9
    mov [r8], r9
    lea r11, [rip + labels_array]
    mov rsi, [r11 + rcx * 8]
    NEXT


op_lte:
    mov rcx, [rsi]; add rsi, 8
    mov r8, [rsi]; add rsi, 8
    mov r9, [rsi]; add rsi, 8
    movsd xmm0, [rdi + rcx * 8]
    movsd xmm1, [rdi + r8 * 8]
    comisd xmm0, xmm1
    jbe .lte_true
    lea rax, [rip + val_false]
    jmp .lte_end
.lte_true:
    lea rax, [rip + val_true]
.lte_end:
    movsd xmm0, [rax]
    movsd [rdi + r9 * 8], xmm0
    NEXT

op_gte:
    mov rcx, [rsi]; add rsi, 8
    mov r8, [rsi]; add rsi, 8
    mov r9, [rsi]; add rsi, 8
    movsd xmm0, [rdi + rcx * 8]
    movsd xmm1, [rdi + r8 * 8]
    comisd xmm0, xmm1
    jae .gte_true
    lea rax, [rip + val_false]
    jmp .gte_end
.gte_true:
    lea rax, [rip + val_true]
.gte_end:
    movsd xmm0, [rax]
    movsd [rdi + r9 * 8], xmm0
    NEXT

op_ret:
    lea r8, [rip + call_sp]
    mov r9, [r8]         # r9 = call_sp
    dec r9
    mov [r8], r9
    lea r10, [rip + call_stack]
    mov rsi, [r10 + r9 * 8]
    NEXT

op_push:
    mov rcx, [rsi]       # reg num
    add rsi, 8
    lea r8, [rip + val_sp]
    mov r9, [r8]
    lea r10, [rip + val_stack]
    mov rax, [rdi + rcx * 8]
    mov [r10 + r9 * 8], rax
    inc r9
    mov [r8], r9
    NEXT

op_pop:
    mov rcx, [rsi]
    add rsi, 8
    lea r8, [rip + val_sp]
    mov r9, [r8]
    dec r9
    mov [r8], r9
    lea r10, [rip + val_stack]
    mov rax, [r10 + r9 * 8]
    mov [rdi + rcx * 8], rax
    mov [rbx + rcx * 8], rax
    NEXT

op_print_c:
    mov r8, [rsi]        # char_reg
    add rsi, 8
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    mov rdx, rcx
    lea rcx, [rip + char_fmt]
    call printf
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    NEXT

op_print_str:
    mov r8, [rsi]        # ptr_reg (register number)
    add rsi, 8
    mov r11, [rdi + r8 * 8]  # check float_bank
    test r11, r11
    jnz 1f
    mov r11, [rbx + r8 * 8]  # fallback to ptr_bank
1:
    push rsi
    push rdi
    push rbx             # extra push to align stack to 16
    sub rsp, 40          # shadow space
    lea rcx, [rip + str_fmt]
    mov rdx, r11
    call printf
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    NEXT

op_sin:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # src
    add rsi, 16
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32
    movsd xmm0, [rdi + r8 * 8]
    call sin
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_sqrt:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # src
    add rsi, 16
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32
    movsd xmm0, [rdi + r8 * 8]
    call sqrt
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_cos:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # src
    add rsi, 16
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32
    movsd xmm0, [rdi + r8 * 8]
    call cos
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_pow:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # src1
    mov r9,  [rsi+16]    # src2
    add rsi, 24
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32
    movsd xmm0, [rdi + r8 * 8]
    movsd xmm1, [rdi + r9 * 8]
    call pow
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_abs:
    mov rcx, [rsi]       # dest
    mov r8,  [rsi+8]     # src
    add rsi, 16
    movsd xmm0, [rdi + r8 * 8]
    pxor xmm1, xmm1
    comisd xmm0, xmm1
    jae .abs_done
    subsd xmm1, xmm0
    movaps xmm0, xmm1
.abs_done:
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_exit:
    mov r8, [rsi]        # code_reg
    add rsi, 8
    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    call exit

op_str_cat:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # src1
    mov r9,  [rsi+16]    # src2
    add rsi, 24

    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz .sc_have_s1
    mov rax, [rdi + r8 * 8]
.sc_have_s1:
    mov rdx, [rbx + r9 * 8]
    test rdx, rdx
    jnz .sc_have_s2
    mov rdx, [rdi + r9 * 8]
.sc_have_s2:
    xor r10, r10
.sc_s1_len:
    cmp byte ptr [rax + r10], 0
    je .sc_s1_done
    inc r10
    jmp .sc_s1_len
.sc_s1_done:
    xor r11, r11
.sc_s2_len:
    cmp byte ptr [rdx + r11], 0
    je .sc_s2_done
    inc r11
    jmp .sc_s2_len
.sc_s2_done:
    lea rcx, [r10 + r11 + 1]

    push rsi
    push rdi
    push rbx
    push r12
    push rax
    push rdx
    push r10
    push r11
    sub rsp, 40

    call malloc

    add rsp, 40
    pop r11
    pop r10
    pop rdx
    pop rcx
    pop r12
    pop rbx
    pop rdi
    pop rsi

    xor r8, r8
.sc_cp1:
    cmp r8, r10
    je .sc_cp1_done
    mov r9b, [rcx + r8]
    mov [rax + r8], r9b
    inc r8
    jmp .sc_cp1
.sc_cp1_done:
    xor r8, r8
.sc_cp2:
    cmp r8, r11
    je .sc_cp2_done
    mov r9b, [rdx + r8]
    lea r13, [r10 + r8]
    mov [rax + r13], r9b
    inc r8
    jmp .sc_cp2
.sc_cp2_done:
    lea r13, [r10 + r11]
    mov byte ptr [rax + r13], 0

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_sub:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    subsd xmm0, [rdi + r9 * 8]
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_mul:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    mulsd xmm0, [rdi + r9 * 8]
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_div:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    divsd xmm0, [rdi + r9 * 8]
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_gt:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    movsd xmm1, [rdi + r9 * 8]
    comisd xmm0, xmm1
    seta al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_neq:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    mov rax, [rdi + r8 * 8]
    cmp rax, [rdi + r9 * 8]
    setne al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_mov:
    mov rcx, [rsi]; mov r8, [rsi+8]; add rsi, 16
    mov rax, [rdi + r8 * 8]
    mov [rdi + rcx * 8], rax
    NEXT

op_not:
    mov rcx, [rsi]; mov r8, [rsi+8]; add rsi, 16
    mov rax, [rdi + r8 * 8]
    test rax, rax
    setz al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_store_ptr:
    mov rcx, [rsi]; mov r8, [rsi+8]; add rsi, 16
    mov rax, [rbx + rcx * 8]   # rax = pointer
    mov rdx, [rbx + r8 * 8]    # rdx = value
    mov [rax], rdx
    NEXT

op_load_ptr:
    mov rcx, [rsi]; mov r8, [rsi+8]; add rsi, 16
    mov rax, [rbx + r8 * 8]    # rax = pointer
    mov rdx, [rax]
    mov [rbx + rcx * 8], rdx
    NEXT

op_puts:
    push rsi
    push rdi
    sub rsp, 40
    lea rcx, [rip + str_fmt]
    mov rdx, rsi            # rsi points right at the inline string
    call printf
    add rsp, 40
    pop rdi
    pop rsi
    # advance rsi past the null-terminated string
    .puts_skip:
        mov al, byte ptr [rsi]
        inc rsi
        cmp al, 0
        jne .puts_skip
    # align rsi to next 8-byte boundary
    add rsi, 7
    and rsi, -8
    NEXT

op_load_f:
    mov rcx, [rsi]       # dest (float bank)
    mov r8,  [rsi+8]     # ptr_reg (POINTER BANK)
    mov r9,  [rsi+16]    # offset_reg (float bank)
    add rsi, 24
    mov rax, [rbx + r8 * 8]    # ptr from POINTER BANK
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]    # fallback to float bank
1:
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0        # offset
    movsd xmm0, [rax + rdx]    # load 64-bit float
    movsd [rdi + rcx * 8], xmm0 # store in float bank
    NEXT

op_store_f:
    mov r8,  [rsi]       # ptr_reg (POINTER BANK)
    mov r9,  [rsi+8]     # offset_reg (float bank)
    mov r10, [rsi+16]    # val_reg (float bank)
    add rsi, 24
    mov rax, [rbx + r8 * 8]    # ptr from POINTER BANK
    test rax, rax
    jnz 2f
    mov rax, [rdi + r8 * 8]    # fallback to float bank
2:
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0        # offset
    movsd xmm0, [rdi + r10 * 8] # val from float bank
    movsd [rax + rdx], xmm0    # store 64-bit float
    NEXT


op_load_ptr_o:
    mov r8, [rsi]; mov r9, [rsi+8]; mov r10, [rsi+16]; add rsi, 24
    mov rax, [rbx + r9 * 8]
    movsd xmm0, [rdi + r10 * 8]
    cvttsd2si rcx, xmm0
    mov rdx, [rax + rcx]
    mov [rbx + r8 * 8], rdx
    NEXT

op_store_ptr_o:
    mov r8, [rsi]; mov r9, [rsi+8]; mov r10, [rsi+16]; add rsi, 24
    mov rax, [rbx + r8 * 8]
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rcx, xmm0
    mov rdx, [rbx + r10 * 8]
    mov [rax + rcx], rdx
    NEXT



op_push_ptr:
    mov rcx, [rsi]; add rsi, 8
    mov rax, [rbx + rcx * 8]
    lea r8, [rip + ptr_sp]
    mov rdx, [r8]
    lea r9, [rip + ptr_stack]
    mov [r9 + rdx * 8], rax
    inc qword ptr [r8]
    NEXT

op_pop_ptr:
    mov rcx, [rsi]; add rsi, 8
    lea r8, [rip + ptr_sp]
    dec qword ptr [r8]
    mov rdx, [r8]
    lea r9, [rip + ptr_stack]
    mov rax, [r9 + rdx * 8]
    mov [rbx + rcx * 8], rax
    NEXT

op_halt:
    jmp vm_exit



op_ret_dynamic:
    lea r8, [rip + call_sp]
    mov r9, [r8]
    dec r9
    mov [r8], r9
    lea r10, [rip + call_stack]
    mov rsi, [r10 + r9 * 8]
    NEXT


# --- Main Entry ---
main:
    mov [rip + argc_store], rcx
    mov [rip + argv_store], rdx
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 40      # align stack for Windows x64 ABI

    # Allocate VM Float Registers Array (rdi) â€” 256 regs * 8 bytes
    mov rcx, 2048
    call malloc
    mov rdi, rax
    
    # Allocate VM Pointer Registers Array (rbx) â€” 256 raw ptrs * 8 bytes
    mov rbx, rdi
    
    # Allocate Bytecode Array â€” 512KB for complex programs
    mov rcx, 524288
    call malloc
    mov r12, rax
    mov r13, rax

    # Allocate Call Stack (r15)
    mov rcx, 65536
    call malloc
    mov r15, rax
    
    # ---------------------------------------------------------
    # ASSEMBLY LEXER & PARSER
    # Reads .nxasm file from argv[1] or tests/vm/boot.nxasm by default
    # rbp+16 = argc, rbp+24 = argv on Windows x64
    # ---------------------------------------------------------
    # ---------------------------------------------------------
    # CLI ARGUMENT PARSER
    # Parses flags (--debug, -d) and file arguments (.nx, .nxasm)
    # ---------------------------------------------------------
    mov dword ptr [rip + vm_debug], 0
    mov qword ptr [rip + cli_source_file], 0
    mov qword ptr [rip + target_asm_file], 0

    mov ecx, [rip + argc_store]
    mov rdx, [rip + argv_store]
    mov r8d, 1

.arg_loop:
    cmp r8d, ecx
    jge .arg_done

    mov r9, [rdx + r8 * 8]
    test r9, r9
    jz .next_arg

    cmp byte ptr [r9], '-'
    jne .not_flag

    cmp byte ptr [r9 + 1], 'd'
    je .set_debug_flag
    cmp byte ptr [r9 + 1], '-'
    jne .next_arg
    cmp byte ptr [r9 + 2], 'd'
    je .set_debug_flag
    jmp .next_arg

.set_debug_flag:
    mov dword ptr [rip + vm_debug], 1
    jmp .next_arg

.not_flag:
    mov r10, r9
.strlen_loop:
    cmp byte ptr [r10], 0
    je .strlen_done
    inc r10
    jmp .strlen_loop

.strlen_done:
    mov rax, r10
    sub rax, r9

    cmp rax, 6
    jb .check_nx
    cmp byte ptr [r10 - 6], '.'
    jne .check_nx
    cmp byte ptr [r10 - 5], 'n'
    jne .check_nx
    cmp byte ptr [r10 - 4], 'x'
    jne .check_nx
    cmp byte ptr [r10 - 3], 'a'
    jne .check_nx
    cmp byte ptr [r10 - 2], 's'
    jne .check_nx
    cmp byte ptr [r10 - 1], 'm'
    jne .check_nx
    mov [rip + target_asm_file], r9
    jmp .next_arg

.check_nx:
    cmp rax, 3
    jb .check_other
    cmp byte ptr [r10 - 3], '.'
    jne .check_other
    cmp byte ptr [r10 - 2], 'n'
    jne .check_other
    cmp byte ptr [r10 - 1], 'x'
    jne .check_other
    mov [rip + cli_source_file], r9
    jmp .next_arg

.check_other:
    cmp qword ptr [rip + target_asm_file], 0
    jne .next_arg
    mov [rip + target_asm_file], r9

.next_arg:
    inc r8d
    mov ecx, [rip + argc_store]
    mov rdx, [rip + argv_store]
    jmp .arg_loop

.arg_done:
    mov rcx, [rip + target_asm_file]
    test rcx, rcx
    jnz .open_file

    mov rax, [rip + cli_source_file]
    test rax, rax
    jz .use_default_boot
    lea rcx, [rip + default_compiler]
    mov [rip + target_asm_file], rcx
    jmp .open_file

.use_default_boot:
    lea rcx, [rip + file_name]
    mov [rip + target_asm_file], rcx

.open_file:
    mov rcx, [rip + target_asm_file]
    lea rdx, [rip + read_mode]
    call fopen
    cmp rax, 0
    jne .file_opened
    lea rcx, [rip + err_msg]
    mov rdx, [rip + target_asm_file]
    call printf
    jmp .end

.file_opened:
    mov r14, rax

.read_loop:
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + token_buf]
    call fscanf
    cmp eax, 1
    jne .parse_done

    mov eax, [rip + vm_debug]
    cmp eax, 1
    jne .skip_token_print
    push rdi
    sub rsp, 40
    lea rcx, [rip + str_fmt]
    lea rdx, [rip + token_buf]
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop rdi
.skip_token_print:
    
    mov rcx, 0
    
    lea rax, [rip + token_buf]
    cmp byte ptr [rax], '#'
    jne .check_LOAD
    
.comment_loop:
    mov rcx, r14
    call fgetc
    cmp eax, 10
    je .read_loop
    cmp eax, -1
    je .parse_done
    jmp .comment_loop
    
.check_LOAD:
    # check LOAD
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_ADD
    
    lea rax, [rip + op_load_const]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + val_buf]
    call fscanf
    lea rcx, [rip + val_buf]
    call atof
    movsd [r13], xmm0
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

.check_ADD:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_ADD]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_PRINT
    
    lea rax, [rip + op_add]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_PRINT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PRINT]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_HALT
    
    lea rax, [rip + op_print]
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

.check_HALT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_HALT]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_LT
    
    lea rax, [rip + op_halt]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_LT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LT]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_EQ
    
    lea rax, [rip + op_lt]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_EQ:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_EQ]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_LABEL
    
    lea rax, [rip + op_eq]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_LABEL:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LABEL]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_JMP
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    lea r8, [rip + labels_array]
    mov [r8 + rax * 8], r13      # labels_array[id] = current r13
    jmp .read_loop

.check_JMP:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_JMP]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_JMP_F
    
    lea rax, [rip + op_jmp]
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

.check_JMP_F:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_JMP_F]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_LOAD_STR
    
    lea rax, [rip + op_jmp_f]
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

.check_LOAD_STR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD_STR]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_FOPEN
    
    # Emit op_load_raw (stores pointer, NOT float)
    lea rax, [rip + op_load_raw]
    mov [r13], rax
    add r13, 8
    
    # Read the string argument and strdup it â€” store raw pointer
    push rdi
    sub rsp, 40
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + val_buf]
    call fscanf
    lea rcx, [rip + val_buf]
    call strlen
    mov rcx, rax
    inc rcx
    call malloc
    mov r15, rax
    mov rcx, rax
    lea rdx, [rip + val_buf]
    call strcpy
    mov rax, r15
    add rsp, 40
    pop rdi
    mov [r13], rax    # raw pointer (char*)
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
    cmp eax, 50
    jne 1f
    mov rdx, [rip + cli_source_file]
    test rdx, rdx
    jz 1f
    mov [r13 - 16], rdx
1:
    jmp .read_loop

.check_FOPEN:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_FOPEN]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_FGETC
    
    lea rax, [rip + op_fopen]
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

.check_FGETC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_FGETC]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_PRINT_C
    
    lea rax, [rip + op_fgetc]
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

.check_PRINT_C:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PRINT_C]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_PRINT_STR
    
    lea rax, [rip + op_print_c]
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

.check_PRINT_STR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PRINT_STR]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_SUB
    
    lea rax, [rip + op_print_str]
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


.check_SUB:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_SUB]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_MUL
    
    lea rax, [rip + op_sub]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_MUL:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_MUL]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_DIV
    
    lea rax, [rip + op_mul]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_DIV:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_DIV]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GT
    
    lea rax, [rip + op_div]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_GT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_GT]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_NEQ
    
    lea rax, [rip + op_gt]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_NEQ:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_NEQ]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_MOV
    
    lea rax, [rip + op_neq]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_MOV:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_MOV]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_NOT
    
    lea rax, [rip + op_mov]
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

.check_NOT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_NOT]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_STORE_PTR
    
    lea rax, [rip + op_not]
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

.check_STORE_PTR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_STORE_PTR]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_LOAD_PTR
    
    lea rax, [rip + op_store_ptr]
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

.check_LOAD_PTR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD_PTR]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_PUTS
    
    lea rax, [rip + op_load_ptr]
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

# PUTS: embeds a literal string into the bytecode stream
# The string is read from the source line (rest of line via fgets-like approach)
# We use a helper that reads until newline from the file
.check_PUTS:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PUTS]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_ALLOC
    
    # Emit op_puts handler address
    lea rax, [rip + op_puts]
    mov [r13], rax
    add r13, 8
    
    # Read the inline string argument using the rest of the line
    # We use scan_fmt to get next token (space-delimited argument)
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + val_buf]
    call fscanf
    # val_buf now has the string â€” embed it directly into bytecode
    # copy bytes from val_buf into bytecode array r13 using r15 as src ptr
    push r15
    lea r15, [rip + val_buf]
    .puts_embed_loop:
        mov al, byte ptr [r15]
        mov byte ptr [r13], al
        inc r15
        inc r13
        cmp al, 0
        jne .puts_embed_loop
    pop r15
    # align r13 to next 8-byte boundary
    add r13, 7
    and r13, -8
    jmp .read_loop

.check_ALLOC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_ALLOC]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_DICT_NEW
    
    lea rax, [rip + op_alloc]
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

.check_DICT_NEW:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_DICT_NEW]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_DICT_SET
    lea rax, [rip + op_dict_new]
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

.check_DICT_SET:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_DICT_SET]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_DICT_GET
    lea rax, [rip + op_dict_set]
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
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_DICT_GET:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_DICT_GET]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_FREE
    lea rax, [rip + op_dict_get]
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
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_FREE:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_FREE]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_LOAD_B
    
    lea rax, [rip + op_free]
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

.check_LOAD_B:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD_B]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_STORE_B
    
    lea rax, [rip + op_load_b]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_STORE_B:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_STORE_B]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_EXEC_DYNAMIC
    
    lea rax, [rip + op_store_b]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_EXEC_DYNAMIC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_EXEC_DYNAMIC]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_JMP_O
    lea rax, [rip + op_exec_dynamic]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    jmp .read_loop

.check_JMP_O:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_JMP_O]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_JMP_F_O
    lea rax, [rip + op_jmp_o]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    jmp .read_loop

.check_JMP_F_O:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_JMP_F_O]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_STORE_I
    lea rax, [rip + op_jmp_f_o]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    jmp .read_loop

.check_STORE_I:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_STORE_I]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP
    lea rax, [rip + op_store_i]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    jmp .read_loop

.check_GET_OP:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_GET_OP]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_CALL
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + val_buf]
    call fscanf

    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_DICT_NEW]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_ADD
    lea r15, [rip + op_dict_new]
    jmp .get_op_found

.check_GET_OP_ADD:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ADD]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_DICT_GET
    lea r15, [rip + op_add]
    jmp .get_op_found

.check_GET_OP_DICT_GET:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_DICT_GET]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_DICT_SET
    lea r15, [rip + op_dict_get]
    jmp .get_op_found

.check_GET_OP_DICT_SET:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_DICT_SET]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_JMP_F_O
    lea r15, [rip + op_dict_set]
    jmp .get_op_found

.check_GET_OP_JMP_F_O:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_JMP_F_O]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_JMP_O
    lea r15, [rip + op_jmp_f_o]
    jmp .get_op_found

.check_GET_OP_JMP_O:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_JMP_O]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_LOAD
    lea r15, [rip + op_jmp_o]
    jmp .get_op_found

.check_GET_OP_LOAD:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_LOAD]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_LOAD_RAW
    lea r15, [rip + op_load_const]
    jmp .get_op_found

.check_GET_OP_LOAD_RAW:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_LOAD_RAW]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_POP
    lea r15, [rip + op_load_raw]
    jmp .get_op_found

.check_GET_OP_POP:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_POP]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_PRINT
    lea r15, [rip + op_pop]
    jmp .get_op_found

.check_GET_OP_PRINT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_PRINT]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_PUSH
    lea r15, [rip + op_print]
    jmp .get_op_found

.check_GET_OP_PUSH:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_PUSH]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_RET
    lea r15, [rip + op_push]
    jmp .get_op_found

.check_GET_OP_RET:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_RET]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_CALL_O
    lea r15, [rip + op_ret]
    jmp .get_op_found

.check_GET_OP_CALL_O:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_CALL_O]
    call strcmp
    test eax, eax
    jne .check_GET_OP_EQ
    lea r15, [rip + op_call_o]
    jmp .get_op_found

.check_GET_OP_EQ:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_EQ]
    call strcmp
    test eax, eax
    jne .check_GET_OP_SUB
    lea r15, [rip + op_eq]
    jmp .get_op_found

.check_GET_OP_SUB:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_SUB]
    call strcmp
    test eax, eax
    jne .check_GET_OP_MUL
    lea r15, [rip + op_sub]
    jmp .get_op_found

.check_GET_OP_MUL:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_MUL]
    call strcmp
    test eax, eax
    jne .check_GET_OP_DIV
    lea r15, [rip + op_mul]
    jmp .get_op_found

.check_GET_OP_DIV:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_DIV]
    call strcmp
    test eax, eax
    jne .check_GET_OP_NEQ
    lea r15, [rip + op_div]
    jmp .get_op_found

.check_GET_OP_NEQ:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_NEQ]
    call strcmp
    test eax, eax
    jne .check_GET_OP_LT
    lea r15, [rip + op_neq]
    jmp .get_op_found

.check_GET_OP_LT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_LT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_GT
    lea r15, [rip + op_lt]
    jmp .get_op_found

.check_GET_OP_GT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_GT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_LTE
    lea r15, [rip + op_gt]
    jmp .get_op_found

.check_GET_OP_LTE:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_LTE]
    call strcmp
    test eax, eax
    jne .check_GET_OP_GTE
    lea r15, [rip + op_lte]
    jmp .get_op_found

.check_GET_OP_GTE:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_GTE]
    call strcmp
    test eax, eax
    jne .check_GET_OP_PRINT_STR
    lea r15, [rip + op_gte]
    jmp .get_op_found

.check_GET_OP_PRINT_STR:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_PRINT_STR]
    call strcmp
    test eax, eax
    jne .check_GET_OP_SIN
    lea r15, [rip + op_print_str]
    jmp .get_op_found

.check_GET_OP_SIN:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_SIN]
    call strcmp
    test eax, eax
    jne .check_GET_OP_SQRT
    lea r15, [rip + op_sin]
    jmp .get_op_found

.check_GET_OP_SQRT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_SQRT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_ALLOC
    lea r15, [rip + op_sqrt]
    jmp .get_op_found

.check_GET_OP_ALLOC:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ALLOC]
    call strcmp
    test eax, eax
    jne .check_GET_OP_LOAD_F
    lea r15, [rip + op_alloc]
    jmp .get_op_found

.check_GET_OP_LOAD_F:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_LOAD_F]
    call strcmp
    test eax, eax
    jne .check_GET_OP_STORE_F
    lea r15, [rip + op_load_f]
    jmp .get_op_found

.check_GET_OP_STORE_F:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_STORE_F]
    call strcmp
    test eax, eax
    jne .check_GET_OP_STR_CAT
    lea r15, [rip + op_store_f]
    jmp .get_op_found

.check_GET_OP_STR_CAT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_STR_CAT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_COS
    lea r15, [rip + op_str_cat]
    jmp .get_op_found

.check_GET_OP_COS:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_COS]
    call strcmp
    test eax, eax
    jne .check_GET_OP_POW
    lea r15, [rip + op_cos]
    jmp .get_op_found

.check_GET_OP_POW:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_POW]
    call strcmp
    test eax, eax
    jne .check_GET_OP_ABS
    lea r15, [rip + op_pow]
    jmp .get_op_found

.check_GET_OP_ABS:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ABS]
    call strcmp
    test eax, eax
    jne .check_GET_OP_EXIT
    lea r15, [rip + op_abs]
    jmp .get_op_found

.check_GET_OP_EXIT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_EXIT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_HALT
    lea r15, [rip + op_exit]
    jmp .get_op_found

.check_GET_OP_HALT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_HALT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_NOT_FOUND
    lea r15, [rip + op_halt]
    jmp .get_op_found

.check_GET_OP_NOT_FOUND:
    jmp .read_loop

.get_op_found:
    lea rax, [rip + op_load_raw_ptr]
    mov [r13], rax
    add r13, 8
    
    mov [r13], r15
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    jmp .read_loop

.check_CALL:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_CALL]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_RET
    
    lea rax, [rip + op_call]
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

.check_RET:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_RET]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_PUSH
    
    lea rax, [rip + op_ret]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_PUSH:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PUSH]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_POP
    
    lea rax, [rip + op_push]
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

.check_POP:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_POP]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_LOAD_F
    
    lea rax, [rip + op_pop]
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

.check_LOAD_F:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD_F]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_STORE_F
    
    lea rax, [rip + op_load_f]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_STORE_F:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_STORE_F]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_LOAD_PTR_O
    jmp .store_f_match

.check_LOAD_PTR_O:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD_PTR_O]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_STORE_PTR_O
    lea rax, [rip + op_load_ptr_o]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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


.check_STORE_PTR_O:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_STORE_PTR_O]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_PUSH_PTR
    lea rax, [rip + op_store_ptr_o]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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


.check_PUSH_PTR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PUSH_PTR]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_POP_PTR
    
    lea rax, [rip + op_push_ptr]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    jmp .read_loop


.check_POP_PTR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_POP_PTR]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .check_PANIC
    
    lea rax, [rip + op_pop_ptr]
    mov [r13], rax
    add r13, 8
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atof
    cvttsd2si r15, xmm0
    mov [r13], r15
    add r13, 8
    jmp .read_loop


.store_f_match:
    
    lea rax, [rip + op_store_f]
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
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
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

.check_PANIC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PANIC]
    # Dump 8 bytes of r11
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rcx]
    mov rdx, rcx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    # Dump 8 bytes of [r13]
    push rsi
    push rdi
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    sub rsp, 40
    mov r8, [rdx]
    mov rdx, rdx
    lea rcx, [rip + str_hex_fmt]
    mov eax, 0
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    
    call strcmp
    cmp eax, 0
    jne .print_bad_token
    lea rax, [rip + op_panic]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.print_bad_token:
    sub rsp, 32
    lea rcx, [rip + bad_token_fmt]
    lea rdx, [rip + token_buf]
    call printf
    mov rcx, 0
    call fflush
    mov rcx, 2
    call exit

.parse_done:
    mov eax, [rip + vm_debug]
    cmp eax, 1
    jne 1f
    sub rsp, 32
    lea rcx, [rip + parse_done_msg]
    call printf
    mov rcx, 0
    call fflush
    add rsp, 32
1:
    mov rcx, r14
    call fclose
    
    # ---------------------------------------------------------
    # EXECUTE THE COMPILED BYTECODE
    # ---------------------------------------------------------
    mov rcx, r13
    sub rcx, r12
    shr rcx, 3
    mov rdx, rcx
    mov dword ptr [rip + in_exec], 1
    mov rsi, r12        # Start of bytecode
    
    mov eax, [rip + vm_debug]
    cmp eax, 1
    jne 2f
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    lea rcx, [rip + parse_done_msg]
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
2:
    NEXT

vm_exit:
    lea rcx, [rip + time_msg]
    call printf

.end:
    xor eax, eax
    add rsp, 40
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rsi
    pop rbx
    pop rbp
    ret
