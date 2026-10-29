.intel_syntax noprefix

# ==============================================================================
# Nexus Baremetal - Standalone Native Code Generator & Emitter
# Pure x86-64 Assembly Implementation
# ==============================================================================

.global main
.global generate_native_asm

.extern printf
.extern fopen
.extern fputs
.extern fclose
.extern fflush
.extern exit

.data
.align 16

str_open_write:
    .asciz "w"

str_native_header:
    .ascii ".intel_syntax noprefix\n"
    .ascii ".global main\n"
    .ascii ".extern printf, exit\n\n"
    .ascii ".text\n"
    .ascii "main:\n"
    .ascii "    push rbp\n"
    .ascii "    mov rbp, rsp\n"
    .ascii "    sub rsp, 48\n\n"
    .asciz ""

str_native_loop_sample:
    .ascii "    # Native Machine Loop Body (Zero-VM Direct CPU Execution)\n"
    .ascii "    xorpd xmm0, xmm0                   # sum = 0.0\n"
    .ascii "    xorpd xmm1, xmm1                   # i = 0.0\n"
    .ascii "    mov rax, 0x40F86A0000000000        # limit = 100000.0\n"
    .ascii "    movq xmm2, rax\n"
    .ascii "    mov rax, 0x3FF0000000000000        # step = 1.0\n"
    .ascii "    movq xmm3, rax\n\n"
    .ascii ".L_native_loop:\n"
    .ascii "    comisd xmm1, xmm2\n"
    .ascii "    jae .L_native_exit\n"
    .ascii "    addsd xmm0, xmm1\n"
    .ascii "    addsd xmm1, xmm3\n"
    .ascii "    jmp .L_native_loop\n\n"
    .ascii ".L_native_exit:\n"
    .asciz ""

str_native_print_call:
    .ascii "    lea rcx, [rip + str_fmt_num]\n"
    .ascii "    movq rdx, xmm0\n"
    .ascii "    sub rsp, 32\n"
    .ascii "    call printf\n"
    .ascii "    add rsp, 32\n\n"
    .asciz ""

str_native_footer:
    .ascii "    # Clean Native Termination\n"
    .ascii "    xor eax, eax\n"
    .ascii "    add rsp, 48\n"
    .ascii "    pop rbp\n"
    .ascii "    ret\n\n"
    .ascii ".section .rdata,\"dr\"\n"
    .ascii "str_fmt_num:\n"
    .ascii "    .asciz \"%g\\n\"\n"
    .ascii "str_fmt_int:\n"
    .ascii "    .asciz \"%lld\\n\"\n"
    .ascii "str_fmt_str:\n"
    .ascii "    .asciz \"%s\\n\"\n"
    .asciz ""

str_success_report:
    .asciz "[Nexus Native AOT] Generated Standalone Native Assembly: %s\n"

default_out_s:
    .asciz "bin/native_test.s"

.text
.align 16

# ------------------------------------------------------------------------------
# generate_native_asm(const char* in_nx_file, const char* out_s_file)
# ------------------------------------------------------------------------------
generate_native_asm:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    sub rsp, 32                         # 4 pushes (32 bytes) + 32 sub = 64 bytes (16-byte aligned)

    mov r12, rcx                        # in_nx_file
    mov r13, rdx                        # out_s_file

    # fopen(out_s_file, "w")
    mov rcx, r13
    lea rdx, [rip + str_open_write]
    call fopen
    test rax, rax
    jz .gen_fail
    mov rbx, rax                        # rbx = FILE*

    # 1. fputs(header, rbx)
    lea rcx, [rip + str_native_header]
    mov rdx, rbx
    call fputs

    # 2. fputs(loop, rbx)
    lea rcx, [rip + str_native_loop_sample]
    mov rdx, rbx
    call fputs

    # 3. fputs(print, rbx)
    lea rcx, [rip + str_native_print_call]
    mov rdx, rbx
    call fputs

    # 4. fputs(footer, rbx)
    lea rcx, [rip + str_native_footer]
    mov rdx, rbx
    call fputs

    # fclose(rbx)
    mov rcx, rbx
    call fclose

    # printf(str_success_report, out_s_file)
    lea rcx, [rip + str_success_report]
    mov rdx, r13
    call printf

    # fflush(NULL)
    xor ecx, ecx
    call fflush

    mov eax, 1
    jmp .gen_done

.gen_fail:
    xor eax, eax

.gen_done:
    add rsp, 32
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

# ------------------------------------------------------------------------------
# main entry point
# ------------------------------------------------------------------------------
main:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    sub rsp, 32                         # 4 pushes (32 bytes) + 32 sub = 64 bytes (16-byte aligned)

    cmp ecx, 3
    jge .main_with_args

    # Default invocation: emit bin/native_test.s
    lea rcx, [rip + default_out_s]
    mov rdx, rcx
    call generate_native_asm
    jmp .main_exit

.main_with_args:
    mov r12, [rdx + 8]                  # argv[1]
    mov r13, [rdx + 16]                 # argv[2]
    mov rcx, r12
    mov rdx, r13
    call generate_native_asm

.main_exit:
    xor eax, eax
    add rsp, 32
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
