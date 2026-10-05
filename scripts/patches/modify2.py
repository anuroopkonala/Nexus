import re

def improve_gc(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    new_gc = """
run_gc:
    # 1. Clear marks
    lea r8, [rip + alloc_head]
    mov rax, [r8]
.clear_loop:
    test rax, rax
    jz .mark_roots
    mov qword ptr [rax], 0
    mov rax, [rax+8]
    jmp .clear_loop

.mark_roots:
    # mark val_stack
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
    mov r9, r8           # prev_ptr
    mov rax, [r8]        # current
.sweep_loop:
    test rax, rax
    jz .gc_done
    mov r10, [rax]       # mark
    cmp r10, 1
    je .keep_block
    # free
    mov r11, [rax+8]     # next
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
"""
    # Replace run_gc
    content = re.sub(r'run_gc:.*?(?=op_fread:)', new_gc + '\n', content, flags=re.DOTALL)
    
    with open(filepath, 'w') as f:
        f.write(content)

if __name__ == '__main__':
    improve_gc('nexus_core.s')
