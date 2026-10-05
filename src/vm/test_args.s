.intel_syntax noprefix
.global main
.extern printf

.section .data
fmt: .asciz "argc=%d\n"

.section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    # rcx should be argc
    mov rdx, rcx
    lea rcx, [rip + fmt]
    call printf

    add rsp, 32
    pop rbp
    ret
