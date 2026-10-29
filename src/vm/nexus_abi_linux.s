.intel_syntax noprefix

# ==============================================================================
# Nexus Baremetal - Linux x86-64 SysV ABI & Direct Syscall Subsystem
# Pure Assembly Implementation (Zero-Libc / Zero-Dependency)
# ==============================================================================

.global linux_sys_write
.global linux_sys_read
.global linux_sys_open
.global linux_sys_close
.global linux_sys_mmap
.global linux_sys_munmap
.global linux_sys_exit
.global linux_sys_socket
.global linux_sys_connect
.global linux_sys_sendto
.global linux_sys_recvfrom
.global linux_nexus_entry

.text
.align 16

# ------------------------------------------------------------------------------
# Direct Linux Kernel Syscall Wrappers
# SysV ABI: rdi=arg1, rsi=arg2, rdx=arg3, rcx=arg4 (syscall uses r10), r8=arg5, r9=arg6
# ------------------------------------------------------------------------------

# ssize_t linux_sys_write(int fd, const void* buf, size_t count)
linux_sys_write:
    mov rax, 1                          # __NR_write = 1
    syscall
    ret

# ssize_t linux_sys_read(int fd, void* buf, size_t count)
linux_sys_read:
    mov rax, 0                          # __NR_read = 0
    syscall
    ret

# int linux_sys_open(const char* filename, int flags, int mode)
linux_sys_open:
    mov rax, 2                          # __NR_open = 2
    syscall
    ret

# int linux_sys_close(int fd)
linux_sys_close:
    mov rax, 3                          # __NR_close = 3
    syscall
    ret

# void* linux_sys_mmap(void* addr, size_t length, int prot, int flags, int fd, off_t offset)
linux_sys_mmap:
    mov r10, rcx                        # Linux syscall convention expects arg4 in r10
    mov rax, 9                          # __NR_mmap = 9
    syscall
    ret

# int linux_sys_munmap(void* addr, size_t length)
linux_sys_munmap:
    mov rax, 11                         # __NR_munmap = 11
    syscall
    ret

# void linux_sys_exit(int error_code)
linux_sys_exit:
    mov rax, 60                         # __NR_exit = 60
    syscall
    # Does not return

# int linux_sys_socket(int family, int type, int protocol)
linux_sys_socket:
    mov rax, 41                         # __NR_socket = 41
    syscall
    ret

# int linux_sys_connect(int fd, struct sockaddr* uservaddr, int addrlen)
linux_sys_connect:
    mov rax, 42                         # __NR_connect = 42
    syscall
    ret

# ssize_t linux_sys_sendto(int fd, void* buff, size_t len, unsigned flags, struct sockaddr* addr, int addr_len)
linux_sys_sendto:
    mov r10, rcx
    mov rax, 44                         # __NR_sendto = 44
    syscall
    ret

# ssize_t linux_sys_recvfrom(int fd, void* ubuf, size_t size, unsigned flags, struct sockaddr* addr, int* addr_len)
linux_sys_recvfrom:
    mov r10, rcx
    mov rax, 45                         # __NR_recvfrom = 45
    syscall
    ret

# ------------------------------------------------------------------------------
# Standalone Linux ELF Entry Point (_start)
# Parses stack: [rsp] = argc, [rsp + 8] = argv[0], [rsp + 16] = argv[1]...
# ------------------------------------------------------------------------------
linux_nexus_entry:
.global _start
_start:
    xor rbp, rbp                        # Mark deepest stack frame according to SysV ABI
    pop rdi                             # rdi = argc
    mov rsi, rsp                        # rsi = argv

    # Zero exit on clean termination
    xor edi, edi
    call linux_sys_exit
