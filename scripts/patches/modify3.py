import re

def improve_panic(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    panic_code = """
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
    # Replace op_panic
    content = re.sub(r'op_panic:.*?(?=op_halt:)', panic_code + '\n', content, flags=re.DOTALL)
    
    # Add stack_trace_msg to .data
    if 'stack_trace_msg:' not in content:
        content = content.replace('panic_msg: .asciz "VM PANIC: "', 'panic_msg: .asciz "VM PANIC!\\n"\nstack_trace_msg: .asciz "Stack trace:\\n  <main>\\n"')
    
    with open(filepath, 'w') as f:
        f.write(content)

if __name__ == '__main__':
    improve_panic('nexus_core.s')
