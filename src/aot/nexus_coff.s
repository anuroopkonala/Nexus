.intel_syntax noprefix

# ==============================================================================
# Nexus Baremetal - Standalone Native COFF .obj & Native Binary Emitter
# Pure x86-64 Assembly Implementation
# ==============================================================================

.global main
.global emit_coff_object
.global emit_native_asm

.extern printf
.extern fopen
.extern fwrite
.extern fclose
.extern exit
.extern malloc
.extern free

.data
.align 16

# COFF Header (20 bytes) for AMD64
# Machine = 0x8664 (IMAGE_FILE_MACHINE_AMD64)
# NumberOfSections = 2 (.text, .rdata)
# TimeDateStamp = 0
# PointerToSymbolTable = 20 + 40*2 + text_size + rdata_size
# NumberOfSymbols = 2
# SizeOfOptionalHeader = 0
# Characteristics = 0x0004
coff_header:
    .word 0x8664        # Machine: AMD64
    .word 2             # NumberOfSections: 2
    .long 0             # TimeDateStamp
    .long 0             # PointerToSymbolTable (filled dynamically)
    .long 3             # NumberOfSymbols: 3
    .word 0             # SizeOfOptionalHeader: 0
    .word 0x0004        # Characteristics: line numbers stripped

# Section Header 1: .text (40 bytes)
sec_text:
    .ascii ".text\0\0\0"
    .long 0             # VirtualSize
    .long 0             # VirtualAddress
    .long 0             # SizeOfRawData
    .long 100           # PointerToRawData (20 header + 80 sec headers)
    .long 0             # PointerToRelocations
    .long 0             # PointerToLinenumbers
    .word 0             # NumberOfRelocations
    .word 0             # NumberOfLinenumbers
    .long 0x60500020    # Characteristics: CODE | EXECUTE | READ | ALIGN_16

# Section Header 2: .rdata (40 bytes)
sec_rdata:
    .ascii ".rdata\0\0"
    .long 0             # VirtualSize
    .long 0             # VirtualAddress
    .long 0             # SizeOfRawData
    .long 0             # PointerToRawData
    .long 0             # PointerToRelocations
    .long 0             # PointerToLinenumbers
    .word 0             # NumberOfRelocations
    .word 0             # NumberOfLinenumbers
    .long 0x40300040    # Characteristics: INITIALIZED_DATA | READ | ALIGN_8

# COFF Symbol Table Entries (18 bytes per symbol)
# Symbol 0: .text section symbol
sym_text:
    .ascii ".text\0\0\0"
    .long 0             # Value
    .word 1             # SectionNumber: 1 (.text)
    .word 0             # Type
    .byte 3             # StorageClass: Static
    .byte 0             # NumberOfAuxSymbols

# Symbol 1: main entry point
sym_main:
    .ascii "main\0\0\0\0"
    .long 0             # Value: offset 0 in .text
    .word 1             # SectionNumber: 1 (.text)
    .word 0x20          # Type: Function
    .byte 2             # StorageClass: External (global)
    .byte 0             # NumberOfAuxSymbols

# Symbol 2: printf external symbol
sym_printf:
    .ascii "printf\0\0"
    .long 0             # Value: 0
    .word 0             # SectionNumber: 0 (Undefined/External)
    .word 0x20          # Type: Function
    .byte 2             # StorageClass: External
    .byte 0             # NumberOfAuxSymbols

# String table (minimum 4 bytes indicating size = 4)
string_table:
    .long 4

str_fopen_wb:
    .asciz "wb"

str_fopen_w:
    .asciz "w"

str_native_compile_success:
    .asciz "[Nexus Native Compiler] Direct COFF .obj & Native Binary Emitter complete: %s\n"

str_native_asm_template:
    .ascii ".intel_syntax noprefix\n.global main\n.extern printf, exit\n\n.text\nmain:\n"
    .ascii "    push rbp\n    mov rbp, rsp\n    sub rsp, 48\n\n"
    .ascii "    # Native CPU Execution Body\n"
    .ascii "    xorpd xmm0, xmm0\n"
    .ascii "    mov rax, 0\n"
    .ascii "    xor eax, eax\n"
    .ascii "    add rsp, 48\n    pop rbp\n    ret\n\n"
    .asciz ".rdata\nstr_fmt:\n    .asciz \"%lld\\n\"\n"

.text
.align 16

# ------------------------------------------------------------------------------
# emit_coff_object(const char* out_filename, uint8_t* code_bytes, size_t code_len)
# Emits a standard Microsoft COFF .obj file directly without any external assembler.
# ------------------------------------------------------------------------------
emit_coff_object:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 48

    mov r12, rcx                        # r12 = out_filename
    mov r13, rdx                        # r13 = code_bytes
    mov r14, r8                         # r14 = code_len

    # Open output file
    mov rcx, r12
    lea rdx, [rip + str_fopen_wb]
    call fopen
    test rax, rax
    jz .coff_fail
    mov r15, rax                        # r15 = FILE*

    # Align code_len to 16 bytes
    mov rax, r14
    add rax, 15
    and rax, -16
    mov [rip + sec_text + 16], eax      # SizeOfRawData
    mov [rip + sec_text + 8], eax       # VirtualSize

    # Offset to symbol table = 20 (header) + 40*2 (sections) + raw_code_size
    lea edx, [eax + 100]
    mov [rip + coff_header + 8], edx    # PointerToSymbolTable

    # 1. Write COFF Header (20 bytes)
    lea rcx, [rip + coff_header]
    mov edx, 1
    mov r8d, 20
    mov r9, r15
    call fwrite

    # 2. Write Section Headers (80 bytes)
    lea rcx, [rip + sec_text]
    mov edx, 1
    mov r8d, 40
    mov r9, r15
    call fwrite

    lea rcx, [rip + sec_rdata]
    mov edx, 1
    mov r8d, 40
    mov r9, r15
    call fwrite

    # 3. Write .text Raw Code
    mov rcx, r13
    mov edx, 1
    mov r8, r14
    mov r9, r15
    call fwrite

    # Padding to 16-byte alignment
    mov rax, [rip + sec_text + 16]
    sub rax, r14
    jz 1f
    sub rsp, 16
    mov rcx, rsp
    mov edx, 1
    mov r8, rax
    mov r9, r15
    call fwrite
    add rsp, 16
1:

    # 4. Write Symbol Table (3 symbols * 18 bytes = 54 bytes)
    lea rcx, [rip + sym_text]
    mov edx, 1
    mov r8d, 18
    mov r9, r15
    call fwrite

    lea rcx, [rip + sym_main]
    mov edx, 1
    mov r8d, 18
    mov r9, r15
    call fwrite

    lea rcx, [rip + sym_printf]
    mov edx, 1
    mov r8d, 18
    mov r9, r15
    call fwrite

    # 5. Write String Table (4 bytes)
    lea rcx, [rip + string_table]
    mov edx, 1
    mov r8d, 4
    mov r9, r15
    call fwrite

    # Close file
    mov rcx, r15
    call fclose

    # Report completion
    lea rcx, [rip + str_native_compile_success]
    mov rdx, r12
    call printf

    mov eax, 1
    jmp .coff_done

.coff_fail:
    xor eax, eax

.coff_done:
    add rsp, 48
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

# ------------------------------------------------------------------------------
# emit_native_asm(const char* out_s_filename)
# Emits standalone native x86-64 assembly source file for direct linking.
# ------------------------------------------------------------------------------
emit_native_asm:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    sub rsp, 40

    mov r12, rcx                        # out_s_filename
    lea rdx, [rip + str_fopen_w]
    call fopen
    test rax, rax
    jz .asm_fail
    mov rbx, rax

    lea rcx, [rip + str_native_asm_template]
    mov edx, 1
    mov r8d, 220
    mov r9, rbx
    call fwrite

    mov rcx, rbx
    call fclose

    lea rcx, [rip + str_native_compile_success]
    mov rdx, r12
    call printf

    mov eax, 1
    jmp .asm_done

.asm_fail:
    xor eax, eax

.asm_done:
    add rsp, 40
    pop r12
    pop rbx
    pop rbp
    ret

# Main CLI entry if invoked standalone
main:
    push rbp
    mov rbp, rsp
    sub rsp, 40

    # Default output test.obj
    cmp ecx, 2
    jl .main_default
    mov rdx, [rdx + 8]                  # argv[1]
    jmp .main_run

.main_default:
    lea rdx, [rip + default_out_name]

.main_run:
    # Dummy sample code: mov eax, 42; ret (B8 2A 00 00 00 C3)
    sub rsp, 16
    mov byte ptr [rsp], 0xB8
    mov dword ptr [rsp + 1], 42
    mov byte ptr [rsp + 5], 0xC3

    mov rcx, rdx
    mov rdx, rsp
    mov r8d, 6
    call emit_coff_object
    add rsp, 16

    xor eax, eax
    add rsp, 40
    pop rbp
    ret

.data
default_out_name:
    .asciz "nexus_native.obj"
