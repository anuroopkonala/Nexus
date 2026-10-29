// ==============================================================================
// Nexus Baremetal - ARM64 / Apple Silicon (AArch64) Execution Backend
// Pure Assembly Architecture Reference & Machine Opcode Templates
// ==============================================================================

// Register Mapping Conventions:
// Float Bank:   d0 - d31 (64-bit IEEE 754 floating-point doubles)
// Pointer Bank: x19 - x28 (64-bit callee-saved pointer registers)
// Scratch GPRs: x9 - x15 (temporary calculation registers)
// Stack Frame:  x29 (Frame Pointer), x30 (Link Register)
// Argument Regs:x0 - x7 (arguments & return values)

.global arm64_op_add
.global arm64_op_sub
.global arm64_op_mul
.global arm64_op_div
.global arm64_op_fma
.global arm64_op_cmp
.global arm64_op_load
.global arm64_op_store
.global arm64_sys_write
.global arm64_sys_exit
.global arm64_macos_sys_write
.global arm64_macos_sys_exit

.text
.align 4

// ------------------------------------------------------------------------------
// Double-Precision Arithmetic Handlers (ARM64 FP / NEON Engine)
// ------------------------------------------------------------------------------

// d0 = d1 + d2
arm64_op_add:
    fadd d0, d1, d2
    ret

// d0 = d1 - d2
arm64_op_sub:
    fsub d0, d1, d2
    ret

// d0 = d1 * d2
arm64_op_mul:
    fmul d0, d1, d2
    ret

// d0 = d1 / d2
arm64_op_div:
    fdiv d0, d1, d2
    ret

// Hardware Fused Multiply-Add (FMA): d0 = d3 + (d1 * d2)
arm64_op_fma:
    fmadd d0, d1, d2, d3
    ret

// Comparison: returns 1.0 if d0 < d1, else 0.0
arm64_op_cmp:
    fcmp d0, d1
    b.mi .L_cmp_lt
    fmov d0, xzr                         // d0 = 0.0
    ret
.L_cmp_lt:
    mov x0, #0x3FF0000000000000          // 1.0 IEEE double
    fmov d0, x0
    ret

// ------------------------------------------------------------------------------
// Pointer & Memory Bank Load/Store
// x19 = base of register bank
// x0  = slot index
// ------------------------------------------------------------------------------

// Load float from register bank: d0 = [x19 + x0 * 8]
arm64_op_load:
    ldr d0, [x19, x0, lsl #3]
    ret

// Store float to register bank: [x19 + x0 * 8] = d0
arm64_op_store:
    str d0, [x19, x0, lsl #3]
    ret

// ------------------------------------------------------------------------------
// Linux ARM64 System Call Interface (Direct Kernel Syscall)
// Syscall number in x8, args in x0, x1, x2
// ------------------------------------------------------------------------------

// ssize_t arm64_sys_write(int fd, const void* buf, size_t count)
arm64_sys_write:
    mov x8, #64                          // __NR_write = 64 on Linux AArch64
    svc #0
    ret

// void arm64_sys_exit(int status)
arm64_sys_exit:
    mov x8, #93                          // __NR_exit = 93 on Linux AArch64
    svc #0
    // Does not return

// ------------------------------------------------------------------------------
// macOS Apple Silicon System Call Interface
// Syscall class 0x2000000, syscall number in x16
// ------------------------------------------------------------------------------

// ssize_t arm64_macos_sys_write(int fd, const void* buf, size_t count)
arm64_macos_sys_write:
    mov x16, #4                          // SYS_write on Darwin/BSD
    mov x8, #0x2000000
    orr x16, x16, x8                     // x16 = 0x2000004
    svc #0x80
    ret

// void arm64_macos_sys_exit(int status)
arm64_macos_sys_exit:
    mov x16, #1                          // SYS_exit on Darwin/BSD
    mov x8, #0x2000000
    orr x16, x16, x8                     // x16 = 0x2000001
    svc #0x80
    // Does not return
