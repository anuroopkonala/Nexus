def modify_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    out = []
    in_alloc = False
    in_panic = False

    for i, line in enumerate(lines):
        if line.startswith('.extern fclose'):
            out.append(line)
            out.append(".extern sin\n.extern cos\n.extern pow\n.extern sqrt\n.extern strlen\n.extern strcat\n.extern fread\n.extern fwrite\n.extern gets\n")
            continue
            
        if line.startswith('str_LOAD:'):
            out.append('str_FREAD: .asciz "FREAD"\nstr_FWRITE: .asciz "FWRITE"\nstr_FCLOSE: .asciz "FCLOSE"\nstr_INPUT: .asciz "INPUT"\nstr_STR_CAT: .asciz "STR_CAT"\nstr_SQRT: .asciz "SQRT"\nstr_SIN: .asciz "SIN"\nstr_COS: .asciz "COS"\nstr_POW: .asciz "POW"\nstr_PANIC: .asciz "PANIC"\npanic_msg: .asciz "VM PANIC!\\n"\nstack_trace_msg: .asciz "Stack trace:\\n  <main>\\n"\n')
            out.append(line)
            continue
            
        if line.startswith('ptr_sp: .space 8'):
            out.append(line)
            out.append('alloc_head: .space 8\ngc_count: .space 8\ngc_threshold: .space 8\n')
            continue

        if line.startswith('op_alloc:'):
            in_alloc = True
            
            # Insert GC and new ops
            gc_code = """op_alloc:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # size_reg
    add rsi, 16
    push rsi
    push rdi
    push rbx
    sub rsp, 40

    lea r9, [rip + gc_count]
    mov r10, [r9]
    inc r10
    mov [r9], r10
    cmp r10, 1000
    jl .skip_gc
    call run_gc
.skip_gc:

    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    add rcx, 16
    push rcx
    call malloc
    pop rcx
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi

    mov qword ptr [rax], 0
    lea r9, [rip + alloc_head]
    mov r10, [r9]
    mov [rax+8], r10
    mov [r9], rax
    
    add rax, 16
    mov [rbx + r12 * 8], rax
    NEXT

run_gc:
    lea r8, [rip + alloc_head]
    mov rax, [r8]
.clear_loop:
    test rax, rax
    jz .mark_roots
    mov qword ptr [rax], 0
    mov rax, [rax+8]
    jmp .clear_loop

.mark_roots:
    lea r12, [rip + val_sp]
    mov r13, [r12]
    test r13, r13
    jz .mark_ptr_stack
    lea r14, [rip + val_stack]
    xor r15, r15
.val_scan:
    mov rdx, [r14 + r15*8]
    call mark_if_valid
    inc r15
    cmp r15, r13
    jl .val_scan

.mark_ptr_stack:
    lea r12, [rip + ptr_sp]
    mov r13, [r12]
    test r13, r13
    jz .mark_call_stack
    lea r14, [rip + ptr_stack]
    xor r15, r15
.ptr_scan:
    mov rdx, [r14 + r15*8]
    call mark_if_valid
    inc r15
    cmp r15, r13
    jl .ptr_scan

.mark_call_stack:
    lea r12, [rip + call_sp]
    mov r13, [r12]
    test r13, r13
    jz .sweep
    lea r14, [rip + call_stack]
    xor r15, r15
.call_scan:
    mov rdx, [r14 + r15*8]
    call mark_if_valid
    inc r15
    cmp r15, r13
    jl .call_scan

.sweep:
    lea r8, [rip + alloc_head]
    mov r9, r8
    mov rax, [r8]
.sweep_loop:
    test rax, rax
    jz .gc_done
    mov r10, [rax]
    cmp r10, 1
    je .keep_block
    mov r11, [rax+8]
    mov [r9], r11
    push rax
    push r9
    push r8
    sub rsp, 40
    mov rcx, rax
    call free
    add rsp, 40
    pop r8
    pop r9
    pop rax
    mov rax, [r9]
    jmp .sweep_loop

.keep_block:
    lea r9, [rax+8]
    mov rax, [r9]
    jmp .sweep_loop

.gc_done:
    lea r8, [rip + gc_count]
    mov qword ptr [r8], 0
    ret

mark_if_valid:
    lea r8, [rip + alloc_head]
    mov rax, [r8]
.miv_loop:
    test rax, rax
    jz .miv_done
    lea r9, [rax+16]
    cmp rdx, r9
    jne .miv_next
    mov qword ptr [rax], 1
    ret
.miv_next:
    mov rax, [rax+8]
    jmp .miv_loop
.miv_done:
    ret

op_fread:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    mov r10, [rsi+24]
    add rsi, 32
    NEXT

op_fwrite:
    mov r8, [rsi]
    mov r9, [rsi+8]
    mov r10, [rsi+16]
    add rsi, 24
    NEXT

op_fclose:
    mov r8, [rsi]
    add rsi, 8
    NEXT

op_input:
    mov r8, [rsi]
    add rsi, 8
    NEXT

op_str_cat:
    mov r8, [rsi]
    mov r9, [rsi+8]
    mov r10, [rsi+16]
    add rsi, 24
    NEXT

op_sqrt:
    mov rcx, [rsi]
    mov r8, [rsi+8]
    add rsi, 16
    NEXT

op_sin:
    mov rcx, [rsi]
    mov r8, [rsi+8]
    add rsi, 16
    NEXT

op_cos:
    mov rcx, [rsi]
    mov r8, [rsi+8]
    add rsi, 16
    NEXT

op_pow:
    mov rcx, [rsi]
    mov r8, [rsi+8]
    mov r9, [rsi+16]
    add rsi, 24
    NEXT

op_panic:
    mov r8, [rsi]
    add rsi, 8
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    lea rcx, [rip + panic_msg]
    call printf
    lea rcx, [rip + stack_trace_msg]
    call printf
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    jmp vm_exit

"""
            out.append(gc_code)
            continue
            
        if in_alloc:
            if line.startswith('op_free:'):
                in_alloc = False
                out.append(line)
            continue

        if line.startswith('.parse_done:'):
            lexer_code = """.check_PANIC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PANIC]
    call strcmp
    cmp eax, 0
    jne .parse_error
    lea rax, [rip + op_panic]
    mov [r13], rax
    add r13, 8
    jmp .read_loop
.parse_error:
    jmp .read_loop
"""
            out.append(lexer_code)
            out.append(line)
            continue
            
        out.append(line)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(out)

if __name__ == '__main__':
    modify_file('nexus_core.s')
