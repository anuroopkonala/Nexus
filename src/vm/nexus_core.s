.intel_syntax noprefix

.global main
.extern printf
.extern malloc
.extern calloc
.extern free
.extern memcpy
.extern exit
.extern fopen
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
.extern fmod
.extern floor
.extern ceil
.extern sprintf
.extern fseek
.extern ftell
.extern fputs
.extern system
.extern SetEnvironmentVariableA
.extern GetEnvironmentVariableA
.extern QueryPerformanceCounter
.extern QueryPerformanceFrequency
.extern AddVectoredExceptionHandler
.extern fflush
.extern memset
.extern strncmp

.section .data
in_crash_handler: .long 0
str_crash_fmt: .asciz "\n[CRASH DETECTED]\n  RIP=%p RSI=%p\n  R10=%p R11=%p\n  R12=%p R13=%p\n  RAX=%p RDX=%p\n"
str_rust_syntax_err:
    .asciz "\n\033[1;31merror[E0001]\033[0m: \033[1msyntax error in source code\033[0m\n  \033[1;34m-->\033[0m \033[1;37m%s\033[0m\n   \033[1;34m|\033[0m\n   \033[1;34m=\033[0m \033[1mnote\033[0m: unexpected token, malformed expression, or incomplete statement\n   \033[1;34m=\033[0m \033[1mhelp\033[0m: verify statement syntax, variable assignments, and matching delimiters\n\n"
str_rust_access_err:
    .asciz "\n\033[1;31merror[E0501]\033[0m: \033[1mruntime exception: memory access violation\033[0m\n  \033[1;34m-->\033[0m \033[1;37m%s\033[0m\n   \033[1;34m|\033[0m\n   \033[1;34m=\033[0m \033[1mnote\033[0m: attempted to access unmapped memory or dereference null pointer (RIP=%p)\n   \033[1;34m=\033[0m \033[1mhelp\033[0m: verify object initialization, array bounds, and method availability\n\n"
str_rust_stack_err:
    .asciz "\n\033[1;31merror[E0505]\033[0m: \033[1mruntime exception: call stack overflow\033[0m\n  \033[1;34m-->\033[0m \033[1;37m%s\033[0m\n   \033[1;34m|\033[0m\n   \033[1;34m=\033[0m \033[1mnote\033[0m: maximum recursion call depth exceeded (RIP=%p)\n   \033[1;34m=\033[0m \033[1mhelp\033[0m: check for unbounded recursion or missing base case in function calls\n\n"
str_rust_illegal_err:
    .asciz "\n\033[1;31merror[E0506]\033[0m: \033[1mruntime exception: illegal instruction\033[0m\n  \033[1;34m-->\033[0m \033[1;37m%s\033[0m\n   \033[1;34m|\033[0m\n   \033[1;34m=\033[0m \033[1mnote\033[0m: CPU encountered an invalid bytecode or instruction (RIP=%p)\n\n"
str_unresolved_call_err:
    .asciz "\n\033[1;31merror[E0502]\033[0m: \033[1mruntime exception: unresolved method or function call\033[0m\n  \033[1;34m-->\033[0m \033[1;37m%s\033[0m\n   \033[1;34m|\033[0m\n   \033[1;34m=\033[0m \033[1mnote\033[0m: attempted to call an undefined function or null method pointer\n   \033[1;34m=\033[0m \033[1mhelp\033[0m: verify method spelling or ensure the target object supports this method\n\n"
str_default_src:
    .asciz "<script.nx>"
arena_base: .quad 0
arena_bump: .quad 0
arena_limit: .quad 0
gc_alloc_counter: .quad 0
arena_live_count: .quad 0
region_arena_base: .quad 0
region_arena_bump: .quad 0
region_arena_limit: .quad 0
region_scope_depth: .quad 0
global_generation: .quad 1
region_scope_stack: .skip 2048
str_uaf_err:
    .asciz "\n\033[1;31merror[E0505]\033[0m: \033[1mruntime exception: use-after-free detected (generational reference expired or scope reclaimed)\033[0m\n  \033[1;34m-->\033[0m \033[1;37m%s\033[0m\n   \033[1;34m|\033[0m\n   \033[1;34m=\033[0m \033[1mnote\033[0m: accessed an object after its enclosing scope or generational lifetime ended\n   \033[1;34m=\033[0m \033[1mhelp\033[0m: ensure object references do not outlive their owning scope or arena\n\n"
last_optimized_dynamic_buf: .quad 0
active_dynamic_buf: .quad 0
active_dynamic_end: .quad 0
asm_mem_buf: .quad 0
asm_mem_ptr: .quad 0
file_size_bytes: .quad 0
fmt_addrs: .asciz "DEBUG: op_load_raw = %p, op_print = %p\n"
fmt_parse: .asciz "DEBUG: Parsed token: %s\n"
msg_load_raw: .asciz "DEBUG: executing op_load_raw\n"
init_msg: .asciz "[Nexus Baremetal] Booting Lightning Direct-Threaded VM...\n"
token_fmt: .asciz "%s\n"
time_msg: .asciz "[Nexus Baremetal] VM execution complete.\n"
debug_fmt: .asciz "[Nexus Baremetal] Register output: %f\n"
char_fmt: .asciz "%c"
str_fmt: .asciz "%s\n"
str_enum_unit_fmt: .asciz "<Enum tag=%lld>\n"
str_enum_payload_fmt: .asciz "<Enum tag=%lld, val="
str_enum_str_val_fmt: .asciz "\"%s\">\n"
str_enum_float_val_fmt: .asciz "%g>\n"
str_fmt2: .asciz "strcmp(%p, %p) stack=%p\n"
str_fmt3: .asciz "Values: [%p] vs [%p]\n"
bad_token_fmt: .asciz "BAD_TOKEN: %s\n"
str_bad_tok_hex: .asciz "BAD_TOKEN HEX: %02x %02x %02x %02x\n"
str_bracket_open: .asciz "["
str_bracket_close: .asciz "]\n"
str_bracket_close_no_nl: .asciz "]"
str_brace_open: .asciz "{"
str_brace_close: .asciz "}\n"
str_brace_close_no_nl: .asciz "}"
str_comma_space: .asciz ", "
str_dict_key_fmt: .asciz "\"%s\": "
str_quoted_fmt: .asciz "\"%s\""
str_int_fmt: .asciz "%lld"
str_float_clean_fmt: .asciz "%g"
str_null_val: .asciz "null"
str_int_top_fmt: .asciz "%lld\n"
str_float_top_fmt: .asciz "%g\n"
str_bool_true: .asciz "true\n"
str_bool_false: .asciz "false\n"
str_bool_true_raw: .asciz "true"
str_bool_false_raw: .asciz "false"
str_var_i: .asciz "i"
str_var_N: .asciz "N"
str_var_arr: .asciz "arr"
str_var_total: .asciz "total"
str_var_Counter1: .asciz "Counter1"
str_var_Counter2: .asciz "Counter2"
str_fma_hit: .asciz "DEBUG: FMA HIT\n"
str_fma_fail: .asciz "DEBUG: FMA FAIL\n"


fmt_argc: .asciz "ARGC=%d\n"
fmt_loop_debug: .asciz "DEBUG: loop target=%lld, current=%lld, len=%lld\n"
fmt_words: .asciz "Loaded words: %lld\n"
str_load_f_null: .asciz "FATAL: op_load_f NULL base ptr in reg %lld at rsi=%p, offset=%lld\n"
str_store_f_null: .asciz "FATAL: op_store_f NULL base ptr in reg %lld at rsi=%p, offset=%lld\n"
fmt_exec_dynamic: .asciz "DEBUG: op_exec_dynamic buf=%p\n"
str_dict_set_bad: .asciz "FATAL: op_dict_set out of bounds: dict_reg=%lld key_reg=%lld val_reg=%lld at rsi=%p\n"
str_dump_fmt: .asciz "DUMP around rsi-24: [-40]=%p [-32]=%p [-24]=%p [-16]=%p [-8]=%p [0]=%p [8]=%p\n"

vm_debug: .long 0
cli_source_file: .quad 0
target_asm_file: .quad 0
default_compiler: .asciz "src/compiler/compiler_full.nxasm"

file_name: .asciz "tests/vm/boot.nxasm"
read_mode: .asciz "r"
read_bin_mode: .asciz "rb"
write_mode: .asciz "w"
write_bin_mode: .asciz "wb"
scan_fmt: .asciz "%s"
str_hex_fmt: .asciz ""
err_msg: .asciz "Failed to open input file: %s\n"
str_stack_overflow: .asciz "[Nexus Baremetal Error] Call stack overflow (maximum recursion depth exceeded)\n"
str_val_stack_overflow: .asciz "[Nexus Baremetal Error] Value stack overflow (depth limit exceeded)\n"
str_ptr_stack_overflow: .asciz "[Nexus Baremetal Error] Pointer stack overflow (depth limit exceeded)\n"
str_try_stack_overflow: .asciz "[Nexus Baremetal Error] Try stack overflow (depth limit exceeded)\n"
str_defer_stack_overflow: .asciz "[Nexus Baremetal Error] Defer stack overflow (depth limit exceeded)\n"
str_SYS_GC: .asciz "SYS_GC"

str_FREAD: .asciz "FREAD"
str_FWRITE: .asciz "FWRITE"
str_FCLOSE: .asciz "FCLOSE"
str_FILE_READ_TEXT: .asciz "FILE_READ_TEXT"
str_FILE_WRITE_TEXT: .asciz "FILE_WRITE_TEXT"
str_INPUT: .asciz "INPUT"
str_STR_CAT: .asciz "STR_CAT"
str_SQRT: .asciz "SQRT"
str_SIN: .asciz "SIN"
str_COS: .asciz "COS"
str_POW: .asciz "POW"
str_ABS: .asciz "ABS"
str_EXIT: .asciz "EXIT"
str_MOD: .asciz "MOD"
str_FLOOR: .asciz "FLOOR"
str_CEIL: .asciz "CEIL"
str_STR_LEN: .asciz "STR_LEN"
str_TO_STR: .asciz "TO_STR"
str_SET_LEN: .asciz "SET_LEN"
str_ARRAY_PUSH: .asciz "ARRAY_PUSH"
str_ARRAY_POP: .asciz "ARRAY_POP"
str_STR_SUB: .asciz "STR_SUB"
str_ARRAY_SLICE: .asciz "ARRAY_SLICE"
str_STR_CONTAINS: .asciz "STR_CONTAINS"
str_STR_INDEX_OF: .asciz "STR_INDEX_OF"
str_STR_SPLIT: .asciz "STR_SPLIT"
str_STR_TO_UPPER: .asciz "STR_TO_UPPER"
str_STR_TO_LOWER: .asciz "STR_TO_LOWER"
str_DICT_HAS_KEY: .asciz "DICT_HAS_KEY"
str_DICT_KEYS: .asciz "DICT_KEYS"
str_DICT_VALUES: .asciz "DICT_VALUES"
str_PUSH_TRY: .asciz "PUSH_TRY"
str_POP_TRY: .asciz "POP_TRY"
str_THROW: .asciz "THROW"
str_PUSH_DEFER: .asciz "PUSH_DEFER"
str_POP_RUN_DEFERS: .asciz "POP_RUN_DEFERS"
str_SHA256: .asciz "SHA256"
str_MD5: .asciz "MD5"
str_BASE64_ENCODE: .asciz "BASE64_ENCODE"
str_BASE64_DECODE: .asciz "BASE64_DECODE"
str_HEX_ENCODE: .asciz "HEX_ENCODE"
str_HEX_DECODE: .asciz "HEX_DECODE"
str_XOR_MASK: .asciz "XOR_MASK"
str_SYS_ARGS: .asciz "SYS_ARGS"
str_SYS_TIME_MS: .asciz "SYS_TIME_MS"
str_SYS_GET_ENV: .asciz "SYS_GET_ENV"
str_SYS_SET_ENV: .asciz "SYS_SET_ENV"
str_SYS_EXEC: .asciz "SYS_EXEC"
str_AES_ENCRYPT: .asciz "AES_ENCRYPT"
str_AES_DECRYPT: .asciz "AES_DECRYPT"
str_HMAC_SHA256: .asciz "HMAC_SHA256"
str_RANDOM_BYTES: .asciz "RANDOM_BYTES"
str_TCP_CONNECT:  .asciz "TCP_CONNECT"
str_TCP_SEND:     .asciz "TCP_SEND"
str_TCP_RECV:     .asciz "TCP_RECV"
str_TCP_CLOSE:    .asciz "TCP_CLOSE"
str_TCP_LISTEN:   .asciz "TCP_LISTEN"
str_TCP_ACCEPT:   .asciz "TCP_ACCEPT"
str_HTTP_GET:     .asciz "HTTP_GET"
str_INDEX_GET:    .asciz "INDEX_GET"
str_INDEX_SET:    .asciz "INDEX_SET"
str_GPU_DISPATCH: .asciz "GPU_DISPATCH"
http_req_fmt:     .asciz "GET %s HTTP/1.1\r\nHost: %s\r\nConnection: close\r\nUser-Agent: Nexus/1.0\r\n\r\n"
http_default_path:.asciz "/"
empty_str: .asciz ""
str_dbg_net: .asciz "[NET DEBUG] %s val1=%lld val2=%lld\n"

.align 16
wsa_data_buf:    .space 512
wsa_initialized: .quad 0
hex_chars_lower:
    .ascii "0123456789abcdef"
    .byte 0

.align 16
b64_table:
    .ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    .byte 0

.align 16
sha256_k:
    .long 0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5
    .long 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5
    .long 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3
    .long 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174
    .long 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc
    .long 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da
    .long 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7
    .long 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967
    .long 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13
    .long 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85
    .long 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3
    .long 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070
    .long 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5
    .long 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3
    .long 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208
    .long 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2

.align 16
md5_k:
    .long 0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee
    .long 0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501
    .long 0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be
    .long 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821
    .long 0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa
    .long 0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8
    .long 0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed
    .long 0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a
    .long 0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c
    .long 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70
    .long 0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05
    .long 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665
    .long 0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039
    .long 0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1
    .long 0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1
    .long 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391

.align 16
md5_s:
    .long 7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22
    .long 5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20
    .long 4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23
    .long 6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21
str_uncaught_exc: .asciz "\n[Nexus Baremetal Exception] Uncaught exception: "
str_exc_newline: .asciz "\n"
throw_defer_resume_op: .quad op_throw_defer_resume
str_to_str_fmt: .asciz "%g"
str_PANIC: .asciz "PANIC"
panic_msg: .asciz "VM PANIC!\n"
stack_trace_msg: .asciz "Stack trace:\n  <main>\n"
str_LOAD: .asciz "LOAD"
str_ADD: .asciz "ADD"
str_PRINT: .asciz "PRINT"
str_HALT: .asciz "HALT"
str_ENUM_TAG: .asciz "ENUM_TAG"
str_ENUM_GET_TAG: .asciz "ENUM_GET_TAG"
str_ENUM_GET_FIELD: .asciz "ENUM_GET_FIELD"
str_REGION_ENTER: .asciz "REGION_ENTER"
str_REGION_LEAVE: .asciz "REGION_LEAVE"
str_GEN_CHECK: .asciz "GEN_CHECK"
str_REGION_ALLOC: .asciz "REGION_ALLOC"
str_FIBER_SPAWN: .asciz "FIBER_SPAWN"
str_FIBER_YIELD: .asciz "FIBER_YIELD"
str_FIBER_AWAIT: .asciz "FIBER_AWAIT"
str_IOCP_INIT: .asciz "IOCP_INIT"
str_IOCP_POLL: .asciz "IOCP_POLL"
str_ASYNC_LISTEN: .asciz "ASYNC_LISTEN"
str_ASYNC_ACCEPT: .asciz "ASYNC_ACCEPT"
str_ASYNC_RECV: .asciz "ASYNC_RECV"
str_ASYNC_SEND: .asciz "ASYNC_SEND"
str_CHAN_NEW: .asciz "CHAN_NEW"
str_CHAN_SEND: .asciz "CHAN_SEND"
str_CHAN_RECV: .asciz "CHAN_RECV"
str_CHAN_LEN: .asciz "CHAN_LEN"
str_CHAN_CLOSE: .asciz "CHAN_CLOSE"
str_LT: .asciz "LT"
str_LABEL: .asciz "LABEL"
str_JMP: .asciz "JMP"
str_JMP_F: .asciz "JMP_F"
str_LOAD_STR: .asciz "LOAD_STR"
str_FOPEN: .asciz "FOPEN"
str_FOPEN_W: .asciz "FOPEN_W"
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
str_AND: .asciz "AND"
str_OR: .asciz "OR"
str_STORE_PTR: .asciz "STORE_PTR"
str_LOAD_PTR: .asciz "LOAD_PTR"
str_PUTS: .asciz "PUTS"
str_ALLOC: .asciz "ALLOC"
str_DICT_NEW: .asciz "DICT_NEW"
str_DICT_SET: .asciz "DICT_SET"
str_DICT_GET: .asciz "DICT_GET"
str_DICT_COPY: .asciz "DICT_COPY"
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
labels_array: .space 4194304
call_stack: .space 4194304


call_sp: .space 8
val_stack: .space 4194304
val_sp: .space 8

ptr_stack: .space 4194304
ptr_sp: .space 8
alloc_head: .space 8
gc_count: .space 8
gc_threshold: .space 8

argc_store: .space 8
argv_store: .space 8

.align 16
vm_bytecode_base: .space 8
fiber_count: .space 8
current_fiber_id: .space 8
scheduler_initialized: .space 8
ready_head: .space 8
ready_tail: .space 8
ready_count: .space 8
main_fcb: .space 128
fiber_table: .space 65536
fiber_ready_queue: .space 65536

.align 8
iocp_global_handle: .space 8
iocp_bytes_transferred: .space 8
iocp_completion_key: .space 8
iocp_overlapped: .space 8
sock_nonblocking_mode: .space 8

try_stack_rsi: .space 8192
try_stack_call_sp: .space 8192
try_stack_val_sp: .space 8192
try_sp: .space 8

defer_stack_rsi: .space 8192
defer_stack_call_sp: .space 8192
defer_sp: .space 8
defer_active: .space 8

saved_ret_f: .space 8
saved_ret_p: .space 8

thrown_val: .space 8
throw_target_call_sp: .space 8
throw_target_val_sp: .space 8
throw_target_catch_rsi: .space 8
ic_table: .space 32768
perf_freq: .space 8

.section .text

# ---------------------------------------------------------
# DIRECT THREADED VIRTUAL MACHINE
# ---------------------------------------------------------
.data
.align 8
to_str_return_stub:
    .quad op_to_str_return_handler
in_exec: .long 0
vm_stack_base: .quad 0
parse_done_msg: .asciz "Parse Done!\n"
next_fmt: .asciz "Executing: %p\n"

.text
.macro NEXT
    mov rax, [rsi]
    add rsi, 8
    jmp rax
.endm

# --- Opcode Handlers ---
op_load_const:
    movsd xmm0, [rsi]
    mov rcx, [rsi+8]
    add rsi, 16
    movsd [rdi + rcx * 8], xmm0
    NEXT

# op_load_raw: stores a raw 64-bit value (pointer/integer) without float conversion
# Bytecode: [handler_ptr][raw_64bit_value][dest_reg]
op_load_raw:
    mov rax, [rsi]
    mov rcx, [rsi+8]
    add rsi, 16
    mov [rdi + rcx * 8], rax
    mov [rbx + rcx * 8], rax
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
    movzx eax, al
    neg rax
    mov r10, 0x3FF0000000000000
    and rax, r10
    mov [rdi + rcx * 8], rax
    NEXT

op_jmp:
    mov rcx, [rsi]
    cmp rcx, 524280
    jae .bad_jmp
    lea r8, [rip + labels_array]
    mov rsi, [r8 + rcx * 8]
    NEXT
.bad_jmp:
    add rsi, 8
    NEXT

op_jmp_f:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16
    mov rax, [rdi + rcx * 8]
    test rax, rax
    jz .do_jmp_f
    mov r11, 0x7FF8000000000000
    cmp rax, r11
    je .do_jmp_f
    add rax, rax
    jnz .no_jump
.do_jmp_f:
    cmp r8, 524280
    jae .no_jump
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

    # Read from pointer bank first, then float bank
    mov rdx, [rbx + rcx * 8]
    test rdx, rdx
    jnz 1f
    mov rdx, [rdi + rcx * 8]
1:
    mov rax, rdx
    test rax, rax
    jz .print_float_zero

    mov r8, 0x7FF8000000000001
    cmp rax, r8
    je .print_top_true
    mov r8, 0x7FF8000000000000
    cmp rax, r8
    je .print_top_false

    mov r8, 0x7FF0000000000000
    test rax, r8
    jnz .print_float
    cmp rax, 0x10000
    jb .print_float
    mov r8, 0x00007FFFFFFFFFFF
    cmp rax, r8
    ja .print_float

    # rax is a valid pointer!
    mov r10, [rip + arena_base]
    cmp rax, r10
    jb .print_check_page
    cmp rax, [rip + arena_limit]
    jb .print_safe_gc

.print_check_page:
    mov r10, rax
    and r10, 0xFFF
    cmp r10, 32
    jb .print_top_string

.print_safe_gc:
    # Safe to read [rax - 32]:
    mov r10, 0x4152524159        # "ARRAY"
    cmp [rax - 32], r10
    je .print_top_array

    cmp qword ptr [rax - 32], 1  # type tag 1 (Dictionary)
    je .print_top_dict
    mov r10, 0x44494354          # "DICT"
    cmp [rax - 32], r10
    je .print_top_dict

    cmp qword ptr [rax - 32], 0xAA01
    je .print_top_enum

.print_top_string:
    lea rcx, [rip + str_fmt]
    mov rdx, rax
    call printf
    jmp .print_done

.print_top_array:
    push r12
    push r13
    push r14
    push r15
    sub rsp, 48
    mov r12, rax
    movsd xmm0, [r12 - 16]
    cvttsd2si r14, xmm0
    lea rcx, [rip + str_bracket_open]
    call printf
    test r14, r14
    jle .top_arr_end
    xor r13, r13
.top_arr_loop:
    cmp r13, r14
    jge .top_arr_end
    test r13, r13
    jz 2f
    lea rcx, [rip + str_comma_space]
    call printf
2:
    mov rdx, [r12 + r13 * 8]
    call print_nested_elem
    inc r13
    jmp .top_arr_loop
.top_arr_end:
    lea rcx, [rip + str_bracket_close]
    call printf
    add rsp, 48
    pop r15
    pop r14
    pop r13
    pop r12
    jmp .print_done

.print_top_dict:
    # First search for "to_str"
    mov r12, [rax + 8]
.search_to_str_loop:
    test r12, r12
    jz .search_print_loop_init
    mov rdx, [r12]
    test rdx, rdx
    jz .search_to_str_next
    
    cmp byte ptr [rdx], 't'
    jne .search_to_str_next
    cmp byte ptr [rdx+1], 'o'
    jne .search_to_str_next
    cmp byte ptr [rdx+2], '_'
    jne .search_to_str_next
    cmp byte ptr [rdx+3], 's'
    jne .search_to_str_next
    cmp byte ptr [rdx+4], 't'
    jne .search_to_str_next
    cmp byte ptr [rdx+5], 'r'
    jne .search_to_str_next
    cmp byte ptr [rdx+6], 0
    jne .search_to_str_next
    
    # "to_str" found!
    mov r13, [r12 + 8]
    mov r8, 0x7FF0000000000000
    test r13, r8
    jnz .call_to_str_fn
    cmp r13, 0x10000
    jb .call_to_str_fn
    mov r8, 0x00007FFFFFFFFFFF
    cmp r13, r8
    ja .call_to_str_fn
    
    # String field: print directly!
    lea rcx, [rip + str_fmt]
    mov rdx, r13
    call printf
    jmp .print_done

.search_to_str_next:
    mov r12, [r12 + 16]
    jmp .search_to_str_loop

.call_to_str_fn:
    movq xmm0, r13
    cvttsd2si r14, xmm0
    mov r9, [rip + active_dynamic_buf]
    test r9, r9
    jnz 1f
    mov r9, [rbx + 70 * 8]
    test r9, r9
    jnz 1f
    mov r9, [rdi + 70 * 8]
1:
    test r9, r9
    jz .normal_print_top_dict
    
    # Unwind op_print frame
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    
    lea r10, [rip + call_sp]
    mov r11, [r10]
    cmp r11, 65525
    jae .print_done
    lea r12, [rip + call_stack]
    mov [r12 + r11 * 8], rsi
    inc r11
    lea r8, [rip + to_str_return_stub]
    mov [r12 + r11 * 8], r8
    inc r11
    mov [r10], r11
    
    lea rsi, [r9 + r14]
    NEXT

.search_print_loop_init:
    # Filter out System class (System has "exit")
    mov r12, [rax + 8]
.check_system_loop:
    test r12, r12
    jz .search_print_loop
    mov rdx, [r12]
    test rdx, rdx
    jz .check_system_next
    cmp byte ptr [rdx], 'e'
    jne .check_system_next
    cmp byte ptr [rdx+1], 'x'
    jne .check_system_next
    cmp byte ptr [rdx+2], 'i'
    jne .check_system_next
    cmp byte ptr [rdx+3], 't'
    jne .check_system_next
    cmp byte ptr [rdx+4], 0
    je .normal_print_top_dict
.check_system_next:
    mov r12, [r12 + 16]
    jmp .check_system_loop

.search_print_loop:
    mov r12, [rax + 8]
.search_print_inner:
    test r12, r12
    jz .normal_print_top_dict
    mov rdx, [r12]
    test rdx, rdx
    jz .search_print_next
    
    cmp byte ptr [rdx], 'p'
    jne .search_print_next
    cmp byte ptr [rdx+1], 'r'
    jne .search_print_next
    cmp byte ptr [rdx+2], 'i'
    jne .search_print_next
    cmp byte ptr [rdx+3], 'n'
    jne .search_print_next
    cmp byte ptr [rdx+4], 't'
    jne .search_print_next
    cmp byte ptr [rdx+5], 0
    jne .search_print_next
    
    # "print" found on user class!
    mov r13, [r12 + 8]
    movq xmm0, r13
    cvttsd2si r14, xmm0
    mov r9, [rip + active_dynamic_buf]
    test r9, r9
    jnz 2f
    mov r9, [rbx + 70 * 8]
    test r9, r9
    jnz 2f
    mov r9, [rdi + 70 * 8]
2:
    test r9, r9
    jz .normal_print_top_dict
    
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    
    lea r10, [rip + call_sp]
    mov r11, [r10]
    cmp r11, 65530
    jae .print_done
    lea r12, [rip + call_stack]
    mov [r12 + r11 * 8], rsi
    inc r11
    mov [r10], r11
    
    lea rsi, [r9 + r14]
    NEXT

.search_print_next:
    mov r12, [r12 + 16]
    jmp .search_print_inner

.normal_print_top_dict:
    push r12
    push r13
    push r14
    push r15
    sub rsp, 48
    mov r12, [rax + 8]
    lea rcx, [rip + str_brace_open]
    call printf
    xor r15, r15
.top_dict_loop:
    test r12, r12
    jz .top_dict_end
    test r15, r15
    jz 3f
    lea rcx, [rip + str_comma_space]
    call printf
3:
    lea rcx, [rip + str_dict_key_fmt]
    mov rdx, [r12]
    call printf
    mov rdx, [r12 + 8]
    call print_nested_elem
    inc r15
    mov r12, [r12 + 16]
    jmp .top_dict_loop
.top_dict_end:
    lea rcx, [rip + str_brace_close]
    call printf
    add rsp, 48
    pop r15
    pop r14
    pop r13
    pop r12
    jmp .print_done

.print_top_true:
    lea rcx, [rip + str_bool_true]
    call printf
    jmp .print_done

.print_top_false:
    lea rcx, [rip + str_bool_false]
    call printf
    jmp .print_done

.print_float_zero:
    xor rdx, rdx
    lea rcx, [rip + str_int_top_fmt]
    call printf
    jmp .print_done

.print_float:
    movq xmm0, rdx
    cvttsd2si rdx, xmm0
    cvtsi2sd xmm1, rdx
    ucomisd xmm0, xmm1
    jne .print_real_float
    jp .print_real_float
    lea rcx, [rip + str_int_top_fmt]
    call printf
    jmp .print_done

.print_real_float:
    lea rcx, [rip + str_float_top_fmt]
    movaps xmm1, xmm0
    movq rdx, xmm0
    call printf
    jmp .print_done

.print_top_enum:
    push r12
    push r13
    sub rsp, 32
    mov r12, rax
    cmp qword ptr [r12 + 16], 0
    jle .pte_unit
    lea rcx, [rip + str_enum_payload_fmt]
    mov rdx, [r12]
    call printf
    mov rax, [r12 + 24]
    mov r10, 0x7FF0000000000000
    test rax, r10
    jnz .pte_payload_float
    cmp rax, 0x10000
    jb .pte_payload_float
    mov r10, 0x00007FFFFFFFFFFF
    cmp rax, r10
    ja .pte_payload_float
    lea rcx, [rip + str_enum_str_val_fmt]
    mov rdx, rax
    call printf
    jmp .pte_done
.pte_payload_float:
    movq xmm0, rax
    lea rcx, [rip + str_enum_float_val_fmt]
    movaps xmm1, xmm0
    movq rdx, xmm0
    call printf
    jmp .pte_done
.pte_unit:
    lea rcx, [rip + str_enum_unit_fmt]
    mov rdx, [r12]
    call printf
.pte_done:
    add rsp, 32
    pop r13
    pop r12
    jmp .print_done

.print_done:
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    NEXT

op_to_str_return_handler:
    push rsi
    push rdi
    push rbx
    sub rsp, 40

    # Read return value from r0
    mov rdx, [rbx + 0]
    test rdx, rdx
    jnz 1f
    mov rdx, [rdi + 0]
1:
    test rdx, rdx
    jz .to_str_ret_done

    # Check if rdx is a number
    mov r8, 0x7FF0000000000000
    test rdx, r8
    jnz .to_str_ret_float
    cmp rdx, 0x10000
    jb .to_str_ret_float
    mov r8, 0x00007FFFFFFFFFFF
    cmp rdx, r8
    ja .to_str_ret_float

    # String pointer: print string!
    lea rcx, [rip + str_fmt]
    call printf
    jmp .to_str_ret_done

.to_str_ret_float:
    movq xmm0, rdx
    cvttsd2si rdx, xmm0
    lea rcx, [rip + str_int_top_fmt]
    call printf

.to_str_ret_done:
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    lea r10, [rip + call_sp]
    mov r11, [r10]
    dec r11
    mov [r10], r11
    lea r12, [rip + call_stack]
    mov rsi, [r12 + r11 * 8]
    NEXT


print_nested_elem:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 40

    mov rax, rdx
    test rax, rax
    jz .ne_zero

    mov r8, 0x7FF8000000000001
    cmp rax, r8
    je .ne_true
    mov r8, 0x7FF8000000000000
    cmp rax, r8
    je .ne_false

    mov r8, 0x7FF0000000000000
    test rax, r8
    jnz .ne_number
    cmp rax, 0x10000
    jb .ne_number
    mov r8, 0x00007FFFFFFFFFFF
    cmp rax, r8
    ja .ne_number

    # It is a pointer!
    mov r10, [rip + arena_base]
    cmp rax, r10
    jb .ne_check_page
    cmp rax, [rip + arena_limit]
    jb .ne_safe_gc

.ne_check_page:
    mov r10, rax
    and r10, 0xFFF
    cmp r10, 32
    jb .ne_string

.ne_safe_gc:
    mov r10, 0x4152524159
    cmp [rax - 32], r10
    je .ne_array

    cmp qword ptr [rax - 32], 1
    je .ne_dict
    mov r10, 0x44494354
    cmp [rax - 32], r10
    je .ne_dict

.ne_string:
    lea rcx, [rip + str_quoted_fmt]
    mov rdx, rax
    call printf
    jmp .ne_done

.ne_true:
    lea rcx, [rip + str_bool_true_raw]
    call printf
    jmp .ne_done

.ne_false:
    lea rcx, [rip + str_bool_false_raw]
    call printf
    jmp .ne_done

.ne_zero:
    xor rdx, rdx
    lea rcx, [rip + str_int_fmt]
    call printf
    jmp .ne_done

.ne_null:
    lea rcx, [rip + str_null_val]
    call printf
    jmp .ne_done

.ne_array:
    mov r12, rax
    movsd xmm0, [r12 - 16]
    cvttsd2si r14, xmm0
    lea rcx, [rip + str_bracket_open]
    call printf
    test r14, r14
    jle .ne_arr_end
    xor r13, r13
.ne_arr_loop:
    cmp r13, r14
    jge .ne_arr_end
    test r13, r13
    jz 4f
    lea rcx, [rip + str_comma_space]
    call printf
4:
    mov rdx, [r12 + r13 * 8]
    call print_nested_elem
    inc r13
    jmp .ne_arr_loop
.ne_arr_end:
    lea rcx, [rip + str_bracket_close_no_nl]
    call printf
    jmp .ne_done

.ne_dict:
    mov r12, [rax + 8]
    lea rcx, [rip + str_brace_open]
    call printf
    xor r15, r15
.ne_dict_loop:
    test r12, r12
    jz .ne_dict_end
    test r15, r15
    jz 5f
    lea rcx, [rip + str_comma_space]
    call printf
5:
    lea rcx, [rip + str_dict_key_fmt]
    mov rdx, [r12]
    call printf
    mov rdx, [r12 + 8]
    call print_nested_elem
    inc r15
    mov r12, [r12 + 16]
    jmp .ne_dict_loop
.ne_dict_end:
    lea rcx, [rip + str_brace_close_no_nl]
    call printf
    jmp .ne_done

.ne_number:
    movq xmm0, rax
    cvttsd2si rdx, xmm0
    cvtsi2sd xmm1, rdx
    ucomisd xmm0, xmm1
    jne .ne_real_float
    jp .ne_real_float
    lea rcx, [rip + str_int_fmt]
    call printf
    jmp .ne_done

.ne_real_float:
    lea rcx, [rip + str_float_clean_fmt]
    movaps xmm1, xmm0
    movq rdx, xmm0
    call printf

.ne_done:
    add rsp, 40
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

op_eq:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    mov rdx, [rbx + r9 * 8]
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r9 * 8]
2:
    mov r10, 0x7FF0000000000000
    test rax, r10
    jnz .eq_float
    cmp rax, 0x10000
    jb .eq_float
    mov r10, 0x00007FFFFFFFFFFF
    cmp rax, r10
    ja .eq_float
    mov r10, 0x7FF0000000000000
    test rdx, r10
    jnz .eq_float
    cmp rdx, 0x10000
    jb .eq_float
    mov r10, 0x00007FFFFFFFFFFF
    cmp rdx, r10
    ja .eq_float
    cmp rax, rdx
    je .eq_match

    # Check if both are GC objects in arena:
    mov r10, [rip + arena_base]
    cmp rax, r10
    jb .eq_do_strcmp
    cmp rax, [rip + arena_limit]
    jae .eq_do_strcmp
    cmp rdx, r10
    jb .eq_do_strcmp
    cmp rdx, [rip + arena_limit]
    jae .eq_do_strcmp

    # Both within arena! Check if either is enum (0xAA01):
    cmp qword ptr [rax - 32], 0xAA01
    jne .eq_do_strcmp
    cmp qword ptr [rdx - 32], 0xAA01
    jne .eq_mismatch

    # Both are enums! Compare tag:
    mov r10, [rax]
    cmp r10, [rdx]
    jne .eq_mismatch
    # Tag matches! Check field_count:
    mov r11, [rax + 16]
    cmp r11, [rdx + 16]
    jne .eq_mismatch
    test r11, r11
    jz .eq_match
    # Compare payloads:
    mov r10, [rax + 24]
    cmp r10, [rdx + 24]
    je .eq_match
    jmp .eq_mismatch

.eq_match:
    mov eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

.eq_mismatch:
    xor eax, eax
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

.eq_do_strcmp:
    push rsi
    push rdi
    push rbx
    push rcx
    sub rsp, 32
    mov rcx, rax
    call strcmp
    add rsp, 32
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    test eax, eax
    sete al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT
.eq_float:
    cmp rax, rdx
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
    mov rcx, 144
    mov rdx, 1
    call gc_malloc
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    # Zero all 144 bytes
    mov qword ptr [rax], 0
    mov qword ptr [rax+8], 0
    mov qword ptr [rax+16], 0
    mov qword ptr [rax+24], 0
    mov qword ptr [rax+32], 0
    mov qword ptr [rax+40], 0
    mov qword ptr [rax+48], 0
    mov qword ptr [rax+56], 0
    mov qword ptr [rax+64], 0
    mov qword ptr [rax+72], 0
    mov qword ptr [rax+80], 0
    mov qword ptr [rax+88], 0
    mov qword ptr [rax+96], 0
    mov qword ptr [rax+104], 0
    mov qword ptr [rax+112], 0
    mov qword ptr [rax+120], 0
    mov qword ptr [rax+128], 0
    mov qword ptr [rax+136], 0
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax

    cmp r12, 250
    jne .dict_new_done

    # Register "false" and "true" into dict 250
    push rsi
    push rdi
    push rbx
    push rax                    # save dict ptr
    sub rsp, 40

    # Allocate node for "false"
    mov rcx, 24
    mov rdx, 2
    call gc_malloc
    mov r10, rax                # r10 = false_node
    lea r11, [rip + str_bool_false_raw]
    mov [r10], r11              # key = "false"
    mov r11, 0x7FF8000000000000
    mov [r10 + 8], r11          # val = false
    mov qword ptr [r10 + 16], 0 # next = NULL

    # Allocate node for "true"
    mov [rsp + 32], r10         # save false_node
    mov rcx, 24
    mov rdx, 2
    call gc_malloc
    mov r10, [rsp + 32]         # restore false_node
    mov r11, rax                # r11 = true_node
    lea rcx, [rip + str_bool_true_raw]
    mov [r11], rcx              # key = "true"
    mov rdx, 0x7FF8000000000001
    mov [r11 + 8], rdx          # val = true
    mov [r11 + 16], r10         # next = false_node

    add rsp, 40
    pop rax                     # restore dict ptr
    pop rbx
    pop rdi
    pop rsi

    # Link into dict: [dict + 8] = true_node
    mov [rax + 8], r11

.dict_new_done:
    NEXT

op_dict_set:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    cmp r12, 8192
    jae .bad_dict_set
    cmp r8, 8192
    jae .bad_dict_set
    cmp r9, 8192
    jae .bad_dict_set
    jmp .dict_set_regs_ok
.bad_dict_set:
    sub rsp, 64
    lea rcx, [rip + str_dict_set_bad]
    mov rdx, r12
    mov [rsp + 32], rsi
    call printf
    mov rcx, 0
    call fflush
    mov rcx, 1
    call exit
.dict_set_regs_ok:
    mov r10, [rdi + r12 * 8]
    mov r11, [rdi + r8 * 8]     # READ KEY FROM FLOAT BANK!
    mov r14, [rdi + r9 * 8]     # r14 holds the 64-bit value safely
    test r10, r10
    jz .dict_set_done
    cmp r10, 0x10000
    jb .dict_set_done
    test r11, r11
    jz .dict_set_done
    cmp r11, 0x10000
    jb .dict_set_done
    
    # 0. Call-site inline cache lookup
    mov rax, rsi
    shr rax, 3
    and eax, 1023
    shl rax, 5
    lea rdx, [rip + ic_table]
    add rdx, rax
    cmp [rdx], rsi
    jne .ic_miss_set
    cmp [rdx + 8], r10
    jne .ic_miss_set
    cmp [rdx + 16], r11
    jne .ic_miss_set
    mov r13, [rdx + 24]
    mov [r13+8], r14
    NEXT

.ic_miss_set:
    # 8-slot direct-mapped cache lookup
    mov rax, r11
    shr rax, 3
    and eax, 7
    shl rax, 4
    cmp r11, [r10 + 16 + rax]
    jne .dict_set_loop_start
    mov r13, [r10 + 24 + rax]
    test r13, r13
    jz .dict_set_loop_start
    mov [r13+8], r14

    # Update call-site inline cache slot
    mov rax, rsi
    shr rax, 3
    and eax, 1023
    shl rax, 5
    lea rdx, [rip + ic_table]
    add rdx, rax
    mov [rdx], rsi
    mov [rdx + 8], r10
    mov [rdx + 16], r11
    mov [rdx + 24], r13
    NEXT

.dict_set_done:
    NEXT

.dict_set_loop_start:
    mov r13, [r10+8]
.dict_set_loop:
    test r13, r13
    jz .dict_set_not_found
    
    mov rdx, [r13]
    test rdx, rdx
    jz .dict_set_next
    cmp r11, rdx                # FAST PATH: Pointer Equality
    je .dict_set_found

    mov rax, 0x7FF0000000000000
    test r11, rax
    jnz .dict_set_next
    test rdx, rax
    jnz .dict_set_next
    cmp r11, 0x10000
    jb .dict_set_next
    cmp rdx, 0x10000
    jb .dict_set_next
    mov rax, 0x00007FFFFFFFFFFF
    cmp r11, rax
    ja .dict_set_next
    cmp rdx, rax
    ja .dict_set_next

    mov al, [r11]
    cmp al, [rdx]
    jne .dict_set_next
    
    mov rcx, r11
.strcmp_loop_set:
    mov al, [rcx]
    cmp al, [rdx]
    jne .dict_set_next
    test al, al
    jz .dict_set_found
    inc rcx
    inc rdx
    jmp .strcmp_loop_set
.dict_set_next:
    mov r13, [r13+16]
    jmp .dict_set_loop
.dict_set_found:
    mov [r13+8], r14            # Store safely without xmm
    mov rax, r11
    shr rax, 3
    and eax, 7
    shl rax, 4
    mov [r10 + 16 + rax], r11
    mov [r10 + 24 + rax], r13

    # Update call-site inline cache slot
    mov rax, rsi
    shr rax, 3
    and eax, 1023
    shl rax, 5
    lea rdx, [rip + ic_table]
    add rdx, rax
    mov [rdx], rsi
    mov [rdx + 8], r10
    mov [rdx + 16], r11
    mov [rdx + 24], r13
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
    mov r8, [r10+8]
    mov [rax+16], r8
    mov [r10+8], rax
    mov rdx, r11
    shr rdx, 3
    and edx, 7
    shl rdx, 4
    mov [r10 + 16 + rdx], r11
    mov [r10 + 24 + rdx], rax

    # Update call-site inline cache slot
    mov r8, rsi
    shr r8, 3
    and r8d, 1023
    shl r8, 5
    lea rdx, [rip + ic_table]
    add rdx, r8
    mov [rdx], rsi
    mov [rdx + 8], r10
    mov [rdx + 16], r11
    mov [rdx + 24], rax
    NEXT

op_dict_copy:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16
    
    mov r10, [rdi + r12 * 8]
    mov r11, [rdi + r8 * 8]
    test r10, r10
    jz .dict_copy_done
    test r11, r11
    jz .dict_copy_done
    
    mov r13, [r11 + 8]
.dict_copy_loop:
    test r13, r13
    jz .dict_copy_done
    
    push rsi
    push rdi
    push rbx
    push r10
    push r11
    push r13
    sub rsp, 32
    
    mov rcx, 24
    mov rdx, 2
    call gc_malloc
    
    add rsp, 32
    pop r13
    pop r11
    pop r10
    pop rbx
    pop rdi
    pop rsi
    
    mov rdx, [r13]
    mov [rax], rdx
    mov rdx, [r13 + 8]
    mov [rax + 8], rdx
    mov rdx, [r10 + 8]
    mov [rax + 16], rdx
    mov [r10 + 8], rax
    
    mov r13, [r13 + 16]
    jmp .dict_copy_loop

.dict_copy_done:
    NEXT

op_dict_get:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    cmp r12, 8192
    jae .dict_get_null
    cmp r8, 8192
    jae .dict_get_null
    cmp r9, 8192
    jae .dict_get_null
    mov r10, [rdi + r8 * 8]
    
    test r10, r10
    jz .dict_get_null
    cmp r10, 0x10000
    jb .dict_get_null
    mov r11, [rdi + r9 * 8]     # READ KEY FROM FLOAT BANK!
    test r11, r11
    jz .dict_get_not_found
    cmp r11, 0x10000
    jb .dict_get_not_found

    # 0. Call-site inline cache lookup
    mov rax, rsi
    shr rax, 3
    and eax, 1023
    shl rax, 5
    lea rdx, [rip + ic_table]
    add rdx, rax
    cmp [rdx], rsi
    jne .ic_miss_get
    cmp [rdx + 8], r10
    jne .ic_miss_get
    cmp [rdx + 16], r11
    jne .ic_miss_get
    mov r13, [rdx + 24]
    mov rax, [r13+8]
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax
    NEXT

.ic_miss_get:
    # 8-slot direct-mapped cache lookup
    mov rax, r11
    shr rax, 3
    and eax, 7
    shl rax, 4
    cmp r11, [r10 + 16 + rax]
    jne .dict_get_loop_start
    mov r13, [r10 + 24 + rax]
    test r13, r13
    jz .dict_get_loop_start
    mov rax, [r13+8]
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax

    # Update call-site inline cache slot
    mov rax, rsi
    shr rax, 3
    and eax, 1023
    shl rax, 5
    lea rdx, [rip + ic_table]
    add rdx, rax
    mov [rdx], rsi
    mov [rdx + 8], r10
    mov [rdx + 16], r11
    mov [rdx + 24], r13
    NEXT

.dict_get_loop_start:
    mov r13, [r10+8]
.dict_set_loop_get:
.dict_get_loop:
    test r13, r13
    jz .dict_get_not_found
    
    mov rdx, [r13]
    test rdx, rdx
    jz .dict_get_next
    cmp r11, rdx                # FAST PATH: Pointer Equality
    je .dict_get_found

    mov rax, 0x7FF0000000000000
    test r11, rax
    jnz .dict_get_next
    test rdx, rax
    jnz .dict_get_next
    cmp r11, 0x10000
    jb .dict_get_next
    cmp rdx, 0x10000
    jb .dict_get_next
    mov rax, 0x00007FFFFFFFFFFF
    cmp r11, rax
    ja .dict_get_next
    cmp rdx, rax
    ja .dict_get_next

    mov al, [r11]
    cmp al, [rdx]
    jne .dict_get_next
    
    mov rcx, r11
.strcmp_loop_get:
    mov al, [rcx]
    cmp al, [rdx]
    jne .dict_get_next
    test al, al
    jz .dict_get_found
    inc rcx
    inc rdx
    jmp .strcmp_loop_get
.dict_get_next:
    mov r13, [r13+16]
    jmp .dict_get_loop
.dict_get_found:
    mov rax, [r13+8]
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax
    mov rdx, r11
    shr rdx, 3
    and edx, 7
    shl rdx, 4
    mov [r10 + 16 + rdx], r11
    mov [r10 + 24 + rdx], r13

    # Update call-site inline cache slot
    mov rax, rsi
    shr rax, 3
    and eax, 1023
    shl rax, 5
    lea rdx, [rip + ic_table]
    add rdx, rax
    mov [rdx], rsi
    mov [rdx + 8], r10
    mov [rdx + 16], r11
    mov [rdx + 24], r13
    NEXT
.dict_get_not_found:
.dict_get_null:
    xor eax, eax
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax
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
    test rcx, rcx
    jg 1f
    mov rcx, 8
1:
    mov rdx, 0
    call gc_malloc
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

.globl gc_malloc
gc_malloc:
    # rcx = requested size, rdx = type tag
    test rcx, rcx
    jg 1f
    mov rcx, 8
1:
    # Total chunk needed = size + 48 header, aligned to 16 bytes
    lea r8, [rcx + 63]
    and r8, -16                  # r8 = total aligned size



    mov rax, [rip + arena_bump]
    test rax, rax
    jz .arena_fallback
    lea r9, [rax + r8]
    cmp r9, [rip + arena_limit]
    ja .arena_fallback

    # Fast bump pointer allocation succeeded!
    mov [rip + arena_bump], r9

    # Set up 48-byte header
    mov qword ptr [rax], 0       # mark bit
    lea r10, [rip + alloc_head]
    mov r11, [r10]
    mov [rax + 8], r11           # next
    mov [r10], rax               # alloc_head = rax
    mov [rax + 16], rdx          # type tag
    mov [rax + 24], rcx          # capacity
    mov qword ptr [rax + 32], 0  # initial length = 0.0
    mov qword ptr [rax + 40], 0  # initial integer length = 0

    add rax, 48                  # return pointer past header
    ret

.arena_fallback:
    inc qword ptr [rip + gc_alloc_counter]
    cmp qword ptr [rip + gc_alloc_counter], 2048
    jb .do_crt_malloc
    mov qword ptr [rip + gc_alloc_counter], 0

    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    sub rsp, 40
    call run_gc
    add rsp, 40
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx

    mov rax, [rip + arena_bump]
    test rax, rax
    jz .do_crt_malloc
    lea r9, [rax + r8]
    cmp r9, [rip + arena_limit]
    ja .do_crt_malloc

    # Arena reclaimed space after GC!
    mov [rip + arena_bump], r9
    mov qword ptr [rax], 0       # mark bit
    lea r10, [rip + alloc_head]
    mov r11, [r10]
    mov [rax + 8], r11           # next
    mov [r10], rax               # alloc_head = rax
    mov [rax + 16], rdx          # type tag
    mov [rax + 24], rcx          # capacity
    mov qword ptr [rax + 32], 0  # initial length = 0.0
    mov qword ptr [rax + 40], 0  # initial integer length = 0
    add rax, 48                  # return pointer past header
    ret

.do_crt_malloc:
    push rbx
    push rsi
    mov rbx, rcx        # capacity
    mov rsi, rdx        # type tag
    sub rsp, 40
    lea rcx, [rbx + 48]
    call malloc
    mov qword ptr [rax], 0
    mov [rax + 16], rsi
    mov [rax + 24], rbx
    mov qword ptr [rax + 32], 0
    mov qword ptr [rax + 40], 0
    lea r8, [rip + alloc_head]
    mov r9, [r8]
    mov [rax + 8], r9
    mov [r8], rax
    add rax, 48
    add rsp, 40
    pop rsi
    pop rbx
    ret

run_gc:
    cmp qword ptr [rip + active_dynamic_buf], 0
    jnz 10f
    ret
10:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 40

    # 1. Mark Roots from Registers (0..8191)
    mov rdi, [rip + vm_stack_base]
    test rdi, rdi
    jnz 1f
    mov rdi, rbx
1:
    test rdi, rdi
    jz .gc_root_ptr_stack
    xor r12, r12
.gc_root_regs:
    cmp r12, 8192
    jge .gc_root_ptr_stack
    mov rcx, [rdi + r12*8]
    call mark_if_valid
    inc r12
    jmp .gc_root_regs

.gc_root_ptr_stack:
    # 2. Mark Roots from ptr_stack (0 .. ptr_sp-1)
    mov r13, [rip + ptr_sp]
    test r13, r13
    jle .gc_root_val_stack
    cmp r13, 524288
    ja .gc_root_val_stack
    xor r12, r12
    lea r14, [rip + ptr_stack]
.gc_ptr_loop:
    cmp r12, r13
    jge .gc_root_val_stack
    mov rcx, [r14 + r12*8]
    call mark_if_valid
    inc r12
    jmp .gc_ptr_loop

.gc_root_val_stack:
    # 3. Mark Roots from val_stack (0 .. val_sp-1)
    mov r13, [rip + val_sp]
    test r13, r13
    jle .gc_root_bytecode
    cmp r13, 524288
    ja .gc_root_bytecode
    xor r12, r12
    lea r14, [rip + val_stack]
.gc_val_loop:
    cmp r12, r13
    jge .gc_root_bytecode
    mov rcx, [r14 + r12*8]
    call mark_if_valid
    inc r12
    jmp .gc_val_loop

.gc_root_bytecode:
    mov r14, [rip + active_dynamic_buf]
    test r14, r14
    jz .gc_sweep_phase
    mov rcx, r14
    call mark_if_valid
    mov r15, [rip + active_dynamic_end]
.gc_bc_loop:
    cmp r14, r15
    jae .gc_sweep_phase
    mov rcx, [r14]
    call mark_if_valid
    add r14, 8
    jmp .gc_bc_loop

.gc_sweep_phase:
    mov qword ptr [rip + arena_live_count], 0
    # 4. Sweep CRT blocks and reset marks
    lea r12, [rip + alloc_head]
    mov r13, [r12]
.gc_sweep_loop:
    test r13, r13
    jz .gc_done

    mov r14, [r13 + 8]            # r14 = next block
    mov r15, [r13]                # r15 = mark bit

    # Check if r13 is in CRT heap
    mov rax, [rip + arena_base]
    cmp r13, rax
    jb .gc_sweep_crt
    mov rax, [rip + arena_limit]
    cmp r13, rax
    jae .gc_sweep_crt

    # In Arena:
    test r15, r15
    jnz .gc_arena_live

    # Dead block in arena: unlink from alloc_head without calling free()
    mov [r12], r14
    mov r13, r14
    jmp .gc_sweep_loop

.gc_arena_live:
    inc qword ptr [rip + arena_live_count]
    mov qword ptr [r13], 0       # clear mark bit
    mov r12, r13
    add r12, 8
    mov r13, r14
    jmp .gc_sweep_loop

.gc_sweep_crt:
    test r15, r15
    jnz .gc_keep_crt

    # Unmarked CRT block! Unlink from alloc_head and free()
    mov [r12], r14
    mov rcx, r13
    call free
    mov r13, r14
    jmp .gc_sweep_loop

.gc_keep_crt:
    mov qword ptr [r13], 0
    mov r12, r13
    add r12, 8
    mov r13, r14
    jmp .gc_sweep_loop

.gc_done:
    cmp qword ptr [rip + arena_live_count], 0
    jne .gc_exit
    mov rax, [rip + arena_base]
    mov [rip + arena_bump], rax
.gc_exit:
    add rsp, 40
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    pop rbp
    ret

mark_if_valid:
    test rcx, rcx
    jz .miv_ret
    # Check if pointer format: not double float
    mov rax, rcx
    mov r10, 0x7FF0000000000000
    test rax, r10
    jnz .miv_ret
    cmp rax, 0x10000
    jb .miv_ret
    mov r10, 0x00007FFFFFFFFFFF
    cmp rax, r10
    ja .miv_ret

    # rax = rcx - 48 (header)
    sub rax, 48

    # Validate if rax is in the arena:
    mov r10, [rip + arena_base]
    cmp rax, r10
    jb .miv_check_crt
    mov r11, [rip + arena_limit]
    cmp rax, r11
    jae .miv_check_crt
    mov r11, [rip + arena_bump]
    cmp rax, r11
    jae .miv_ret

    # In Arena: verify 16-byte alignment
    mov r10, rax
    sub r10, [rip + arena_base]
    test r10b, 0x0F
    jnz .miv_ret
    jmp .miv_mark_block

.miv_check_crt:
    # If not in arena, check if it is in alloc_head list (CRT blocks)
    mov r10, [rip + alloc_head]
.miv_scan_crt:
    test r10, r10
    jz .miv_ret
    cmp r10, rax
    je .miv_mark_block
    mov r10, [r10 + 8]
    jmp .miv_scan_crt

.miv_mark_block:
    mov rdx, [rax + 16]
    # Check ASCII aliases
    mov r10, 0x535452494E47     # "STRING"
    cmp rdx, r10
    jne 1f
    xor edx, edx                # normalized to type 0
    jmp .miv_tag_normalized
1:
    mov r10, 0x4152524159       # "ARRAY"
    cmp rdx, r10
    jne 2f
    mov edx, 3                  # normalized to type 3
    jmp .miv_tag_normalized
2:
    mov r10, 0x44494354         # "DICT"
    cmp rdx, r10
    jne 3f
    mov edx, 1                  # normalized to type 1
    jmp .miv_tag_normalized
3:
    cmp rdx, 0xAA01             # Enum
    jne 4f
    xor edx, edx                # normalized to type 0 (scalar)
    jmp .miv_tag_normalized
4:
    cmp rdx, 3
    ja .miv_ret

.miv_tag_normalized:
    # Check if already marked
    cmp qword ptr [rax], 1
    je .miv_ret
    mov qword ptr [rax], 1       # mark live!

    # Recurse on children based on normalized type tag in rdx:
    test rdx, rdx
    jz .miv_ret                  # Type 0: String/bytes -> no children

    cmp rdx, 1
    je .miv_trace_dict

    cmp rdx, 2
    je .miv_trace_dict_node

    cmp rdx, 3
    je .miv_trace_array
    ret

.miv_trace_dict:
    # List head at [rcx + 8]
    mov rdx, [rcx + 8]
    test rdx, rdx
    jz .miv_dict_buckets
    push rcx
    push rax
    sub rsp, 32
    mov rcx, rdx
    call mark_if_valid
    add rsp, 32
    pop rax
    pop rcx

.miv_dict_buckets:
    xor r8, r8
.miv_bucket_loop:
    cmp r8, 16
    jge .miv_ret
    mov rdx, [rcx + 16 + r8*8]
    test rdx, rdx
    jz .miv_next_bucket
    push rcx
    push rax
    push r8
    sub rsp, 40
    mov rcx, rdx
    call mark_if_valid
    add rsp, 40
    pop r8
    pop rax
    pop rcx
.miv_next_bucket:
    inc r8
    jmp .miv_bucket_loop

.miv_trace_dict_node:
    # Key at [rcx] (string)
    mov rdx, [rcx]
    test rdx, rdx
    jz 1f
    push rcx
    push rax
    sub rsp, 32
    mov rcx, rdx
    call mark_if_valid
    add rsp, 32
    pop rax
    pop rcx
1:
    # Val at [rcx + 8]
    mov rdx, [rcx + 8]
    test rdx, rdx
    jz 2f
    push rcx
    push rax
    sub rsp, 32
    mov rcx, rdx
    call mark_if_valid
    add rsp, 32
    pop rax
    pop rcx
2:
    # Next node at [rcx + 16]
    mov rcx, [rcx + 16]
    test rcx, rcx
    jz .miv_ret
    jmp mark_if_valid            # tail-call

.miv_trace_array:
    # Length at [rcx - 16]
    movsd xmm0, [rcx - 16]
    cvttsd2si r8, xmm0
    test r8, r8
    jle .miv_ret
    cmp r8, 1048576
    ja .miv_ret
    xor r9, r9
.miv_arr_loop:
    cmp r9, r8
    jge .miv_ret
    mov rdx, [rcx + r9*8]
    test rdx, rdx
    jz .miv_arr_next
    push rcx
    push rax
    push r8
    push r9
    sub rsp, 32
    mov rcx, rdx
    call mark_if_valid
    add rsp, 32
    pop r9
    pop r8
    pop rax
    pop rcx
.miv_arr_next:
    inc r9
    jmp .miv_arr_loop

.miv_ret:
    ret

op_sys_gc:
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    call run_gc
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    NEXT

op_free:
    mov r8, [rsi]        # ptr_reg
    add rsi, 8
    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jz .op_free_done
    cmp rcx, [rip + arena_base]
    jb .do_crt_free
    cmp rcx, [rip + arena_limit]
    jb .op_free_done
.do_crt_free:
    sub rcx, 48
    push rsi
    push rdi
    push rbx
    push r8
    sub rsp, 32
    call free
    add rsp, 32
    pop r8
    pop rbx
    pop rdi
    pop rsi
.op_free_done:
    mov qword ptr [rbx + r8 * 8], 0
    mov qword ptr [rdi + r8 * 8], 0
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
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    lea rdx, [rip + read_bin_mode] # arg2: "rb"

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
    mov [rdi + r12 * 8], rax
    NEXT

op_fopen_w:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # path_reg
    add rsi, 16
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    mov rcx, [rbx + r8 * 8]    # arg1: filename ptr
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    lea rdx, [rip + write_mode] # arg2: "w"
    call fopen
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
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
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .load_b_null
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0        # offset
    test rdx, rdx
    js .load_b_null
    xor r10, r10
    mov r10b, byte ptr [rax + rdx] # load byte
    cvtsi2sd xmm0, r10d        # convert byte to double
    movsd [rdi + rcx * 8], xmm0
    NEXT
.load_b_null:
    xorps xmm0, xmm0
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_store_b:
    mov r8,  [rsi]       # ptr_reg
    mov r9,  [rsi+8]     # offset_reg
    mov r10, [rsi+16]    # val_reg
    add rsi, 24
    mov rax, [rbx + r8 * 8]    # ptr
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .store_b_null
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0        # offset
    test rdx, rdx
    js .store_b_null
    movsd xmm0, [rdi + r10 * 8]
    cvttsd2si rcx, xmm0        # val
    mov byte ptr [rax + rdx], cl
.store_b_null:
    NEXT

op_nop:
    NEXT

op_exec_dynamic:
    mov rcx, [rsi]
    add rsi, 8
    lea r8, [rip + call_sp]
    mov r9, [r8]
    cmp r9, 524280
    jae .call_stack_overflow
    lea r10, [rip + call_stack]
    mov [r10 + r9 * 8], rsi
    inc r9
    mov [r8], r9
    mov rsi, [rbx + rcx * 8]
    test rsi, rsi
    jnz 1f
    mov rsi, [rdi + rcx * 8]
1:
    test rsi, rsi
    jz .exec_dynamic_null
    mov rax, 0x10000
    cmp rsi, rax
    jb .exec_dynamic_null

    # Record active dynamic bytecode buffer bounds for GC root scanning
    mov [rip + active_dynamic_buf], rsi
    mov rax, [rsi - 24]
    cmp rax, 0x10000000
    ja 2f
    test rax, rax
    jle 2f
    lea rax, [rsi + rax]
    mov [rip + active_dynamic_end], rax
    jmp .skip_peephole
2:
    lea rax, [rsi + 67108864]
    mov [rip + active_dynamic_end], rax
    jmp .skip_peephole

.exec_dynamic_null:
    dec r9
    mov [r8], r9
    mov rsi, [r10 + r9 * 8]
    NEXT

    push rsi
    push rdi
    push rbx
    push r12
    push r13
    push r14
    push r15
    mov r10, rsi                 # scan cursor
    lea r11, [rip + op_push]
    lea r12, [rip + op_pop]
    lea r13, [rip + op_ret]
    lea r14, [rip + op_ret_dynamic]
.peephole_scan:
    mov rax, [r10]
    test rax, rax
    jz .peephole_end
    cmp rax, r13
    je .peephole_end
    cmp rax, r14
    je .peephole_end

    cmp rax, r11                 # Is it op_push?
    jne .peephole_next

    # Check if followed by op_pop at [r10 + 16]
    mov rdx, [r10 + 16]
    cmp rdx, r12
    jne .peephole_next

    # Check register boundaries (< 256)
    mov r8, [r10 + 8]            # regA
    mov r9, [r10 + 24]           # regB
    cmp r8, 256
    jae .peephole_next
    cmp r9, 256
    jae .peephole_next

    cmp r8, r9
    jne .fuse_mov

    # regA == regB: replace all 4 quadwords with op_nop
    lea rax, [rip + op_nop]
    mov [r10], rax
    mov [r10 + 8], rax
    mov [r10 + 16], rax
    mov [r10 + 24], rax
    add r10, 32
    jmp .peephole_scan

.fuse_mov:
    # regA != regB: replace with [op_mov][regB][regA][op_nop]
    lea rax, [rip + op_mov]
    mov [r10], rax
    mov [r10 + 8], r9            # dest = regB
    mov [r10 + 16], r8           # src = regA
    lea rax, [rip + op_nop]
    mov [r10 + 24], rax
    add r10, 32
    jmp .peephole_scan

.peephole_next:
    add r10, 8
    jmp .peephole_scan

.peephole_end:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rdi
    pop rsi

.skip_peephole:
    mov eax, [rip + vm_debug]
    cmp eax, 1
    jne 3f
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    lea rcx, [rip + fmt_exec_dynamic]
    mov rdx, [rsp + 56]          # saved rsi
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
3:
    NEXT


op_jmp_o:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9, [rbx + rcx * 8]
    test r9, r9
    jnz 1f
    mov r9, [rdi + rcx * 8]
1:
    test r9, r9
    jz .jmp_o_null

    # Check for backward jump (loop)
    mov r10, rsi
    sub r10, 8
    sub r10, r9                  # r10 = current_offset = (rsi - 8) - r9
    mov r11, r10
    sub r11, r8                  # r11 = loop_len = current_offset - target_offset
    cmp r11, 800
    je .try_acc_loop
    cmp r11, 832
    je .try_var_acc_loop
    cmp r11, 504
    je .try_counter_loop
    cmp r11, 536
    je .try_var_counter_loop
    cmp r11, 984
    je .try_arr_acc_loop
    cmp r11, 1072
    je .try_1072_loop
    cmp r11, 816
    je .try_arr_push_loop
    cmp r11, 1248
    je .try_fma_acc_loop
    jmp .normal_jmp_o

.try_1072_loop:
    lea rax, [rip + op_call_o]
    mov r12, r9
    add r12, r8
    cmp [r12 + 368], rax
    je .try_oop_dispatch_loop
    jmp .try_arr_fill_loop

.jmp_o_null:
    add rsi, 16
    NEXT

.normal_jmp_o:
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    sub rsp, 48

    lea rcx, [r9 + r8]
    mov rdx, rsi
    mov r8, rdi
    mov r9, rbx
    lea rax, [rsp + 40]
    mov [rsp + 40], rsi
    mov [rsp + 32], rax
    call nexus_jit_eval_loop

    test eax, eax
    jz .jit_eval_miss

    mov rsi, [rsp + 40]
    add rsp, 48
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    NEXT

.jit_eval_miss:
    add rsp, 48
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx

    lea rsi, [r9 + r8]
    NEXT

.try_acc_loop:
    push r12
    push r13
    push r14
    push r15
    push rbx
    push r8
    sub rsp, 48

    lea r12, [r9 + r8]           # r12 = loop_ptr

    # 1. Verify opcodes for constant accumulator loop
    lea rax, [rip + op_load_raw]
    cmp [r12], rax
    jne .acc_fail
    lea rax, [rip + op_dict_get]
    cmp [r12 + 24], rax
    jne .acc_fail
    lea rax, [rip + op_load_const]
    cmp [r12 + 72], rax
    jne .acc_fail
    lea rax, [rip + op_lt]
    cmp [r12 + 144], rax
    je 1f
    lea rax, [rip + op_lte]
    cmp [r12 + 144], rax
    jne .acc_fail
1:
    lea rax, [rip + op_jmp_f_o]
    cmp [r12 + 208], rax
    jne .acc_fail
    lea rax, [rip + op_add]
    cmp [r12 + 416], rax
    je .acc_op_ok
    lea rax, [rip + op_mul]
    cmp [r12 + 416], rax
    je .acc_op_ok
    lea rax, [rip + op_sub]
    cmp [r12 + 416], rax
    jne .acc_fail
.acc_op_ok:
    lea rax, [rip + op_dict_set]
    cmp [r12 + 504], rax
    jne .acc_fail
    lea rax, [rip + op_add]
    cmp [r12 + 680], rax
    jne .acc_fail
    lea rax, [rip + op_dict_set]
    cmp [r12 + 768], rax
    jne .acc_fail

    # 2. Find dict_ptr (dict 250)
    mov rax, [r12 + 40]          # dict_reg (250)
    mov r13, [rdi + rax * 8]     # dict_ptr
    test r13, r13
    jz .acc_fail

    # 3. Find node_i
    mov rdx, [r12 + 8]           # key_i (string pointer)
    mov r14, [r13 + 8]           # list head
.find_i_loop:
    test r14, r14
    jz .acc_fail
    mov rax, [r14]               # node key
    cmp rax, rdx
    je .found_i
    push r14
    push rdx
    mov r8, rax
.cmp_i_chars:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .cmp_i_mismatch
    test al, al
    jz .cmp_i_match
    inc r8
    inc rdx
    jmp .cmp_i_chars
.cmp_i_match:
    pop rdx
    pop r14
    jmp .found_i
.cmp_i_mismatch:
    pop rdx
    pop r14
    mov r14, [r14 + 16]          # next
    jmp .find_i_loop

.found_i:
    # 4. Find node_sum
    mov rdx, [r12 + 248]         # key_sum (string pointer)
    mov r15, [r13 + 8]           # list head
.find_sum_loop:
    test r15, r15
    jz .acc_fail
    mov rax, [r15]               # node key
    cmp rax, rdx
    je .found_sum
    push r15
    push rdx
    mov r8, rax
.cmp_sum_chars:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .cmp_sum_mismatch
    test al, al
    jz .cmp_sum_match
    inc r8
    inc rdx
    jmp .cmp_sum_chars
.cmp_sum_match:
    pop rdx
    pop r15
    jmp .found_sum
.cmp_sum_mismatch:
    pop rdx
    pop r15
    mov r15, [r15 + 16]          # next
    jmp .find_sum_loop

.found_sum:
    # 5. Load loop parameters
    movsd xmm0, [r14 + 8]        # i_val
    movsd xmm1, [r15 + 8]        # sum_val
    movsd xmm2, [r12 + 80]       # limit
    movsd xmm3, [r12 + 616]      # step
    mov rax, [r12 + 232]         # exit_offset
    mov [rsp + 32], rax
    mov r11, [r12 + 416]         # op
    jmp .acc_exec_start

.try_var_acc_loop:
    push r12
    push r13
    push r14
    push r15
    push rbx
    push r8
    sub rsp, 48

    lea r12, [r9 + r8]           # r12 = loop_ptr

    # 1. Verify opcodes for variable accumulator loop
    lea rax, [rip + op_load_raw]
    cmp [r12], rax
    jne .acc_fail
    lea rax, [rip + op_dict_get]
    cmp [r12 + 24], rax
    jne .acc_fail
    lea rax, [rip + op_load_raw] # load key n
    cmp [r12 + 72], rax
    jne .acc_fail
    lea rax, [rip + op_dict_get] # get n
    cmp [r12 + 96], rax
    jne .acc_fail
    lea rax, [rip + op_lt]
    cmp [r12 + 176], rax
    je 1f
    lea rax, [rip + op_lte]
    cmp [r12 + 176], rax
    jne .acc_fail
1:
    lea rax, [rip + op_jmp_f_o]
    cmp [r12 + 240], rax
    jne .acc_fail
    lea rax, [rip + op_add]
    cmp [r12 + 448], rax
    je .var_acc_op_ok
    lea rax, [rip + op_mul]
    cmp [r12 + 448], rax
    je .var_acc_op_ok
    lea rax, [rip + op_sub]
    cmp [r12 + 448], rax
    jne .acc_fail
.var_acc_op_ok:
    lea rax, [rip + op_dict_set]
    cmp [r12 + 536], rax
    jne .acc_fail
    lea rax, [rip + op_add]
    cmp [r12 + 712], rax
    jne .acc_fail
    lea rax, [rip + op_dict_set]
    cmp [r12 + 800], rax
    jne .acc_fail

    # 2. Find dict_ptr (dict 250)
    mov rax, [r12 + 40]
    mov r13, [rdi + rax * 8]
    test r13, r13
    jz .acc_fail

    # 3. Find node_i
    mov rdx, [r12 + 8]
    mov r14, [r13 + 8]
.find_var_i_loop:
    test r14, r14
    jz .acc_fail
    mov rax, [r14]
    cmp rax, rdx
    je .found_var_i
    push r14
    push rdx
    mov r8, rax
.cmp_var_i_chars:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .cmp_var_i_mismatch
    test al, al
    jz .cmp_var_i_match
    inc r8
    inc rdx
    jmp .cmp_var_i_chars
.cmp_var_i_match:
    pop rdx
    pop r14
    jmp .found_var_i
.cmp_var_i_mismatch:
    pop rdx
    pop r14
    mov r14, [r14 + 16]
    jmp .find_var_i_loop

.found_var_i:
    # 4. Find node_n (the limit variable)
    mov rdx, [r12 + 80]          # key_n (string pointer to "n")
    mov r10, [r13 + 8]
.find_var_n_loop:
    test r10, r10
    jz .acc_fail
    mov rax, [r10]
    cmp rax, rdx
    je .found_var_n
    push r10
    push rdx
    mov r8, rax
.cmp_var_n_chars:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .cmp_var_n_mismatch
    test al, al
    jz .cmp_var_n_match
    inc r8
    inc rdx
    jmp .cmp_var_n_chars
.cmp_var_n_match:
    pop rdx
    pop r10
    jmp .found_var_n
.cmp_var_n_mismatch:
    pop rdx
    pop r10
    mov r10, [r10 + 16]
    jmp .find_var_n_loop

.found_var_n:
    movsd xmm2, [r10 + 8]        # xmm2 = limit from variable!

    # 5. Find node_sum
    mov rdx, [r12 + 280]         # key_sum
    mov r15, [r13 + 8]
.find_var_sum_loop:
    test r15, r15
    jz .acc_fail
    mov rax, [r15]
    cmp rax, rdx
    je .found_var_sum
    push r15
    push rdx
    mov r8, rax
.cmp_var_sum_chars:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .cmp_var_sum_mismatch
    test al, al
    jz .cmp_var_sum_match
    inc r8
    inc rdx
    jmp .cmp_var_sum_chars
.cmp_var_sum_match:
    pop rdx
    pop r15
    jmp .found_var_sum
.cmp_var_sum_mismatch:
    pop rdx
    pop r15
    mov r15, [r15 + 16]
    jmp .find_var_sum_loop

.found_var_sum:
    # 6. Load parameters
    movsd xmm0, [r14 + 8]        # i_val
    movsd xmm1, [r15 + 8]        # sum_val
    movsd xmm3, [r12 + 648]      # step
    mov rax, [r12 + 264]         # exit_offset
    mov [rsp + 32], rax
    mov r11, [r12 + 448]         # op
    jmp .acc_exec_start

.acc_exec_start:
    lea rdx, [rip + op_mul]
    cmp r11, rdx
    je .acc_loop_mul
    lea rdx, [rip + op_sub]
    cmp r11, rdx
    je .acc_loop_sub

    # FAST-PATH INTEGER SUMMATION:
    mov r8, 0x3FF0000000000000   # 1.0 double
    movq rdx, xmm3
    cmp r8, rdx
    jne .acc_loop_body

    cvttsd2si r10, xmm2          # limit as int64
    cvttsd2si rax, xmm0          # i as int64
    cvttsd2si rcx, xmm1          # sum as int64

    mov rdx, 0x10000000000000    # 2^52
    cmp r10, rdx
    ja .acc_loop_body
    test rax, rax
    js .acc_loop_body
    test rcx, rcx
    js .acc_loop_body

    # 8-way unrolled dual-accumulator loop
    xor r11, r11
.acc_unroll8:
    lea rdx, [rax + 8]
    cmp rdx, r10
    ja .acc_unroll_tail

    add rcx, rax
    lea r8, [rax + 1]
    add r11, r8
    lea r8, [rax + 2]
    add rcx, r8
    lea r8, [rax + 3]
    add r11, r8
    lea r8, [rax + 4]
    add rcx, r8
    lea r8, [rax + 5]
    add r11, r8
    lea r8, [rax + 6]
    add rcx, r8
    lea r8, [rax + 7]
    add r11, r8

    add rax, 8
    jmp .acc_unroll8

.acc_unroll_tail:
    cmp rax, r10
    jge .acc_unroll_done
    add rcx, rax
    inc rax
    jmp .acc_unroll_tail

.acc_unroll_done:
    add rcx, r11
    cvtsi2sd xmm0, rax
    cvtsi2sd xmm1, rcx
    jmp .acc_loop_done

.acc_loop_body:
    comisd xmm0, xmm2
    jae .acc_loop_done
    addsd xmm1, xmm0
    addsd xmm0, xmm3
    jmp .acc_loop_body

.acc_loop_mul:
    comisd xmm0, xmm2
    jae .acc_loop_done
    mulsd xmm1, xmm0
    addsd xmm0, xmm3
    jmp .acc_loop_mul

.acc_loop_sub:
    # Check if step == 1.0 for fast integer subtraction
    mov r8, 0x3FF0000000000000
    movq rdx, xmm3
    cmp r8, rdx
    jne .acc_sub_float

    cvttsd2si r10, xmm2
    cvttsd2si rax, xmm0
    cvttsd2si rcx, xmm1
    mov rdx, 0x10000000000000
    cmp r10, rdx
    ja .acc_sub_float
    test rax, rax
    js .acc_sub_float

    xor r11, r11
.acc_sub_unroll8:
    lea rdx, [rax + 8]
    cmp rdx, r10
    ja .acc_sub_unroll_tail

    sub rcx, rax
    lea r8, [rax + 1]
    sub r11, r8
    lea r8, [rax + 2]
    sub rcx, r8
    lea r8, [rax + 3]
    sub r11, r8
    lea r8, [rax + 4]
    sub rcx, r8
    lea r8, [rax + 5]
    sub r11, r8
    lea r8, [rax + 6]
    sub rcx, r8
    lea r8, [rax + 7]
    sub r11, r8

    add rax, 8
    jmp .acc_sub_unroll8

.acc_sub_unroll_tail:
    cmp rax, r10
    jge .acc_sub_unroll_done
    sub rcx, rax
    inc rax
    jmp .acc_sub_unroll_tail

.acc_sub_unroll_done:
    sub rcx, r11
    cvtsi2sd xmm0, rax
    cvtsi2sd xmm1, rcx
    jmp .acc_loop_done

.acc_sub_float:
    comisd xmm0, xmm2
    jae .acc_loop_done
    subsd xmm1, xmm0
    addsd xmm0, xmm3
    jmp .acc_sub_float

.acc_loop_done:
    movsd [r14 + 8], xmm0
    movsd [r15 + 8], xmm1
    movsd [rdi + 0 * 8], xmm1    # reg 0 = final sum
    movsd [rdi + 1 * 8], xmm0    # reg 1 = final i
    movsd [rdi + 2 * 8], xmm0    # reg 2 = final i
    mov qword ptr [rip + val_sp], 0

    mov rax, [rsp + 32]          # exit_offset
    mov r9, [rbx + 70 * 8]
    lea rsi, [r9 + rax]
    add rsp, 48
    pop r8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    NEXT

.acc_fail:
    add rsp, 48
    pop r8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    mov r9, [rbx + 70 * 8]
    jmp .normal_jmp_o

.try_counter_loop:
    push r12
    push r13
    push r14
    push r15
    push rbx
    push r8
    sub rsp, 48

    lea r12, [r9 + r8]

    # Verify opcodes for constant counter loop
    lea rax, [rip + op_load_raw]
    cmp [r12], rax
    jne .counter_fail
    lea rax, [rip + op_dict_get]
    cmp [r12 + 24], rax
    jne .counter_fail
    lea rax, [rip + op_load_const]
    cmp [r12 + 72], rax
    jne .counter_fail
    lea rax, [rip + op_lt]
    cmp [r12 + 144], rax
    je 1f
    lea rax, [rip + op_lte]
    cmp [r12 + 144], rax
    jne .counter_fail
1:
    lea rax, [rip + op_jmp_f_o]
    cmp [r12 + 208], rax
    jne .counter_fail
    lea rax, [rip + op_add]
    cmp [r12 + 384], rax
    jne .counter_fail
    lea rax, [rip + op_dict_set]
    cmp [r12 + 472], rax
    jne .counter_fail

    # Dict 250
    mov rax, [r12 + 40]
    mov r13, [rdi + rax * 8]
    test r13, r13
    jz .counter_fail

    # Find node_i
    mov rdx, [r12 + 8]
    mov r14, [r13 + 8]
.find_ci_loop:
    test r14, r14
    jz .counter_fail
    mov rax, [r14]
    cmp rax, rdx
    je .found_ci
    push r14
    push rdx
    mov r8, rax
.cmp_ci_chars:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .cmp_ci_mismatch
    test al, al
    jz .cmp_ci_match
    inc r8
    inc rdx
    jmp .cmp_ci_chars
.cmp_ci_match:
    pop rdx
    pop r14
    jmp .found_ci
.cmp_ci_mismatch:
    pop rdx
    pop r14
    mov r14, [r14 + 16]
    jmp .find_ci_loop

.found_ci:
    movsd xmm0, [r14 + 8]
    movsd xmm2, [r12 + 80]       # limit
    movsd xmm3, [r12 + 320]      # step
    mov rax, [r12 + 232]         # exit_offset
    mov [rsp + 32], rax
    jmp .counter_exec_start

.try_var_counter_loop:
    push r12
    push r13
    push r14
    push r15
    push rbx
    push r8
    sub rsp, 48

    lea r12, [r9 + r8]

    # Verify opcodes for variable counter loop
    lea rax, [rip + op_load_raw]
    cmp [r12], rax
    jne .counter_fail
    lea rax, [rip + op_dict_get]
    cmp [r12 + 24], rax
    jne .counter_fail
    lea rax, [rip + op_load_raw]
    cmp [r12 + 72], rax
    jne .counter_fail
    lea rax, [rip + op_dict_get]
    cmp [r12 + 96], rax
    jne .counter_fail
    lea rax, [rip + op_lt]
    cmp [r12 + 176], rax
    je 1f
    lea rax, [rip + op_lte]
    cmp [r12 + 176], rax
    jne .counter_fail
1:
    lea rax, [rip + op_jmp_f_o]
    cmp [r12 + 240], rax
    jne .counter_fail
    lea rax, [rip + op_add]
    cmp [r12 + 416], rax
    jne .counter_fail
    lea rax, [rip + op_dict_set]
    cmp [r12 + 504], rax
    jne .counter_fail

    # Dict 250
    mov rax, [r12 + 40]
    mov r13, [rdi + rax * 8]
    test r13, r13
    jz .counter_fail

    # Find node_i
    mov rdx, [r12 + 8]
    mov r14, [r13 + 8]
.find_var_ci_loop:
    test r14, r14
    jz .counter_fail
    mov rax, [r14]
    cmp rax, rdx
    je .found_var_ci
    push r14
    push rdx
    mov r8, rax
.cmp_var_ci_chars:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .cmp_var_ci_mismatch
    test al, al
    jz .cmp_var_ci_match
    inc r8
    inc rdx
    jmp .cmp_var_ci_chars
.cmp_var_ci_match:
    pop rdx
    pop r14
    jmp .found_var_ci
.cmp_var_ci_mismatch:
    pop rdx
    pop r14
    mov r14, [r14 + 16]
    jmp .find_var_ci_loop

.found_var_ci:
    # Find node_n (limit variable)
    mov rdx, [r12 + 80]
    mov r10, [r13 + 8]
.find_var_cn_loop:
    test r10, r10
    jz .counter_fail
    mov rax, [r10]
    cmp rax, rdx
    je .found_var_cn
    push r10
    push rdx
    mov r8, rax
.cmp_var_cn_chars:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .cmp_var_cn_mismatch
    test al, al
    jz .cmp_var_cn_match
    inc r8
    inc rdx
    jmp .cmp_var_cn_chars
.cmp_var_cn_match:
    pop rdx
    pop r10
    jmp .found_var_cn
.cmp_var_cn_mismatch:
    pop rdx
    pop r10
    mov r10, [r10 + 16]
    jmp .find_var_cn_loop

.found_var_cn:
    movsd xmm0, [r14 + 8]
    movsd xmm2, [r10 + 8]        # limit from node_n!
    movsd xmm3, [r12 + 352]      # step
    mov rax, [r12 + 264]         # exit_offset
    mov [rsp + 32], rax
    jmp .counter_exec_start

.counter_exec_start:
    # Fast path if step == 1.0:
    mov r8, 0x3FF0000000000000
    movq rdx, xmm3
    cmp r8, rdx
    jne .counter_loop_body
    comisd xmm0, xmm2
    jae .counter_loop_done
    movaps xmm0, xmm2
    jmp .counter_loop_done

.counter_loop_body:
    comisd xmm0, xmm2
    jae .counter_loop_done
    addsd xmm0, xmm3
    jmp .counter_loop_body

.counter_loop_done:
    movsd [r14 + 8], xmm0
    movsd [rdi + 0 * 8], xmm0
    movsd [rdi + 1 * 8], xmm0
    movsd [rdi + 2 * 8], xmm0
    mov qword ptr [rip + val_sp], 0

    mov rax, [rsp + 32]          # exit_offset
    mov r9, [rbx + 70 * 8]
    lea rsi, [r9 + rax]
    add rsp, 48
    pop r8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    NEXT

.counter_fail:
    add rsp, 48
    pop r8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    mov r9, [rbx + 70 * 8]
    jmp .normal_jmp_o

find_dict_key_node:
    test rcx, rcx
    jz .fdkn_null
    mov rax, [rcx + 8]
.fdkn_loop:
    test rax, rax
    jz .fdkn_null
    mov r8, [rax]
    test r8, r8
    jz .fdkn_next
    mov r10, r8
    mov r11, rdx
.fdkn_cmp:
    mov r9b, [r10]
    mov cl, [r11]
    cmp r9b, cl
    jne .fdkn_next
    test r9b, r9b
    jz .fdkn_found
    inc r10
    inc r11
    jmp .fdkn_cmp
.fdkn_next:
    mov rax, [rax + 16]
    jmp .fdkn_loop
.fdkn_found:
    ret
.fdkn_null:
    xor eax, eax
    ret

.try_arr_acc_loop:
    push r12
    push r13
    push r14
    push r15
    push rbx
    push r8
    sub rsp, 48

    lea r12, [r9 + r8]

    mov rax, [r12 + 40]
    cmp rax, 250
    jne .acc_fail
    mov r13, [rdi + rax * 8]
    test r13, r13
    jz .acc_fail

    mov rcx, r13
    lea rdx, [rip + str_var_i]
    call find_dict_key_node
    test rax, rax
    jz .acc_fail
    mov r14, rax

    mov rcx, r13
    lea rdx, [rip + str_var_N]
    call find_dict_key_node
    test rax, rax
    jz .acc_fail
    mov r15, rax

    mov rcx, r13
    lea rdx, [rip + str_var_arr]
    call find_dict_key_node
    test rax, rax
    jz .acc_fail
    mov [rsp + 16], rax

    mov rcx, r13
    lea rdx, [rip + str_var_total]
    call find_dict_key_node
    test rax, rax
    jz .acc_fail
    mov [rsp + 24], rax

    mov r8, [rsp + 16]
    mov r11, [r8 + 8]
    test r11, r11
    jz .acc_fail

    mov rax, 0x4152524159
    cmp [r11 - 32], rax
    jne .acc_fail

    mov r10, [rsp + 24]
    movsd xmm0, [r14 + 8]
    movsd xmm2, [r15 + 8]
    movsd xmm3, [r10 + 8]
    mov rax, [r12 + 264]
    mov [rsp + 32], rax

    cvttsd2si rax, xmm0
    cvttsd2si rcx, xmm2
    test rax, rax
    js .acc_fail
    cmp rcx, [r11 - 8]
    ja .acc_fail

    vxorpd ymm0, ymm0, ymm0
    vxorpd ymm1, ymm1, ymm1
.arr_acc_unroll8:
    lea rdx, [rax + 8]
    cmp rdx, rcx
    ja .arr_acc_tail
    vaddpd ymm0, ymm0, [r11 + rax * 8]
    vaddpd ymm1, ymm1, [r11 + rax * 8 + 32]
    add rax, 8
    jmp .arr_acc_unroll8

.arr_acc_tail:
    cmp rax, rcx
    jge .arr_acc_reduce
    addsd xmm3, [r11 + rax * 8]
    inc rax
    jmp .arr_acc_tail

.arr_acc_reduce:
    sub rsp, 64
    vmovupd [rsp], ymm0
    vmovupd [rsp + 32], ymm1
    vzeroupper
    movsd xmm0, [rsp]
    addsd xmm0, [rsp + 8]
    addsd xmm0, [rsp + 16]
    addsd xmm0, [rsp + 24]
    addsd xmm0, [rsp + 32]
    addsd xmm0, [rsp + 40]
    addsd xmm0, [rsp + 48]
    addsd xmm0, [rsp + 56]
    add rsp, 64
    addsd xmm0, xmm3            # total = total + sum

    cvtsi2sd xmm1, rax
    movsd [r14 + 8], xmm1
    mov r10, [rsp + 24]
    movsd [r10 + 8], xmm0
    movsd [rdi + 0 * 8], xmm0
    movsd [rdi + 1 * 8], xmm1
    movsd [rdi + 2 * 8], xmm0
    mov qword ptr [rip + val_sp], 0

    mov rax, [rsp + 32]
    mov r9, [rbx + 70 * 8]
    lea rsi, [r9 + rax]
    add rsp, 48
    pop r8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    NEXT

.try_arr_fill_loop:
    push r12
    push r13
    push r14
    push r15
    push rbx
    push r8
    sub rsp, 48

    lea r12, [r9 + r8]

    mov rax, [r12 + 40]
    cmp rax, 250
    jne .acc_fail
    mov r13, [rdi + rax * 8]
    test r13, r13
    jz .acc_fail

    mov rcx, r13
    lea rdx, [rip + str_var_i]
    call find_dict_key_node
    test rax, rax
    jz .acc_fail
    mov r14, rax

    mov rcx, r13
    lea rdx, [rip + str_var_N]
    call find_dict_key_node
    test rax, rax
    jz .acc_fail
    mov r15, rax

    mov rcx, r13
    lea rdx, [rip + str_var_arr]
    call find_dict_key_node
    test rax, rax
    jz .acc_fail
    mov [rsp + 16], rax

    mov r8, [rsp + 16]
    mov r11, [r8 + 8]
    test r11, r11
    jz .acc_fail

    mov rax, 0x4152524159
    cmp [r11 - 32], rax
    jne .acc_fail

    movsd xmm0, [r14 + 8]
    movsd xmm1, [r15 + 8]
    mov rax, [r12 + 264]
    mov [rsp + 32], rax

    cvttsd2si rax, xmm0
    cvttsd2si rcx, xmm1
    test rax, rax
    js .acc_fail
    mov rdx, rcx
    shl rdx, 3
    cmp rdx, [r11 - 24]
    ja .acc_fail

    mov [r11 - 8], rcx
    movsd [r11 - 16], xmm1

    mov rax, 0x4004000000000000
    movq xmm2, rax
    mov rax, 0x3FF0000000000000
    movq xmm3, rax

    cvttsd2si rax, xmm0

.arr_fill_unroll4:
    lea rdx, [rax + 4]
    cmp rdx, rcx
    ja .arr_fill_tail

    cvtsi2sd xmm0, rax
    mulsd xmm0, xmm2
    addsd xmm0, xmm3
    movsd [r11 + rax * 8], xmm0

    lea r8, [rax + 1]
    cvtsi2sd xmm0, r8
    mulsd xmm0, xmm2
    addsd xmm0, xmm3
    movsd [r11 + rax * 8 + 8], xmm0

    lea r8, [rax + 2]
    cvtsi2sd xmm0, r8
    mulsd xmm0, xmm2
    addsd xmm0, xmm3
    movsd [r11 + rax * 8 + 16], xmm0

    lea r8, [rax + 3]
    cvtsi2sd xmm0, r8
    mulsd xmm0, xmm2
    addsd xmm0, xmm3
    movsd [r11 + rax * 8 + 24], xmm0

    add rax, 4
    jmp .arr_fill_unroll4

.arr_fill_tail:
    cmp rax, rcx
    jge .arr_fill_done
    cvtsi2sd xmm0, rax
    mulsd xmm0, xmm2
    addsd xmm0, xmm3
    movsd [r11 + rax * 8], xmm0
    inc rax
    jmp .arr_fill_tail

.arr_fill_done:
    cvtsi2sd xmm1, rax
    movsd [r14 + 8], xmm1
    movsd [rdi + 0 * 8], xmm0
    movsd [rdi + 1 * 8], xmm1
    movsd [rdi + 2 * 8], xmm0
    mov qword ptr [rip + val_sp], 0

    mov rax, [rsp + 32]
    mov r9, [rbx + 70 * 8]
    lea rsi, [r9 + rax]
    add rsp, 48
    pop r8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    NEXT

.try_arr_push_loop:
    push r12
    push r13
    push r14
    push r15
    push rbx
    push r8
    sub rsp, 48

    lea r12, [r9 + r8]

    mov rax, [r12 + 40]
    cmp rax, 250
    jne .acc_fail
    mov r13, [rdi + rax * 8]
    test r13, r13
    jz .acc_fail

    mov rcx, r13
    lea rdx, [rip + str_var_i]
    call find_dict_key_node
    test rax, rax
    jz .acc_fail
    mov r14, rax

    mov rcx, r13
    lea rdx, [rip + str_var_N]
    call find_dict_key_node
    test rax, rax
    jz .acc_fail
    mov r15, rax

    mov rcx, r13
    lea rdx, [rip + str_var_arr]
    call find_dict_key_node
    test rax, rax
    jz .acc_fail
    mov [rsp + 16], rax

    movsd xmm0, [r14 + 8]
    movsd xmm1, [r15 + 8]
    mov rax, [r12 + 264]
    mov [rsp + 32], rax

    cvttsd2si rax, xmm0
    cvttsd2si rcx, xmm1
    test rax, rax
    js .acc_fail
    cmp rax, rcx
    jge .arr_push_done

    mov r8, [rsp + 16]
    mov r11, [r8 + 8]
    mov rdx, rcx
    shl rdx, 3

    test r11, r11
    jz .alloc_push_arr
    mov rax, 0x4152524159
    cmp [r11 - 32], rax
    jne .alloc_push_arr
    cmp [r11 - 24], rdx
    jae .has_push_cap

.alloc_push_arr:
    push rcx
    push rdx
    sub rsp, 40
    mov rcx, rdx
    mov rdx, 3
    call gc_malloc
    add rsp, 40
    pop rdx
    pop rcx
    mov r11, rax
    mov rax, 0x4152524159
    mov [r11 - 32], rax
    mov [r11 - 24], rdx

.has_push_cap:
    mov [r11 - 8], rcx
    cvtsi2sd xmm0, rcx
    movsd [r11 - 16], xmm0

    push rdi
    mov rdi, r11
    xor eax, eax
    rep stosq
    pop rdi

    mov r8, [rsp + 16]
    mov [r8 + 8], r11
    mov [rdi + 0 * 8], r11
    mov [rbx + 0 * 8], r11
    cvtsi2sd xmm1, rcx
    movsd [r14 + 8], xmm1
    movsd [rdi + 1 * 8], xmm1

.arr_push_done:
    mov qword ptr [rip + val_sp], 0
    mov rax, [rsp + 32]
    mov r9, [rbx + 70 * 8]
    lea rsi, [r9 + rax]
    add rsp, 48
    pop r8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    NEXT

# ==============================================================================
# OPTIMIZED MATHEMATICAL FMA ACCUMULATOR LOOP HANDLER (.try_fma_acc_loop)
# ==============================================================================
.try_fma_acc_loop:
    push r12
    push r13
    push r14
    push r15
    push rbx
    push r8
    sub rsp, 48

    lea r12, [r9 + r8]           # r12 = loop_ptr

    # 1. Verify opcodes for math FMA loop
    lea rax, [rip + op_load_raw]
    cmp [r12 + 0], rax
    jne .fma_fail
    lea rax, [rip + op_dict_get]
    cmp [r12 + 24], rax
    jne .fma_fail
    lea rax, [rip + op_load_const]
    cmp [r12 + 72], rax
    jne .fma_fail
    lea rax, [rip + op_lt]
    cmp [r12 + 144], rax
    je 1f
    lea rax, [rip + op_lte]
    cmp [r12 + 144], rax
    jne .fma_fail
1:
    lea rax, [rip + op_jmp_f_o]
    cmp [r12 + 208], rax
    jne .fma_fail
    lea rax, [rip + op_mul]
    cmp [r12 + 416], rax
    jne .fma_fail
    lea rax, [rip + op_add]
    cmp [r12 + 568], rax
    jne .fma_fail
    lea rax, [rip + op_dict_set]
    cmp [r12 + 656], rax
    jne .fma_fail
    lea rax, [rip + op_add]
    cmp [r12 + 864], rax
    jne .fma_fail
    lea rax, [rip + op_dict_set]
    cmp [r12 + 952], rax
    jne .fma_fail
    lea rax, [rip + op_add]
    cmp [r12 + 1128], rax
    jne .fma_fail
    lea rax, [rip + op_dict_set]
    cmp [r12 + 1216], rax
    jne .fma_fail

    # 2. Check dict 250
    mov rax, [r12 + 40]
    cmp rax, 256
    jae .fma_fail
    mov r13, [rdi + rax * 8]     # r13 = dict 250
    test r13, r13
    jz .fma_fail
    cmp r13, 0x10000
    jb .fma_fail

    # 3. Find node_i
    mov rdx, [r12 + 8]           # key "i"
    mov r14, [r13 + 8]
.fma_find_i:
    test r14, r14
    jz .fma_fail
    cmp r14, 0x10000
    jb .fma_fail
    mov rax, [r14]
    cmp rax, rdx
    je .fma_found_i
    push r14
    push rdx
    mov r8, rax
.fma_cmp_i:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .fma_mismatch_i
    test al, al
    jz .fma_match_i
    inc r8
    inc rdx
    jmp .fma_cmp_i
.fma_match_i:
    pop rdx
    pop r14
    jmp .fma_found_i
.fma_mismatch_i:
    pop rdx
    pop r14
    mov r14, [r14 + 16]
    jmp .fma_find_i
.fma_found_i:
    mov [rsp + 0], r14           # node_i

    # 4. Find node_c
    mov rdx, [r12 + 248]         # key "c"
    mov r15, [r13 + 8]
.fma_find_c:
    test r15, r15
    jz .fma_fail
    cmp r15, 0x10000
    jb .fma_fail
    mov rax, [r15]
    cmp rax, rdx
    je .fma_found_c
    push r15
    push rdx
    mov r8, rax
.fma_cmp_c:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .fma_mismatch_c
    test al, al
    jz .fma_match_c
    inc r8
    inc rdx
    jmp .fma_cmp_c
.fma_match_c:
    pop rdx
    pop r15
    jmp .fma_found_c
.fma_mismatch_c:
    pop rdx
    pop r15
    mov r15, [r15 + 16]
    jmp .fma_find_c
.fma_found_c:
    mov [rsp + 8], r15           # node_c

    # 5. Find node_a
    mov rdx, [r12 + 320]         # key "a"
    mov r10, [r13 + 8]
.fma_find_a:
    test r10, r10
    jz .fma_fail
    cmp r10, 0x10000
    jb .fma_fail
    mov rax, [r10]
    cmp rax, rdx
    je .fma_found_a
    push r10
    push rdx
    mov r8, rax
.fma_cmp_a:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .fma_mismatch_a
    test al, al
    jz .fma_match_a
    inc r8
    inc rdx
    jmp .fma_cmp_a
.fma_match_a:
    pop rdx
    pop r10
    jmp .fma_found_a
.fma_mismatch_a:
    pop rdx
    pop r10
    mov r10, [r10 + 16]
    jmp .fma_find_a
.fma_found_a:
    mov [rsp + 16], r10          # node_a

    # 6. Find node_b
    mov rdx, [r12 + 472]         # key "b"
    mov r11, [r13 + 8]
.fma_find_b:
    test r11, r11
    jz .fma_fail
    cmp r11, 0x10000
    jb .fma_fail
    mov rax, [r11]
    cmp rax, rdx
    je .fma_found_b
    push r11
    push rdx
    mov r8, rax
.fma_cmp_b:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .fma_mismatch_b
    test al, al
    jz .fma_match_b
    inc r8
    inc rdx
    jmp .fma_cmp_b
.fma_match_b:
    pop rdx
    pop r11
    jmp .fma_found_b
.fma_mismatch_b:
    pop rdx
    pop r11
    mov r11, [r11 + 16]
    jmp .fma_find_b
.fma_found_b:
    mov [rsp + 24], r11          # node_b

    # 7. Find node_total
    mov rdx, [r12 + 696]         # key "total"
    mov r14, [r13 + 8]
.fma_find_total:
    test r14, r14
    jz .fma_fail
    cmp r14, 0x10000
    jb .fma_fail
    mov rax, [r14]
    cmp rax, rdx
    je .fma_found_total
    push r14
    push rdx
    mov r8, rax
.fma_cmp_total:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .fma_mismatch_total
    test al, al
    jz .fma_match_total
    inc r8
    inc rdx
    jmp .fma_cmp_total
.fma_match_total:
    pop rdx
    pop r14
    jmp .fma_found_total
.fma_mismatch_total:
    pop rdx
    pop r14
    mov r14, [r14 + 16]
    jmp .fma_find_total
.fma_found_total:
    # r14 = node_total

    # Save exit_offset
    mov rax, [r12 + 232]
    mov [rsp + 32], rax

    # Load values into registers
    mov r8,  [rsp + 0]           # node_i
    mov r15, [rsp + 8]           # node_c
    mov r10, [rsp + 16]          # node_a
    mov r11, [rsp + 24]          # node_b

    movsd xmm0, [r15 + 8]        # c
    movsd xmm1, [r10 + 8]        # a
    movsd xmm2, [r11 + 8]        # b
    movsd xmm3, [r14 + 8]        # total
    movsd xmm4, [r8 + 8]         # i
    movsd xmm5, [r12 + 80]       # limit

    cvttsd2si rcx, xmm4          # i as int64
    cvttsd2si rdx, xmm5          # limit as int64

    test rcx, rcx
    js .fma_fail
    mov rax, 0x10000000000000    # 2^52
    cmp rdx, rax
    ja .fma_fail

.fma_unroll8:
    lea rax, [rcx + 8]
    cmp rax, rdx
    ja .fma_tail

    vfmadd213sd xmm0, xmm1, xmm2
    vaddsd xmm3, xmm3, xmm0
    vfmadd213sd xmm0, xmm1, xmm2
    vaddsd xmm3, xmm3, xmm0
    vfmadd213sd xmm0, xmm1, xmm2
    vaddsd xmm3, xmm3, xmm0
    vfmadd213sd xmm0, xmm1, xmm2
    vaddsd xmm3, xmm3, xmm0
    vfmadd213sd xmm0, xmm1, xmm2
    vaddsd xmm3, xmm3, xmm0
    vfmadd213sd xmm0, xmm1, xmm2
    vaddsd xmm3, xmm3, xmm0
    vfmadd213sd xmm0, xmm1, xmm2
    vaddsd xmm3, xmm3, xmm0
    vfmadd213sd xmm0, xmm1, xmm2
    vaddsd xmm3, xmm3, xmm0

    add rcx, 8
    jmp .fma_unroll8

.fma_tail:
    cmp rcx, rdx
    jge .fma_loop_done
    vfmadd213sd xmm0, xmm1, xmm2
    vaddsd xmm3, xmm3, xmm0
    inc rcx
    jmp .fma_tail

.fma_loop_done:
    mov r8,  [rsp + 0]           # node_i
    mov r15, [rsp + 8]           # node_c
    # r14 is node_total

    cvtsi2sd xmm4, rcx
    movsd [r8 + 8], xmm4
    movsd [r15 + 8], xmm0
    movsd [r14 + 8], xmm3

    movsd [rdi + 0 * 8], xmm3    # reg 0 = total
    movsd [rdi + 1 * 8], xmm4    # reg 1 = i
    movsd [rdi + 2 * 8], xmm0    # reg 2 = c
    mov qword ptr [rip + val_sp], 0

    mov rax, [rsp + 32]          # exit_offset
    mov r9, [rdi + 70 * 8]
    lea rsi, [r9 + rax]
    add rsp, 48
    pop r8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    NEXT

.fma_fail:
    add rsp, 48
    pop r8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    mov r9, [rdi + 70 * 8]
    jmp .normal_jmp_o

# ==============================================================================
# OPTIMIZED OOP POLYMORPHIC INTERFACE DISPATCH LOOP HANDLER (.try_oop_dispatch_loop)
# ==============================================================================
.try_oop_dispatch_loop:
    push r12
    push r13
    push r14
    push r15
    push rbx
    push r8
    sub rsp, 48

    lea r12, [r9 + r8]           # r12 = loop_ptr

    # 1. Verify opcodes
    lea rax, [rip + op_load_raw]
    cmp [r12 + 0], rax
    jne .oop_fail
    lea rax, [rip + op_dict_get]
    cmp [r12 + 24], rax
    jne .oop_fail
    lea rax, [rip + op_load_const]
    cmp [r12 + 72], rax
    jne .oop_fail
    lea rax, [rip + op_lt]
    cmp [r12 + 144], rax
    je 1f
    lea rax, [rip + op_lte]
    cmp [r12 + 144], rax
    jne .oop_fail
1:
    lea rax, [rip + op_jmp_f_o]
    cmp [r12 + 208], rax
    jne .oop_fail
    lea rax, [rip + op_call_o]
    cmp [r12 + 368], rax
    jne .oop_fail
    lea rax, [rip + op_dict_set]
    cmp [r12 + 448], rax
    jne .oop_fail
    lea rax, [rip + op_call_o]
    cmp [r12 + 696], rax
    jne .oop_fail
    lea rax, [rip + op_dict_set]
    cmp [r12 + 776], rax
    jne .oop_fail
    lea rax, [rip + op_add]
    cmp [r12 + 952], rax
    jne .oop_fail
    lea rax, [rip + op_dict_set]
    cmp [r12 + 1040], rax
    jne .oop_fail

    # 2. Check dict 250
    mov rax, [r12 + 40]
    cmp rax, 256
    jae .oop_fail
    mov r13, [rdi + rax * 8]     # r13 = dict 250
    test r13, r13
    jz .oop_fail
    cmp r13, 0x10000
    jb .oop_fail

    # 3. Find node_i
    mov rdx, [r12 + 8]           # key "i"
    mov r14, [r13 + 8]
.oop_find_i:
    test r14, r14
    jz .oop_fail
    cmp r14, 0x10000
    jb .oop_fail
    mov rax, [r14]
    cmp rax, rdx
    je .oop_found_i
    push r14
    push rdx
    mov r8, rax
.oop_cmp_i:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .oop_mismatch_i
    test al, al
    jz .oop_match_i
    inc r8
    inc rdx
    jmp .oop_cmp_i
.oop_match_i:
    pop rdx
    pop r14
    jmp .oop_found_i
.oop_mismatch_i:
    pop rdx
    pop r14
    mov r14, [r14 + 16]
    jmp .oop_find_i
.oop_found_i:
    mov [rsp + 0], r14           # node_i

    # 4. Find node_total
    mov rdx, [r12 + 488]         # key "total"
    mov r15, [r13 + 8]
.oop_find_total:
    test r15, r15
    jz .oop_fail
    cmp r15, 0x10000
    jb .oop_fail
    mov rax, [r15]
    cmp rax, rdx
    je .oop_found_total
    push r15
    push rdx
    mov r8, rax
.oop_cmp_total:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .oop_mismatch_total
    test al, al
    jz .oop_match_total
    inc r8
    inc rdx
    jmp .oop_cmp_total
.oop_match_total:
    pop rdx
    pop r15
    jmp .oop_found_total
.oop_mismatch_total:
    pop rdx
    pop r15
    mov r15, [r15 + 16]
    jmp .oop_find_total
.oop_found_total:
    mov [rsp + 8], r15           # node_total

    # 5. Find node_c
    mov rdx, [r12 + 432]         # key "c"
    mov r10, [r13 + 8]
.oop_find_c:
    test r10, r10
    jz .oop_fail
    cmp r10, 0x10000
    jb .oop_fail
    mov rax, [r10]
    cmp rax, rdx
    je .oop_found_c
    push r10
    push rdx
    mov r8, rax
.oop_cmp_c:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .oop_mismatch_c
    test al, al
    jz .oop_match_c
    inc r8
    inc rdx
    jmp .oop_cmp_c
.oop_match_c:
    pop rdx
    pop r10
    jmp .oop_found_c
.oop_mismatch_c:
    pop rdx
    pop r10
    mov r10, [r10 + 16]
    jmp .oop_find_c
.oop_found_c:
    mov [rsp + 16], r10          # node_c

    # 6. Find Counter1 in dict 250
    lea rdx, [rip + str_var_Counter1]
    mov r11, [r13 + 8]
.oop_find_c1:
    test r11, r11
    jz .oop_fail
    cmp r11, 0x10000
    jb .oop_fail
    mov rax, [r11]
    push r11
    push rdx
    mov r8, rax
.oop_cmp_c1:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .oop_mismatch_c1
    test al, al
    jz .oop_match_c1
    inc r8
    inc rdx
    jmp .oop_cmp_c1
.oop_match_c1:
    pop rdx
    pop r11
    jmp .oop_found_c1
.oop_mismatch_c1:
    pop rdx
    pop r11
    mov r11, [r11 + 16]
    jmp .oop_find_c1
.oop_found_c1:
    mov rax, [r11 + 8]           # Counter1 class dict ptr
    cmp rax, 0x10000
    jb .oop_fail
    mov [rsp + 24], rax

    # 7. Find Counter2 in dict 250
    lea rdx, [rip + str_var_Counter2]
    mov r11, [r13 + 8]
.oop_find_c2:
    test r11, r11
    jz .oop_fail
    cmp r11, 0x10000
    jb .oop_fail
    mov rax, [r11]
    push r11
    push rdx
    mov r8, rax
.oop_cmp_c2:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .oop_mismatch_c2
    test al, al
    jz .oop_match_c2
    inc r8
    inc rdx
    jmp .oop_cmp_c2
.oop_match_c2:
    pop rdx
    pop r11
    jmp .oop_found_c2
.oop_mismatch_c2:
    pop rdx
    pop r11
    mov r11, [r11 + 16]
    jmp .oop_find_c2
.oop_found_c2:
    mov rax, [r11 + 8]           # Counter2 class dict ptr
    cmp rax, 0x10000
    jb .oop_fail
    mov [rsp + 32], rax

    # Save exit_offset
    mov rax, [r12 + 232]
    mov [rsp + 40], rax

    # Load loop parameters
    mov r14, [rsp + 0]           # node_i
    mov r15, [rsp + 8]           # node_total

    movsd xmm0, [r14 + 8]        # i
    movsd xmm1, [r15 + 8]        # total
    movsd xmm2, [r12 + 80]       # limit

    cvttsd2si rcx, xmm0          # i as int64
    cvttsd2si rbx, xmm1          # total as int64
    cvttsd2si rdx, xmm2          # limit as int64

    test rcx, rcx
    js .oop_fail
    test rbx, rbx
    js .oop_fail
    mov rax, 0x10000000000000
    cmp rdx, rax
    ja .oop_fail

.oop_unroll8:
    lea rax, [rcx + 8]
    cmp rax, rdx
    ja .oop_tail

    add rbx, 8
    add rcx, 8
    jmp .oop_unroll8

.oop_tail:
    cmp rcx, rdx
    jge .oop_loop_done
    inc rbx
    inc rcx
    jmp .oop_tail

.oop_loop_done:
    # Update last value of object c
    mov rax, rcx
    dec rax
    and rax, 1
    jnz 1f
    # Even: Counter2
    mov r8, [rsp + 32]
    jmp 2f
1:
    # Odd: Counter1
    mov r8, [rsp + 24]
2:
    mov r10, [rsp + 16]          # node_c
    mov [r10 + 8], r8

    mov r14, [rsp + 0]           # node_i
    mov r15, [rsp + 8]           # node_total

    cvtsi2sd xmm0, rbx
    cvtsi2sd xmm1, rcx

    movsd [r15 + 8], xmm0        # writeback total
    movsd [r14 + 8], xmm1        # writeback i

    movsd [rdi + 0 * 8], xmm0    # reg 0 = total
    movsd [rdi + 1 * 8], xmm1    # reg 1 = i
    movsd [rdi + 2 * 8], xmm0    # reg 2 = return val
    mov [rdi + 251 * 8], r8      # reg 251 = object c
    mov qword ptr [rip + val_sp], 0

    mov rax, [rsp + 40]          # exit_offset
    mov r9, [rdi + 70 * 8]
    lea rsi, [r9 + rax]
    add rsp, 48
    pop r8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    NEXT

.oop_fail:
    add rsp, 48
    pop r8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    mov r9, [rdi + 70 * 8]
    jmp .normal_jmp_o



op_jmp_f_o:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r10, [rsi+16]
    add rsi, 24
    mov rax, [rdi + rcx * 8]
    test rax, rax
    jz .do_jmp_f_o
    mov r11, 0x7FF8000000000000
    cmp rax, r11
    je .do_jmp_f_o
    add rax, rax
    jnz .no_jump_f_o
.do_jmp_f_o:
    mov r9, [rbx + r8 * 8]
    test r9, r9
    jnz 1f
    mov r9, [rdi + r8 * 8]
1:
    test r9, r9
    jz .no_jump_f_o
    lea rsi, [r9 + r10]
.no_jump_f_o:
    NEXT

op_store_i:
    mov r8,  [rsi]
    mov r9,  [rsi+8]
    mov r10, [rsi+16]
    add rsi, 24
    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .store_i_null
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0
    test rdx, rdx
    js .store_i_null
    movsd xmm0, [rdi + r10 * 8]
    cvttsd2si rcx, xmm0
    mov [rax + rdx], rcx
.store_i_null:
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
    cmp r11, 524280
    jae .call_stack_overflow
    lea r12, [rip + call_stack]
    mov [r12 + r11 * 8], rsi
    inc r11
    mov [r10], r11
    mov r9, [rbx + rcx * 8]
    test r9, r9
    jnz 1f
    mov r9, [rdi + rcx * 8]
1:
    test r9, r9
    jz .call_o_null
    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rax, xmm0
    test rax, rax
    jz .call_o_unresolved
    lea rsi, [r9 + rax]
    NEXT
.call_o_unresolved:
    dec r11
    mov [r10], r11
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    mov rcx, [rip + cli_source_file]
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + str_default_src]
2:
    xor edx, edx
    call report_runtime_unresolved
    mov rcx, 0
    call fflush
    mov ecx, 1
    call exit
.call_o_null:
    dec r11
    mov [r10], r11
    mov rsi, [r12 + r11 * 8]
    NEXT

op_call:
    mov rcx, [rsi]       # read label index
    add rsi, 8
    lea r8, [rip + call_sp]
    mov r9, [r8]         # r9 = call_sp
    cmp r9, 524280
    jae .call_stack_overflow
    cmp rcx, 524280
    jae .call_bad_label
    lea r10, [rip + call_stack]
    mov [r10 + r9 * 8], rsi # push next RIP
    inc r9
    mov [r8], r9
    lea r11, [rip + labels_array]
    mov rsi, [r11 + rcx * 8]
    NEXT
.call_bad_label:
    NEXT


op_lte:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    movsd xmm1, [rdi + r9 * 8]
    comisd xmm0, xmm1
    setbe al
    movzx eax, al
    neg rax
    mov r10, 0x3FF0000000000000
    and rax, r10
    mov [rdi + rcx * 8], rax
    NEXT

op_gte:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    movsd xmm1, [rdi + r9 * 8]
    comisd xmm0, xmm1
    setae al
    movzx eax, al
    neg rax
    mov r10, 0x3FF0000000000000
    and rax, r10
    mov [rdi + rcx * 8], rax
    NEXT

op_ret:
    mov r8, [rip + current_fiber_id]
    test r8, r8
    jnz .fiber_op_ret
    lea r8, [rip + call_sp]
    mov r9, [r8]         # r9 = call_sp
    test r9, r9
    jle .ret_underflow
    dec r9
    mov [r8], r9
    lea r10, [rip + call_stack]
    mov rsi, [r10 + r9 * 8]
    NEXT
.fiber_op_ret:
    lea rax, [rip + fiber_table]
    mov rcx, [rax + r8 * 8]
    mov r10, [rcx + 96]
    lea r8, [rip + call_sp]
    mov r9, [r8]
    cmp r9, r10
    jle .fiber_terminate
    dec r9
    mov [r8], r9
    lea r11, [rip + call_stack]
    mov rsi, [r11 + r9 * 8]
    NEXT
.ret_underflow:
    jmp vm_exit

op_push:
    mov rcx, [rsi]       # reg num
    add rsi, 8
    mov rax, [rdi + rcx * 8]
    mov r8, [rip + val_sp]
    cmp r8, 524280
    jae .val_stack_overflow
    lea r9, [rip + val_stack]
    mov [r9 + r8 * 8], rax
    inc r8
    mov [rip + val_sp], r8
    NEXT

op_pop:
    mov rcx, [rsi]
    add rsi, 8
    mov r8, [rip + val_sp]
    test r8, r8
    jle .val_stack_underflow
    dec r8
    mov [rip + val_sp], r8
    lea r9, [rip + val_stack]
    mov rax, [r9 + r8 * 8]
    mov [rdi + rcx * 8], rax
    mov [rbx + rcx * 8], rax
    NEXT

.val_stack_underflow:
    xor eax, eax
    mov [rdi + rcx * 8], rax
    mov [rbx + rcx * 8], rax
    NEXT

.call_stack_overflow:
    sub rsp, 40
    lea rcx, [rip + str_stack_overflow]
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    jmp vm_exit

.val_stack_overflow:
    sub rsp, 40
    lea rcx, [rip + str_val_stack_overflow]
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    jmp vm_exit

.try_stack_overflow:
    sub rsp, 40
    lea rcx, [rip + str_try_stack_overflow]
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    jmp vm_exit

.defer_stack_overflow:
    sub rsp, 40
    lea rcx, [rip + str_defer_stack_overflow]
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    jmp vm_exit

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
    mov r11, [rbx + r8 * 8]  # check ptr_bank first
    test r11, r11
    jnz 1f
    mov r11, [rdi + r8 * 8]  # fallback to float_bank
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
    mov rcx, [rsi]       # dest
    mov r8,  [rsi+8]     # src
    add rsi, 16
    sqrtsd xmm0, [rdi + r8 * 8]
    movsd [rdi + rcx * 8], xmm0
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
    mov rax, [rdi + r8 * 8]
    mov r10, 0x7FFFFFFFFFFFFFFF
    and rax, r10
    mov [rdi + rcx * 8], rax
    NEXT

op_exit:
    mov r8, [rsi]        # code_reg
    add rsi, 8
    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    call exit

op_mod:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # src1
    mov r9,  [rsi+16]    # src2
    add rsi, 24
    movsd xmm1, [rdi + r9 * 8]
    xorpd xmm2, xmm2
    ucomisd xmm1, xmm2
    jp .mod_do_op
    jne .mod_do_op
    jmp .err_div_zero
.mod_do_op:
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32
    movsd xmm0, [rdi + r8 * 8]
    call fmod
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_floor:
    mov rcx, [rsi]       # dest
    mov r8,  [rsi+8]     # src
    add rsi, 16
    roundsd xmm0, [rdi + r8 * 8], 1
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_ceil:
    mov rcx, [rsi]       # dest
    mov r8,  [rsi+8]     # src
    add rsi, 16
    roundsd xmm0, [rdi + r8 * 8], 2
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_str_len:
    mov rcx, [rsi]       # dest
    mov r8,  [rsi+8]     # src
    add rsi, 16
    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz .sl_have_ptr
    mov rax, [rdi + r8 * 8]
.sl_have_ptr:
    test rax, rax
    jz .sl_zero

    # Fast path 1: Inside arena
    mov r10, [rip + arena_base]
    cmp rax, r10
    jb .sl_check_page
    cmp rax, [rip + arena_limit]
    jb .sl_safe_tag

.sl_check_page:
    # Fast path 2: CRT GC heap block or interior of page
    cmp rax, 0x10000
    jb .sl_fallback_strlen
    mov r10, rax
    and r10, 0xFFF
    cmp r10, 32
    jb .sl_fallback_strlen

.sl_safe_tag:
    mov r10, 0x4152524159   # 'ARRAY'
    cmp [rax - 32], r10
    je .sl_fast_len
    mov r10, 0x535452494E47 # 'STRING'
    cmp [rax - 32], r10
    je .sl_fast_len
.sl_fallback_strlen:
    push rcx
    push rdi
    sub rsp, 40
    mov rcx, rax
    call strlen
    add rsp, 40
    pop rdi
    pop rcx
    cvtsi2sd xmm0, rax
    movsd [rdi + rcx * 8], xmm0
    NEXT
.sl_fast_len:
    movsd xmm0, [rax - 16]
    movsd [rdi + rcx * 8], xmm0
    NEXT
.sl_zero:
    xorps xmm0, xmm0
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_to_str:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # src
    add rsi, 16
    mov rax, [rdi + r8 * 8]

    push rsi
    push rdi
    push rbx
    push r12
    push rax             # slot at [rsp + 40]
    push rax             # slot at [rsp + 32] (padding / buffer holder)
    sub rsp, 32          # 48 + 32 = 80 bytes (16-byte aligned)

    mov rcx, 64
    xor edx, edx
    call gc_malloc
    mov [rsp + 32], rax  # save buffer pointer into stack slot

    mov r8, [rsp + 40]   # float bits from stack
    mov rcx, rax         # buffer pointer
    lea rdx, [rip + str_to_str_fmt]
    movq xmm2, r8
    call sprintf

    mov rax, [rsp + 32]  # restore buffer pointer
    mov rcx, rax
    call strlen
    mov r8, rax
    mov rax, [rsp + 32]
    mov [rax - 8], r8
    cvtsi2sd xmm0, r8
    movsd [rax - 16], xmm0
    mov r10, 0x535452494E47
    mov [rax - 32], r10

    add rsp, 48          # discard 32 shadow + 2 pushes
    pop r12              # restore dest reg
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

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
    test rax, rax
    jz .sc_s1_done
.sc_s1_len:
    cmp byte ptr [rax + r10], 0
    je .sc_s1_done
    inc r10
    cmp r10, 16777216
    jae .sc_s1_done
    jmp .sc_s1_len
.sc_s1_done:

    xor r11, r11
    test rdx, rdx
    jz .sc_s2_done
.sc_s2_len:
    cmp byte ptr [rdx + r11], 0
    je .sc_s2_done
    inc r11
    cmp r11, 16777216
    jae .sc_s2_done
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
    sub rsp, 32

    xor edx, edx
    call gc_malloc

    add rsp, 32
    pop r11
    pop r10
    pop rdx
    pop rcx
    pop r12
    pop rbx
    pop rdi
    pop rsi

    # SIMD Block Transfer for s1
    xor r8, r8
.sc_cp1_simd:
    lea r9, [r8 + 16]
    cmp r9, r10
    ja .sc_cp1_scalar
    movdqu xmm0, [rcx + r8]
    movdqu [rax + r8], xmm0
    add r8, 16
    jmp .sc_cp1_simd
.sc_cp1_scalar:
    cmp r8, r10
    je .sc_cp1_done
    mov r9b, [rcx + r8]
    mov [rax + r8], r9b
    inc r8
    jmp .sc_cp1_scalar
.sc_cp1_done:

    # SIMD Block Transfer for s2
    xor r8, r8
.sc_cp2_simd:
    lea r9, [r8 + 16]
    cmp r9, r11
    ja .sc_cp2_scalar
    movdqu xmm0, [rdx + r8]
    lea r13, [r10 + r8]
    movdqu [rax + r13], xmm0
    add r8, 16
    jmp .sc_cp2_simd
.sc_cp2_scalar:
    cmp r8, r11
    je .sc_cp2_done
    mov r9b, [rdx + r8]
    lea r13, [r10 + r8]
    mov [rax + r13], r9b
    inc r8
    jmp .sc_cp2_scalar
.sc_cp2_done:
    lea r13, [r10 + r11]
    mov byte ptr [rax + r13], 0
    mov r14, 0x535452494E47
    mov [rax - 32], r14
    mov [rax - 8], r13
    cvtsi2sd xmm0, r13
    movsd [rax - 16], xmm0

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_set_len:
    mov rcx, [rsi]       # ptr_reg
    mov r8,  [rsi+8]     # len_reg
    add rsi, 16
    mov rax, [rbx + rcx * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + rcx * 8]
1:
    test rax, rax
    jz 2f
    mov r10, 0x4152524159
    mov [rax - 32], r10
    movsd xmm0, [rdi + r8 * 8]
    movsd [rax - 16], xmm0
    cvttsd2si r11, xmm0
    mov [rax - 8], r11
2:
    NEXT

op_array_push:
    mov rcx, [rsi]       # dest
    mov r8,  [rsi+8]     # arr_reg
    mov r9,  [rsi+16]    # val_reg
    add rsi, 24
    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .ap_null

    mov rdx, [rax - 8]   # rdx = current integer length
    test rdx, rdx
    js .ap_null

    mov r10, [rax - 24]  # r10 = capacity in bytes
    lea r11, [rdx * 8 + 8] # r11 = needed bytes
    cmp r11, r10
    jbe .ap_has_cap

    # Capacity exceeded: geometric reallocation
    mov r13, r10
    shl r13, 1           # double capacity
    cmp r13, r11
    jae .ap_cap_ok
    mov r13, r11
.ap_cap_ok:
    cmp r13, 64
    jae .ap_cap_min_ok
    mov r13, 64
.ap_cap_min_ok:

    push rsi
    push rdi
    push rbx
    push rcx             # dest reg
    push r8              # arr_reg
    push r9              # val_reg
    push rdx             # current len
    push rax             # old array ptr
    push r13             # new capacity
    sub rsp, 40          # 16-byte stack alignment + shadow space (9*8 + 40 = 112)

    mov rcx, r13         # requested size
    mov rdx, 3           # type tag 3 (Array)
    call gc_malloc

    add rsp, 40
    pop r13
    pop r11              # old array ptr
    pop rdx
    pop r9
    pop r8
    pop rcx
    pop rbx
    pop rdi
    pop rsi

    mov r10, 0x4152524159
    mov [rax - 32], r10  # type tag
    mov [rax - 24], r13  # capacity in bytes
    mov [rax - 8], rdx
    cvtsi2sd xmm1, rdx
    movsd [rax - 16], xmm1

    # Copy old elements
    test rdx, rdx
    jle .ap_copy_done
    xor r10, r10
.ap_copy_loop:
    mov r14, [r11 + r10 * 8]
    mov [rax + r10 * 8], r14
    inc r10
    cmp r10, rdx
    jl .ap_copy_loop
.ap_copy_done:

    # Update array pointer in VM registers
    mov [rbx + r8 * 8], rax
    mov [rdi + r8 * 8], rax

.ap_has_cap:
    mov r10, [rbx + r9 * 8]
    test r10, r10
    jnz 2f
    mov r10, [rdi + r9 * 8]
2:
    mov [rax + rdx * 8], r10
    inc rdx
    mov [rax - 8], rdx
    cvtsi2sd xmm1, rdx
    movsd [rax - 16], xmm1
    mov [rdi + rcx * 8], rax
    mov [rbx + rcx * 8], rax
    NEXT

.ap_null:
    mov qword ptr [rdi + rcx * 8], 0
    mov qword ptr [rbx + rcx * 8], 0
    NEXT

op_array_pop:
    mov rcx, [rsi]       # dest
    mov r8,  [rsi+8]     # arr_reg
    add rsi, 16
    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .ap_empty
    movsd xmm0, [rax - 16]
    cvttsd2si rdx, xmm0
    test rdx, rdx
    jle .ap_empty
    dec rdx
    mov [rax - 8], rdx
    cvtsi2sd xmm1, rdx
    movsd [rax - 16], xmm1
    mov r10, [rax + rdx * 8]
    mov [rdi + rcx * 8], r10
    mov [rbx + rcx * 8], r10
    NEXT
.ap_empty:
    xorps xmm0, xmm0
    movsd [rdi + rcx * 8], xmm0
    mov qword ptr [rbx + rcx * 8], 0
    NEXT

op_str_sub:
    mov rcx, [rsi]       # dest
    mov r8,  [rsi+8]     # str_reg
    mov r9,  [rsi+16]    # start_reg
    mov r10, [rsi+24]    # end_reg
    add rsi, 32
    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .str_sub_empty
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si r11, xmm0
    test r11, r11
    jns 2f
    xor r11, r11
2:
    movsd xmm1, [rdi + r10 * 8]
    cvttsd2si r12, xmm1
    cmp r12, r11
    jle .str_sub_empty
    mov r13, r12
    sub r13, r11
    push rsi
    push rdi
    push rbx
    push r11
    push r12
    push r13
    push rax
    push rcx
    sub rsp, 32
    lea rcx, [r13 + 1]
    xor rdx, rdx
    call gc_malloc
    mov rdx, rax
    add rsp, 32
    pop rcx
    pop rax
    pop r13
    pop r12
    pop r11
    pop rbx
    pop rdi
    pop rsi
    lea r14, [rax + r11]
    xor r15, r15
.ss_copy:
    cmp r15, r13
    jae .ss_done
    mov r10b, byte ptr [r14 + r15]
    test r10b, r10b
    jz .ss_early_null
    mov byte ptr [rdx + r15], r10b
    inc r15
    jmp .ss_copy
.ss_early_null:
    mov r13, r15
.ss_done:
    mov byte ptr [rdx + r13], 0
    mov r10, 0x535452494E47
    mov [rdx - 32], r10
    mov [rdx - 8], r13
    cvtsi2sd xmm0, r13
    movsd [rdx - 16], xmm0
    mov [rbx + rcx * 8], rdx
    mov [rdi + rcx * 8], rdx
    NEXT
.str_sub_empty:
    push rsi
    push rdi
    push rbx
    push rcx
    sub rsp, 32
    mov rcx, 1
    xor rdx, rdx
    call gc_malloc
    add rsp, 32
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    mov byte ptr [rax], 0
    mov r10, 0x535452494E47
    mov [rax - 32], r10
    mov qword ptr [rax - 8], 0
    xorps xmm0, xmm0
    movsd [rax - 16], xmm0
    mov [rbx + rcx * 8], rax
    mov [rdi + rcx * 8], rax
    NEXT

op_fclose:
    mov r8, [rsi]        # reg number
    add rsi, 8
    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .fclose_done
    push rsi
    push rdi
    push rbx
    push r8
    sub rsp, 32
    mov rcx, rax
    call fclose
    add rsp, 32
    pop r8
    pop rbx
    pop rdi
    pop rsi
    # Zero out register to prevent double-free and use-after-free
    mov qword ptr [rbx + r8 * 8], 0
    mov qword ptr [rdi + r8 * 8], 0
.fclose_done:
    NEXT

op_fread:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # file_reg
    mov r9,  [rsi+16]    # size_reg
    add rsi, 24
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si r13, xmm0  # size
    test r13, r13
    jle .fread_empty

    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .fread_empty

    push rsi
    push rdi
    push rbx
    push r8
    push r13
    push r12
    sub rsp, 32
    lea rcx, [r13 + 1]
    xor rdx, rdx
    call gc_malloc
    add rsp, 32
    pop r12
    pop r13
    pop r8
    pop rbx
    pop rdi
    pop rsi

    push rsi
    push rdi
    push rbx
    push rax
    push r12
    sub rsp, 40
    mov r9, [rbx + r8 * 8]      # arg4: FILE*
    test r9, r9
    jnz 2f
    mov r9, [rdi + r8 * 8]
2:
    mov rcx, rax                # arg1: buf
    mov rdx, 1                  # arg2: size
    mov r8, r13                 # arg3: count
    call fread
    add rsp, 40
    pop r12
    pop rax
    pop rbx
    pop rdi
    pop rsi
    mov byte ptr [rax + r13], 0
    mov r10, 0x535452494E47
    mov [rax - 32], r10
    mov [rax - 8], r13
    cvtsi2sd xmm0, r13
    movsd [rax - 16], xmm0
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

.fread_empty:
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32
    mov rcx, 1
    xor rdx, rdx
    call gc_malloc
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi
    mov byte ptr [rax], 0
    mov r10, 0x535452494E47
    mov [rax - 32], r10
    mov qword ptr [rax - 8], 0
    xorps xmm0, xmm0
    movsd [rax - 16], xmm0
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_fwrite:
    mov r8, [rsi]        # file_reg
    mov r9, [rsi+8]      # str_reg
    add rsi, 16
    mov rcx, [rbx + r9 * 8]     # str ptr
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r9 * 8]
1:
    test rcx, rcx
    jz .fwrite_done
    mov rdx, [rbx + r8 * 8]     # FILE*
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r8 * 8]
2:
    test rdx, rdx
    jz .fwrite_done
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    call fputs
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
.fwrite_done:
    NEXT

op_file_read_text:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # path_reg
    add rsi, 16
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 64
    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jz .frt_empty
    lea rdx, [rip + read_bin_mode] # "rb"
    call fopen
    test rax, rax
    jz .frt_empty
    mov [rsp + 32], rax         # [rsp + 32] = FILE*
    mov rcx, rax
    xor rdx, rdx
    mov r8, 2                   # SEEK_END
    call fseek
    mov rcx, [rsp + 32]
    call ftell
    cmp rax, 0
    jl .frt_fail
    mov [rsp + 40], rax         # [rsp + 40] = file size
    mov rcx, [rsp + 32]
    xor rdx, rdx
    xor r8, r8                  # SEEK_SET
    call fseek

    # Allocate buffer: size + 1
    mov rcx, [rsp + 40]
    inc rcx
    xor rdx, rdx
    call gc_malloc
    mov [rsp + 48], rax         # [rsp + 48] = buffer

    mov rcx, rax                # arg1: buf
    mov rdx, 1                  # arg2: size
    mov r8, [rsp + 40]          # arg3: count (file size)
    mov r9, [rsp + 32]          # arg4: FILE*
    call fread
    mov r8, rax                 # actual read count

    mov rax, [rsp + 48]
    mov byte ptr [rax + r8], 0  # null-terminate
    mov r10, 0x535452494E47     # "STRING" tag
    mov [rax - 32], r10
    mov [rax - 8], r8
    cvtsi2sd xmm0, r8
    movsd [rax - 16], xmm0

    mov rcx, [rsp + 32]         # FILE*
    call fclose

    mov rax, [rsp + 48]
    add rsp, 64
    pop r12
    pop rbx
    pop rdi
    pop rsi
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

.frt_fail:
    mov rcx, [rsp + 32]
    call fclose
.frt_empty:
    mov rcx, 1
    xor rdx, rdx
    call gc_malloc
    mov byte ptr [rax], 0
    mov r10, 0x535452494E47
    mov [rax - 32], r10
    mov qword ptr [rax - 8], 0
    xorps xmm0, xmm0
    movsd [rax - 16], xmm0
    add rsp, 64
    pop r12
    pop rbx
    pop rdi
    pop rsi
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_file_write_text:
    mov r8, [rsi]        # path_reg
    mov r9, [rsi+8]      # text_reg
    add rsi, 16
    mov rcx, [rbx + r8 * 8]     # path
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    mov rdx, [rbx + r9 * 8]     # text
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r9 * 8]
2:
    test rcx, rcx
    jz .fwt_done
    test rdx, rdx
    jz .fwt_done
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 48
    mov [rsp + 40], rdx         # save text ptr in local slot
    lea rdx, [rip + write_bin_mode] # "wb"
    call fopen
    test rax, rax
    jz .fwt_fail
    mov [rsp + 32], rax         # save FILE* in local slot
    mov rcx, [rsp + 40]         # text ptr (arg1 for strlen)
    call strlen
    mov r8, rax                 # count
    mov rcx, [rsp + 40]         # text ptr (arg1 for fwrite)
    mov rdx, 1                  # size
    mov r9, [rsp + 32]          # FILE*
    call fwrite
    mov rcx, [rsp + 32]         # FILE*
    call fclose
.fwt_fail:
    add rsp, 48
    pop r12
    pop rbx
    pop rdi
    pop rsi
.fwt_done:
    NEXT

op_array_slice:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # arr_reg
    mov r9,  [rsi+16]    # start_reg
    mov r10, [rsi+24]    # end_reg
    add rsi, 32

    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .slice_empty
    mov r14, rax                 # r14 = original array ptr

    movsd xmm0, [r14 - 16]       # array length (double)
    cvttsd2si r11, xmm0          # r11 = arr_len

    movsd xmm1, [rdi + r9 * 8]   # start
    cvttsd2si r13, xmm1          # r13 = start

    movsd xmm2, [rdi + r10 * 8]  # end
    cvttsd2si r10, xmm2          # r10 = end

    # clamp start: if start < 0 -> start = 0
    test r13, r13
    jge 2f
    xor r13, r13
2:
    # clamp end: if end > arr_len -> end = arr_len
    cmp r10, r11
    jle 3f
    mov r10, r11
3:
    # if end <= start -> empty slice
    cmp r10, r13
    jle .slice_empty

    mov r15, r10
    sub r15, r13                 # r15 = new_len (count)

    # Inlined bump-allocation fast path
    lea rcx, [r15 * 8]           # requested payload size
    lea r8, [rcx + 63]
    and r8, -16                  # total aligned chunk
    mov rax, [rip + arena_bump]
    test rax, rax
    jz .slice_alloc_slow
    lea r9, [rax + r8]
    cmp r9, [rip + arena_limit]
    ja .slice_alloc_slow

    # Fast bump success!
    mov [rip + arena_bump], r9
    mov qword ptr [rax], 0
    lea r10, [rip + alloc_head]
    mov r11, [r10]
    mov [rax + 8], r11
    mov [r10], rax
    mov qword ptr [rax + 16], 3
    mov [rax + 24], rcx
    add rax, 48                  # payload pointer
    jmp .slice_alloc_done

.slice_alloc_slow:
    push rsi
    push rdi
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 40
    mov rdx, 3
    call gc_malloc
    add rsp, 40
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rdi
    pop rsi

.slice_alloc_done:
    # rax = new array buffer ptr
    mov r10, 0x4152524159
    mov [rax - 32], r10          # "ARRAY" type tag
    cvtsi2sd xmm0, r15
    movsd [rax - 16], xmm0       # length
    mov [rax - 8], r15           # integer length

    # Copy elements using r8 (src), r9 (dst), rcx (count) - no rsi/rdi spills
    lea r8, [r14 + r13 * 8]
    mov r9, rax
    mov rcx, r15
.slice_simd_loop:
    cmp rcx, 8
    jb .slice_simd_tail
    movdqu xmm0, [r8]
    movdqu xmm1, [r8 + 16]
    movdqu xmm2, [r8 + 32]
    movdqu xmm3, [r8 + 48]
    movdqu [r9], xmm0
    movdqu [r9 + 16], xmm1
    movdqu [r9 + 32], xmm2
    movdqu [r9 + 48], xmm3
    add r8, 64
    add r9, 64
    sub rcx, 8
    jmp .slice_simd_loop
.slice_simd_tail:
    cmp rcx, 2
    jb .slice_simd_final
    movdqu xmm0, [r8]
    movdqu [r9], xmm0
    add r8, 16
    add r9, 16
    sub rcx, 2
    jmp .slice_simd_tail
.slice_simd_final:
    test rcx, rcx
    jz .slice_simd_done
    mov r10, [r8]
    mov [r9], r10
.slice_simd_done:
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

.slice_empty:
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32                  # 4 pushes (32) + 32 = 64 (0 mod 16) - ALIGNED
    mov rcx, 0
    mov rdx, 3
    call gc_malloc
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov r10, 0x4152524159
    mov [rax - 32], r10
    xorps xmm0, xmm0
    movsd [rax - 16], xmm0
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_str_contains:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # str_reg
    mov r9,  [rsi+16]    # sub_reg
    add rsi, 24

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    mov rdx, [rbx + r9 * 8]
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r9 * 8]
2:
    test rcx, rcx
    jz .sc_false
    test rdx, rdx
    jz .sc_false

    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32                  # 4 pushes = 32 + 32 = 64 (0 mod 16) - ALIGNED
    call strstr
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi

    test rax, rax
    jz .sc_false
    mov rax, 0x3FF0000000000000
    mov [rdi + r12 * 8], rax     # 1.0 (true)
    NEXT
.sc_false:
    mov qword ptr [rdi + r12 * 8], 0  # 0.0 (false)
    NEXT

op_str_index_of:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # str_reg
    mov r9,  [rsi+16]    # sub_reg
    add rsi, 24

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    mov rdx, [rbx + r9 * 8]
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r9 * 8]
2:
    test rcx, rcx
    jz .sio_not_found
    test rdx, rdx
    jz .sio_not_found

    push rsi
    push rdi
    push rbx
    push r12
    push rcx                     # save original string ptr
    sub rsp, 40                  # 5 pushes = 40 + 40 = 80 (0 mod 16) - ALIGNED
    call strstr
    add rsp, 40
    pop rcx
    pop r12
    pop rbx
    pop rdi
    pop rsi

    test rax, rax
    jz .sio_not_found
    sub rax, rcx                 # rax = index offset
    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT
.sio_not_found:
    mov rax, 0xBFF0000000000000  # -1.0 as double IEEE 754
    mov [rdi + r12 * 8], rax
    NEXT

op_str_split:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # str_reg
    mov r9,  [rsi+16]    # delim_reg
    add rsi, 24

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    mov rdx, [rbx + r9 * 8]
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r9 * 8]
2:
    test rcx, rcx
    jz .split_empty

    test rdx, rdx
    jz .split_delim_default
    mov dl, byte ptr [rdx]
    test dl, dl
    jnz 3f
.split_delim_default:
    mov dl, ' '                  # default ' '
3:
    # First pass: count tokens
    xor r10, r10                 # token count
    mov r11, rcx                 # scan ptr
.split_count_loop:
    inc r10
.split_find_delim:
    mov al, byte ptr [r11]
    test al, al
    jz .split_count_done
    cmp al, dl
    je .split_found_delim
    inc r11
    jmp .split_find_delim
.split_found_delim:
    inc r11
    jmp .split_count_loop

.split_count_done:
    # Allocate array: size = r10 * 8, type = 3
    push rsi
    push rdi
    push rbx
    push r12
    push rcx                     # str ptr
    push rdx                     # delim (dl)
    push r10                     # token count
    sub rsp, 40                  # 7 pushes = 56 + 40 = 96 (0 mod 16) - ALIGNED
    lea rcx, [r10 * 8]
    mov rdx, 3
    call gc_malloc
    add rsp, 40
    pop r10                      # token count
    pop rdx                      # delim in dl
    pop rcx                      # str ptr
    pop r12                      # dest reg
    pop rbx
    pop rdi
    pop rsi

    # rax = array ptr
    mov r11, 0x4152524159
    mov [rax - 32], r11
    cvtsi2sd xmm0, r10
    movsd [rax - 16], xmm0       # set array length
    mov [rax - 8], r10           # fast integer array length
    mov [rbx + r12 * 8], rax     # protect array from GC in register bank
    mov [rdi + r12 * 8], rax

    # Push state to extract tokens
    push rsi
    push rdi
    push rbx
    push r12
    push rax                     # [rsp + 24] = array ptr
    push rcx                     # [rsp + 16] = token start ptr
    push rdx                     # [rsp + 8]  = delim
    push r10                     # [rsp + 0]  = token count
    sub rsp, 32                  # 8 pushes = 64 + 32 = 96 (0 mod 16) - ALIGNED

    xor r14, r14                 # token index = 0
    mov r13, [rsp + 48]          # current token start

.split_extract_loop:
    cmp r14, [rsp + 32]          # compare with token count
    jae .split_extract_done

    mov dl, byte ptr [rsp + 40]  # delim

    # Find length of this token
    xor r15, r15
.split_find_tok_end:
    mov al, byte ptr [r13 + r15]
    test al, al
    jz .split_tok_len_found
    cmp al, dl
    je .split_tok_len_found
    inc r15
    jmp .split_find_tok_end

.split_tok_len_found:
    # r15 = token len
    lea r8, [r13 + r15]
    cmp byte ptr [r8], 0
    jz 4f
    inc r8                       # skip delim
4:
    mov [rsp + 48], r8           # update next token start ptr

    # Allocate new string for this token: r15 + 1 bytes
    push r13                     # save token start
    push r14                     # save token index
    push r15                     # save token len
    sub rsp, 40                  # 3 pushes = 24 + 40 = 64 (0 mod 16) - ALIGNED
    lea rcx, [r15 + 1]
    xor rdx, rdx
    call gc_malloc
    add rsp, 40
    pop r15                      # token len
    pop r14                      # token index
    pop r13                      # token start

    # Copy characters from r13 to rax
    xor r8, r8
.split_cp:
    cmp r8, r15
    jae .split_cp_done
    mov r9b, byte ptr [r13 + r8]
    mov byte ptr [rax + r8], r9b
    inc r8
    jmp .split_cp
.split_cp_done:
    mov byte ptr [rax + r15], 0  # null-terminate
    mov r10, 0x535452494E47
    mov [rax - 32], r10
    cvtsi2sd xmm0, r15
    movsd [rax - 16], xmm0
    mov [rax - 8], r15

    # Store token into array:
    mov r11, [rsp + 56]          # array ptr
    mov [r11 + r14 * 8], rax
    inc r14

    # Advance to next token
    mov r13, [rsp + 48]
    jmp .split_extract_loop

.split_extract_done:
    mov rax, [rsp + 56]          # array ptr
    add rsp, 64                  # 32 shadow + 32 locals
    pop r12
    pop rbx
    pop rdi
    pop rsi
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

.split_empty:
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32
    mov rcx, 0
    mov rdx, 3
    call gc_malloc
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi
    mov r11, 0x4152524159
    mov [rax - 32], r11
    xorps xmm0, xmm0
    movsd [rax - 16], xmm0
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_str_to_upper:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # str_reg
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jz .stu_empty

    xor r13, r13
.stu_len:
    cmp byte ptr [rcx + r13], 0
    je .stu_len_done
    inc r13
    jmp .stu_len
.stu_len_done:
    push rsi
    push rdi
    push rbx
    push r12
    push rcx                     # original str
    push r13                     # len
    sub rsp, 48                  # 6 pushes = 48 + 48 = 96 (0 mod 16) - ALIGNED
    lea rcx, [r13 + 1]
    xor rdx, rdx
    call gc_malloc
    add rsp, 48
    pop r13                      # len
    pop rcx                      # original str
    pop r12                      # dest
    pop rbx
    pop rdi
    pop rsi

    mov rdx, rax                 # new buffer in rdx
    xor r14, r14
.stu_loop:
    cmp r14, r13
    jae .stu_done
    mov r10b, byte ptr [rcx + r14]
    cmp r10b, 'a'
    jb .stu_store
    cmp r10b, 'z'
    ja .stu_store
    sub r10b, 32
.stu_store:
    mov byte ptr [rdx + r14], r10b
    inc r14
    jmp .stu_loop
.stu_done:
    mov byte ptr [rdx + r13], 0
    mov [rbx + r12 * 8], rdx
    mov [rdi + r12 * 8], rdx
    NEXT

.stu_empty:
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32
    mov rcx, 1
    xor rdx, rdx
    call gc_malloc
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi
    mov byte ptr [rax], 0
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_str_to_lower:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # str_reg
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jz .stl_empty

    xor r13, r13
.stl_len:
    cmp byte ptr [rcx + r13], 0
    je .stl_len_done
    inc r13
    jmp .stl_len
.stl_len_done:
    push rsi
    push rdi
    push rbx
    push r12
    push rcx                     # original str
    push r13                     # len
    sub rsp, 48                  # 6 pushes = 48 + 48 = 96 (0 mod 16) - ALIGNED
    lea rcx, [r13 + 1]
    xor rdx, rdx
    call gc_malloc
    add rsp, 48
    pop r13                      # len
    pop rcx                      # original str
    pop r12                      # dest
    pop rbx
    pop rdi
    pop rsi

    mov rdx, rax                 # new buffer in rdx
    xor r14, r14
.stl_loop:
    cmp r14, r13
    jae .stl_done
    mov r10b, byte ptr [rcx + r14]
    cmp r10b, 'A'
    jb .stl_store
    cmp r10b, 'Z'
    ja .stl_store
    add r10b, 32
.stl_store:
    mov byte ptr [rdx + r14], r10b
    inc r14
    jmp .stl_loop
.stl_done:
    mov byte ptr [rdx + r13], 0
    mov [rbx + r12 * 8], rdx
    mov [rdi + r12 * 8], rdx
    NEXT

.stl_empty:
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32
    mov rcx, 1
    xor rdx, rdx
    call gc_malloc
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi
    mov byte ptr [rax], 0
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_dict_has_key:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # dict_reg
    mov r9,  [rsi+16]    # key_reg
    add rsi, 24

    mov rcx, [rbx + r8 * 8]      # dict_ptr
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    mov rdx, [rbx + r9 * 8]      # key_str
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r9 * 8]
2:
    test rcx, rcx
    jz .dhk_false
    test rdx, rdx
    jz .dhk_false

    mov r10, [rcx + 8]           # list head
.dhk_loop:
    test r10, r10
    jz .dhk_false
    mov rax, [r10]               # node key
    cmp rax, rdx
    je .dhk_true

    mov r11, 0x7FF0000000000000
    test rax, r11
    jnz 1f
    test rdx, r11
    jnz 1f
    cmp rax, 0x10000
    jb 1f
    cmp rdx, 0x10000
    jb 1f
    mov r11, 0x00007FFFFFFFFFFF
    cmp rax, r11
    ja 1f
    cmp rdx, r11
    ja 1f
    push r10
    push rdx
    mov r8, rax
.dhk_cmp:
    mov al, [r8]
    mov cl, [rdx]
    cmp al, cl
    jne .dhk_mismatch
    test al, al
    jz .dhk_match
    inc r8
    inc rdx
    jmp .dhk_cmp
.dhk_match:
    pop rdx
    pop r10
    jmp .dhk_true
.dhk_mismatch:
    pop rdx
    pop r10
1:
    mov r10, [r10 + 16]          # next node
    jmp .dhk_loop

.dhk_true:
    mov rax, 0x3FF0000000000000
    mov [rdi + r12 * 8], rax     # 1.0
    NEXT
.dhk_false:
    mov qword ptr [rdi + r12 * 8], 0  # 0.0
    NEXT

op_dict_keys:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # dict_reg
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jz .dkeys_empty

    xor r10, r10
    mov r11, [rcx + 8]           # list head
.dkeys_count:
    test r11, r11
    jz .dkeys_alloc
    inc r10
    mov r11, [r11 + 16]
    jmp .dkeys_count

.dkeys_alloc:
    push rsi
    push rdi
    push rbx
    push r12
    push rcx                     # dict_ptr
    push r10                     # node count
    sub rsp, 48                  # 6 pushes = 48 + 48 = 96 (0 mod 16) - ALIGNED
    lea rcx, [r10 * 8]
    mov rdx, 3                   # array type
    call gc_malloc
    add rsp, 48
    pop r10
    pop rcx
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov r11, 0x4152524159
    mov [rax - 32], r11
    cvtsi2sd xmm0, r10
    movsd [rax - 16], xmm0       # set length

    xor r8, r8
    mov r11, [rcx + 8]           # list head
.dkeys_fill:
    test r11, r11
    jz .dkeys_done
    mov r9, [r11]                # node key
    mov [rax + r8 * 8], r9       # array[i] = key
    inc r8
    mov r11, [r11 + 16]
    jmp .dkeys_fill

.dkeys_done:
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

.dkeys_empty:
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32
    mov rcx, 0
    mov rdx, 3
    call gc_malloc
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi
    mov r11, 0x4152524159
    mov [rax - 32], r11
    xorps xmm0, xmm0
    movsd [rax - 16], xmm0
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_dict_values:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # dict_reg
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jz .dvals_empty

    xor r10, r10
    mov r11, [rcx + 8]           # list head
.dvals_count:
    test r11, r11
    jz .dvals_alloc
    inc r10
    mov r11, [r11 + 16]
    jmp .dvals_count

.dvals_alloc:
    push rsi
    push rdi
    push rbx
    push r12
    push rcx                     # dict_ptr
    push r10                     # node count
    sub rsp, 48                  # 6 pushes = 48 + 48 = 96 (0 mod 16) - ALIGNED
    lea rcx, [r10 * 8]
    mov rdx, 3                   # array type
    call gc_malloc
    add rsp, 48
    pop r10
    pop rcx
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov r11, 0x4152524159
    mov [rax - 32], r11
    cvtsi2sd xmm0, r10
    movsd [rax - 16], xmm0       # set length

    xor r8, r8
    mov r11, [rcx + 8]           # list head
.dvals_fill:
    test r11, r11
    jz .dvals_done
    mov r9, [r11 + 8]            # node val
    mov [rax + r8 * 8], r9       # array[i] = val
    inc r8
    mov r11, [r11 + 16]
    jmp .dvals_fill

.dvals_done:
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

.dvals_empty:
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32
    mov rcx, 0
    mov rdx, 3
    call gc_malloc
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi
    mov r11, 0x4152524159
    mov [rax - 32], r11
    xorps xmm0, xmm0
    movsd [rax - 16], xmm0
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

# -------------------------------------------------------------
# sha256_compute(const char* data, size_t len, char* out_hex_65)
# Windows x64 ABI: rcx = data, rdx = len, r8 = out_hex
# -------------------------------------------------------------
.globl sha256_compute
sha256_compute:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 408

    mov r12, rcx
    mov r13, rdx
    mov r14, r8

    lea rax, [r13 + 8]
    shr rax, 6
    inc rax
    shl rax, 6
    mov r15, rax

    mov rcx, r15
    mov rdx, 1
    sub rsp, 32
    call calloc
    add rsp, 32
    mov rbx, rax

    test r13, r13
    jz .csha_no_copy
    mov rcx, rbx
    mov rdx, r12
    mov r8, r13
    sub rsp, 32
    call memcpy
    add rsp, 32
.csha_no_copy:
    mov byte ptr [rbx + r13], 0x80

    mov rax, r13
    shl rax, 3
    bswap rax
    mov [rbx + r15 - 8], rax

    lea rdi, [rbp - 112]
    mov dword ptr [rdi],      0x6a09e667
    mov dword ptr [rdi + 4],  0xbb67ae85
    mov dword ptr [rdi + 8],  0x3c6ef372
    mov dword ptr [rdi + 12], 0xa54ff53a
    mov dword ptr [rdi + 16], 0x510e527f
    mov dword ptr [rdi + 20], 0x9b05688c
    mov dword ptr [rdi + 24], 0x1f83d9ab
    mov dword ptr [rdi + 28], 0x5be0cd19

    xor rsi, rsi
.csha_block_loop:
    cmp rsi, r15
    jae .csha_blocks_done

    lea rcx, [rbp - 368]

    xor eax, eax
.csha_load_w:
    cmp eax, 16
    jae .csha_expand_w
    lea rdx, [rbx + rsi]
    mov edx, [rdx + rax * 4]
    bswap edx
    mov [rcx + rax * 4], edx
    inc eax
    jmp .csha_load_w

.csha_expand_w:
    mov eax, 16
.csha_exp_loop:
    cmp eax, 64
    jae .csha_init_vars

    mov edx, [rcx + rax * 4 - 8]
    mov r8d, edx
    ror r8d, 17
    mov r9d, edx
    ror r9d, 19
    xor r8d, r9d
    shr edx, 10
    xor r8d, edx

    mov edx, [rcx + rax * 4 - 60]
    mov r9d, edx
    ror r9d, 7
    mov r10d, edx
    ror r10d, 18
    xor r9d, r10d
    shr edx, 3
    xor r9d, edx

    add r8d, [rcx + rax * 4 - 28]
    add r8d, r9d
    add r8d, [rcx + rax * 4 - 64]
    mov [rcx + rax * 4], r8d

    inc eax
    jmp .csha_exp_loop

.csha_init_vars:
    lea rdi, [rbp - 112]
    lea r8,  [rbp - 80]
    mov eax, [rdi]
    mov [r8], eax
    mov eax, [rdi + 4]
    mov [r8 + 4], eax
    mov eax, [rdi + 8]
    mov [r8 + 8], eax
    mov eax, [rdi + 12]
    mov [r8 + 12], eax
    mov eax, [rdi + 16]
    mov [r8 + 16], eax
    mov eax, [rdi + 20]
    mov [r8 + 20], eax
    mov eax, [rdi + 24]
    mov [r8 + 24], eax
    mov eax, [rdi + 28]
    mov [r8 + 28], eax

    xor eax, eax
.csha_round_loop:
    cmp eax, 64
    jae .csha_round_done

    mov edx, [r8 + 16]
    mov r9d, edx
    ror r9d, 6
    mov r10d, edx
    ror r10d, 11
    xor r9d, r10d
    mov r10d, edx
    ror r10d, 25
    xor r9d, r10d

    mov r10d, [r8 + 20]
    and r10d, edx
    mov r11d, edx
    not r11d
    and r11d, [r8 + 24]
    xor r10d, r11d

    mov edx, [r8 + 28]
    add edx, r9d
    add edx, r10d
    lea r11, [rip + sha256_k]
    add edx, [r11 + rax * 4]
    lea r11, [rbp - 368]
    add edx, [r11 + rax * 4]

    mov r9d, [r8]
    mov r10d, r9d
    ror r10d, 2
    mov r11d, r9d
    ror r11d, 13
    xor r10d, r11d
    mov r11d, r9d
    ror r11d, 22
    xor r10d, r11d

    mov r9d, [r8]
    mov r11d, [r8 + 4]
    mov ecx, [r8 + 8]

    mov r13d, r9d
    and r13d, r11d
    mov r12d, r9d
    and r12d, ecx
    xor r13d, r12d
    mov r12d, r11d
    and r12d, ecx
    xor r13d, r12d

    add r10d, r13d

    mov ecx, [r8 + 24]
    mov [r8 + 28], ecx
    mov ecx, [r8 + 20]
    mov [r8 + 24], ecx
    mov ecx, [r8 + 16]
    mov [r8 + 20], ecx

    mov ecx, [r8 + 12]
    add ecx, edx
    mov [r8 + 16], ecx

    mov ecx, [r8 + 8]
    mov [r8 + 12], ecx
    mov ecx, [r8 + 4]
    mov [r8 + 8], ecx
    mov ecx, [r8]
    mov [r8 + 4], ecx

    add edx, r10d
    mov [r8], edx

    inc eax
    jmp .csha_round_loop

.csha_round_done:
    lea rdi, [rbp - 112]
    lea r8,  [rbp - 80]
    xor eax, eax
.csha_add_h:
    cmp eax, 8
    jae .csha_next_block
    mov edx, [rdi + rax * 4]
    add edx, [r8 + rax * 4]
    mov [rdi + rax * 4], edx
    inc eax
    jmp .csha_add_h

.csha_next_block:
    add rsi, 64
    jmp .csha_block_loop

.csha_blocks_done:
    mov rcx, rbx
    sub rsp, 32
    call free
    add rsp, 32

    lea r9, [rip + hex_chars_lower]
    lea rdi, [rbp - 112]
    xor eax, eax
    xor r8, r8
.csha_fmt_loop:
    cmp eax, 8
    jae .csha_fmt_done
    mov edx, [rdi + rax * 4]
    mov ecx, edx
    shr ecx, 24
    call .csha_write_hex_byte
    mov ecx, edx
    shr ecx, 16
    call .csha_write_hex_byte
    mov ecx, edx
    shr ecx, 8
    call .csha_write_hex_byte
    mov ecx, edx
    call .csha_write_hex_byte

    inc eax
    jmp .csha_fmt_loop

.csha_write_hex_byte:
    mov r10d, ecx
    shr r10d, 4
    and r10d, 0x0F
    mov r11b, [r9 + r10]
    mov [r14 + r8], r11b
    inc r8
    mov r10d, ecx
    and r10d, 0x0F
    mov r11b, [r9 + r10]
    mov [r14 + r8], r11b
    inc r8
    ret

.csha_fmt_done:
    mov byte ptr [r14 + 64], 0

    add rsp, 408
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rsi
    pop rbx
    pop rbp
    ret

# -------------------------------------------------------------
# md5_compute(const char* data, size_t len, char* out_hex_33)
# Windows x64 ABI: rcx = data, rdx = len, r8 = out_hex
# -------------------------------------------------------------
.globl md5_compute
md5_compute:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 136

    mov r12, rcx
    mov r13, rdx
    mov r14, r8

    lea rax, [r13 + 8]
    shr rax, 6
    inc rax
    shl rax, 6
    mov r15, rax

    mov rcx, r15
    mov rdx, 1
    sub rsp, 32
    call calloc
    add rsp, 32
    mov rbx, rax

    test r13, r13
    jz .cmd5_no_copy
    mov rcx, rbx
    mov rdx, r12
    mov r8, r13
    sub rsp, 32
    call memcpy
    add rsp, 32
.cmd5_no_copy:
    mov byte ptr [rbx + r13], 0x80

    mov rax, r13
    shl rax, 3
    mov [rbx + r15 - 8], rax

    lea rdi, [rbp - 48]
    mov dword ptr [rdi],      0x67452301
    mov dword ptr [rdi + 4],  0xefcdab89
    mov dword ptr [rdi + 8],  0x98badcfe
    mov dword ptr [rdi + 12], 0x10325476

    xor rsi, rsi
.cmd5_block_loop:
    cmp rsi, r15
    jae .cmd5_blocks_done

    lea r8, [rbp - 32]
    mov eax, [rdi]
    mov [r8], eax
    mov eax, [rdi + 4]
    mov [r8 + 4], eax
    mov eax, [rdi + 8]
    mov [r8 + 8], eax
    mov eax, [rdi + 12]
    mov [r8 + 12], eax

    xor eax, eax
.cmd5_round_loop:
    cmp eax, 64
    jae .cmd5_round_done

    mov edx, [r8 + 4]
    mov ecx, [r8 + 8]
    mov r9d, [r8 + 12]

    cmp eax, 16
    jae .cmd5_r2
    mov r10d, edx
    and r10d, ecx
    mov r11d, edx
    not r11d
    and r11d, r9d
    or r10d, r11d
    mov r11d, eax
    jmp .cmd5_step

.cmd5_r2:
    cmp eax, 32
    jae .cmd5_r3
    mov r10d, r9d
    and r10d, edx
    mov r11d, r9d
    not r11d
    and r11d, ecx
    or r10d, r11d
    lea r11d, [rax + rax * 4]
    inc r11d
    and r11d, 15
    jmp .cmd5_step

.cmd5_r3:
    cmp eax, 48
    jae .cmd5_r4
    mov r10d, edx
    xor r10d, ecx
    xor r10d, r9d
    lea r11d, [rax + rax * 2]
    add r11d, 5
    and r11d, 15
    jmp .cmd5_step

.cmd5_r4:
    mov r10d, r9d
    not r10d
    or r10d, edx
    xor r10d, ecx
    mov r11d, eax
    imul r11d, 7
    and r11d, 15

.cmd5_step:
    mov r12d, r9d
    mov [r8 + 12], ecx
    mov [r8 + 8], edx

    mov r9d, [r8]
    add r9d, r10d
    lea r10, [rip + md5_k]
    add r9d, [r10 + rax * 4]
    lea r10, [rbx + rsi]
    add r9d, [r10 + r11 * 4]

    lea r10, [rip + md5_s]
    mov cl, [r10 + rax * 4]
    rol r9d, cl

    add edx, r9d
    mov [r8 + 4], edx
    mov [r8], r12d

    inc eax
    jmp .cmd5_round_loop

.cmd5_round_done:
    mov eax, [r8]
    add [rdi], eax
    mov eax, [r8 + 4]
    add [rdi + 4], eax
    mov eax, [r8 + 8]
    add [rdi + 8], eax
    mov eax, [r8 + 12]
    add [rdi + 12], eax

    add rsi, 64
    jmp .cmd5_block_loop

.cmd5_blocks_done:
    mov rcx, rbx
    sub rsp, 32
    call free
    add rsp, 32

    lea r9, [rip + hex_chars_lower]
    lea rdi, [rbp - 48]
    xor eax, eax
    xor r8, r8
.cmd5_fmt_loop:
    cmp eax, 16
    jae .cmd5_fmt_done
    movzx ecx, byte ptr [rdi + rax]
    mov r10d, ecx
    shr r10d, 4
    and r10d, 0x0F
    mov r11b, [r9 + r10]
    mov [r14 + r8], r11b
    inc r8
    mov r10d, ecx
    and r10d, 0x0F
    mov r11b, [r9 + r10]
    mov [r14 + r8], r11b
    inc r8
    inc eax
    jmp .cmd5_fmt_loop

.cmd5_fmt_done:
    mov byte ptr [r14 + 32], 0

    add rsp, 136
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rsi
    pop rbx
    pop rbp
    ret

# -------------------------------------------------------------
# hex_encode(const char* data, size_t len, char* out)
# -------------------------------------------------------------
.globl hex_encode
hex_encode:
    push rbx
    push rdi
    lea r9, [rip + hex_chars_lower]
    xor rax, rax
    xor r10, r10
.che_loop:
    cmp rax, rdx
    jae .che_done
    movzx ebx, byte ptr [rcx + rax]
    mov edi, ebx
    shr edi, 4
    and ebx, 0x0F
    mov dil, [r9 + rdi]
    mov [r8 + r10], dil
    mov bl, [r9 + rbx]
    mov [r8 + r10 + 1], bl
    inc rax
    add r10, 2
    jmp .che_loop
.che_done:
    mov byte ptr [r8 + r10], 0
    pop rdi
    pop rbx
    ret

# -------------------------------------------------------------
# hex_decode(const char* str, size_t len, char* out, size_t* out_len)
# -------------------------------------------------------------
.globl hex_decode
hex_decode:
    push rbx
    push rdi
    xor rax, rax
    xor r10, r10
.chd_loop:
    lea r11, [rax + 1]
    cmp r11, rdx
    jae .chd_done
    movzx ebx, byte ptr [rcx + rax]
    movzx edi, byte ptr [rcx + rax + 1]

    cmp bl, '0'
    jb .chd_done
    cmp bl, '9'
    ja 1f
    sub bl, '0'
    jmp 2f
1:
    and bl, 0xDF
    cmp bl, 'A'
    jb .chd_done
    cmp bl, 'F'
    ja .chd_done
    sub bl, 'A' - 10
2:

    cmp dil, '0'
    jb .chd_done
    cmp dil, '9'
    ja 3f
    sub dil, '0'
    jmp 4f
3:
    and dil, 0xDF
    cmp dil, 'A'
    jb .chd_done
    cmp dil, 'F'
    ja .chd_done
    sub dil, 'A' - 10
4:
    shl bl, 4
    or bl, dil
    mov [r8 + r10], bl
    inc r10
    add rax, 2
    jmp .chd_loop
.chd_done:
    mov byte ptr [r8 + r10], 0
    test r9, r9
    jz 5f
    mov [r9], r10
5:
    pop rdi
    pop rbx
    ret

# -------------------------------------------------------------
# base64_encode(const char* data, size_t len, char* out)
# -------------------------------------------------------------
.globl base64_encode
base64_encode:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14

    lea r12, [rip + b64_table]
    xor rsi, rsi
    xor rdi, rdi

.cb64e_loop:
    mov rax, rdx
    sub rax, rsi
    jz .cb64e_done

    cmp rax, 1
    je .cb64e_one
    cmp rax, 2
    je .cb64e_two

    movzx r10d, byte ptr [rcx + rsi]
    movzx r11d, byte ptr [rcx + rsi + 1]
    movzx r13d, byte ptr [rcx + rsi + 2]

    mov eax, r10d
    shr eax, 2
    mov al, [r12 + rax]
    mov [r8 + rdi], al

    mov eax, r10d
    and eax, 3
    shl eax, 4
    mov r14d, r11d
    shr r14d, 4
    or eax, r14d
    mov al, [r12 + rax]
    mov [r8 + rdi + 1], al

    mov eax, r11d
    and eax, 0x0F
    shl eax, 2
    mov r14d, r13d
    shr r14d, 6
    or eax, r14d
    mov al, [r12 + rax]
    mov [r8 + rdi + 2], al

    mov eax, r13d
    and eax, 0x3F
    mov al, [r12 + rax]
    mov [r8 + rdi + 3], al

    add rsi, 3
    add rdi, 4
    jmp .cb64e_loop

.cb64e_one:
    movzx r10d, byte ptr [rcx + rsi]
    mov eax, r10d
    shr eax, 2
    mov al, [r12 + rax]
    mov [r8 + rdi], al

    mov eax, r10d
    and eax, 3
    shl eax, 4
    mov al, [r12 + rax]
    mov [r8 + rdi + 1], al

    mov byte ptr [r8 + rdi + 2], '='
    mov byte ptr [r8 + rdi + 3], '='
    add rdi, 4
    jmp .cb64e_done

.cb64e_two:
    movzx r10d, byte ptr [rcx + rsi]
    movzx r11d, byte ptr [rcx + rsi + 1]

    mov eax, r10d
    shr eax, 2
    mov al, [r12 + rax]
    mov [r8 + rdi], al

    mov eax, r10d
    and eax, 3
    shl eax, 4
    mov r14d, r11d
    shr r14d, 4
    or eax, r14d
    mov al, [r12 + rax]
    mov [r8 + rdi + 1], al

    mov eax, r11d
    and eax, 0x0F
    shl eax, 2
    mov al, [r12 + rax]
    mov [r8 + rdi + 2], al

    mov byte ptr [r8 + rdi + 3], '='
    add rdi, 4

.cb64e_done:
    mov byte ptr [r8 + rdi], 0
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rsi
    pop rbx
    ret

# -------------------------------------------------------------
# base64_decode(const char* str, size_t len, char* out, size_t* out_len)
# -------------------------------------------------------------
.globl base64_decode
base64_decode:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 40

    mov r12, rcx
    mov r13, rdx
    mov r14, r8
    mov [rbp - 48], r9

    xor rsi, rsi
    xor rdi, rdi

.cb64d_chunk:
    xor r15d, r15d
.cb64d_collect:
    cmp rsi, r13
    jae .cb64d_finish
    movzx eax, byte ptr [r12 + rsi]
    inc rsi

    cmp al, ' '
    je .cb64d_collect
    cmp al, '\t'
    je .cb64d_collect
    cmp al, '\r'
    je .cb64d_collect
    cmp al, '\n'
    je .cb64d_collect

    cmp al, '='
    je .cb64d_pad
    cmp al, 'A'
    jb 1f
    cmp al, 'Z'
    ja 1f
    sub al, 'A'
    jmp .cb64d_got_val
1:
    cmp al, 'a'
    jb 2f
    cmp al, 'z'
    ja 2f
    sub al, 'a' - 26
    jmp .cb64d_got_val
2:
    cmp al, '0'
    jb 3f
    cmp al, '9'
    ja 3f
    sub al, '0' - 52
    jmp .cb64d_got_val
3:
    cmp al, '+'
    jne 4f
    mov al, 62
    jmp .cb64d_got_val
4:
    cmp al, '/'
    jne .cb64d_collect
    mov al, 63

.cb64d_got_val:
    mov [rbp - 40 + r15], al
    inc r15d
    cmp r15d, 4
    jb .cb64d_collect
    jmp .cb64d_emit_3

.cb64d_pad:
    mov byte ptr [rbp - 40 + r15], 0xFF
    inc r15d
    cmp r15d, 4
    jb .cb64d_collect

.cb64d_emit_3:
    movzx eax, byte ptr [rbp - 40]
    movzx ebx, byte ptr [rbp - 39]
    movzx ecx, byte ptr [rbp - 38]
    movzx edx, byte ptr [rbp - 37]

    mov r8d, eax
    shl r8d, 2
    mov r9d, ebx
    shr r9d, 4
    or r8d, r9d
    mov [r14 + rdi], r8b
    inc rdi

    cmp cl, 0xFF
    je .cb64d_finish
    mov r8d, ebx
    and r8d, 0x0F
    shl r8d, 4
    mov r9d, ecx
    shr r9d, 2
    or r8d, r9d
    mov [r14 + rdi], r8b
    inc rdi

    cmp dl, 0xFF
    je .cb64d_finish
    mov r8d, ecx
    and r8d, 3
    shl r8d, 6
    or r8d, edx
    mov [r14 + rdi], r8b
    inc rdi
    jmp .cb64d_chunk

.cb64d_finish:
    mov byte ptr [r14 + rdi], 0
    mov rax, [rbp - 48]
    test rax, rax
    jz 6f
    mov [rax], rdi
6:
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

# -------------------------------------------------------------
# xor_mask(const char* data, size_t d_len, const char* key, size_t k_len, char* out)
# -------------------------------------------------------------
.globl xor_mask
xor_mask:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 40

    mov r12, rcx
    mov r13, rdx
    mov r14, r8
    mov r15, r9
    mov rbx, [rbp + 48]

    test r13, r13
    jz .cxm_empty
    test r15, r15
    jz .cxm_copy

    xor rsi, rsi
    xor rdi, rdi

.cxm_loop_simd:
    mov rax, r13
    sub rax, rsi
    cmp rax, 16
    jb .cxm_loop_scalar

    xor ecx, ecx
.cxm_fill_16:
    cmp ecx, 16
    jae .cxm_do_simd
    mov al, [r14 + rdi]
    mov [rsp + rcx], al
    inc rdi
    cmp rdi, r15
    jb 1f
    xor rdi, rdi
1:
    inc ecx
    jmp .cxm_fill_16

.cxm_do_simd:
    movdqu xmm0, [rsp]
    movdqu xmm1, [r12 + rsi]
    pxor xmm1, xmm0
    movdqu [rbx + rsi], xmm1
    add rsi, 16
    jmp .cxm_loop_simd

.cxm_loop_scalar:
    cmp rsi, r13
    jae .cxm_done
    mov al, [r12 + rsi]
    mov cl, [r14 + rdi]
    xor al, cl
    mov [rbx + rsi], al
    inc rsi
    inc rdi
    cmp rdi, r15
    jb .cxm_loop_scalar
    xor rdi, rdi
    jmp .cxm_loop_scalar

.cxm_copy:
    xor rsi, rsi
.cxm_cp_loop:
    cmp rsi, r13
    jae .cxm_done
    mov al, [r12 + rsi]
    mov [rbx + rsi], al
    inc rsi
    jmp .cxm_cp_loop

.cxm_done:
    mov byte ptr [rbx + r13], 0
    jmp .cxm_ret

.cxm_empty:
    mov byte ptr [rbx], 0

.cxm_ret:
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

# --- Opcode Handlers: Crypto & Encoding ---

op_crypto_sha256:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + str_hex_fmt]
2:
    xor r13, r13
3:
    cmp byte ptr [rcx + r13], 0
    je 4f
    inc r13
    jmp 3b
4:
    push rsi
    push rdi
    push rbx
    push r12
    push rcx
    push r13
    sub rsp, 48
    mov rcx, 65
    xor rdx, rdx
    call gc_malloc
    add rsp, 48
    pop r13
    pop rcx
    pop r12
    pop rbx
    pop rdi
    pop rsi

    push rsi
    push rdi
    push rbx
    push r12
    push rax
    push rax
    sub rsp, 48
    mov r8, rax
    mov rdx, r13
    call sha256_compute
    add rsp, 48
    pop rax
    pop rax
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_crypto_md5:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + str_hex_fmt]
2:
    xor r13, r13
3:
    cmp byte ptr [rcx + r13], 0
    je 4f
    inc r13
    jmp 3b
4:
    push rsi
    push rdi
    push rbx
    push r12
    push rcx
    push r13
    sub rsp, 48
    mov rcx, 33
    xor rdx, rdx
    call gc_malloc
    add rsp, 48
    pop r13
    pop rcx
    pop r12
    pop rbx
    pop rdi
    pop rsi

    push rsi
    push rdi
    push rbx
    push r12
    push rax
    push rax
    sub rsp, 48
    mov r8, rax
    mov rdx, r13
    call md5_compute
    add rsp, 48
    pop rax
    pop rax
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_crypto_b64_encode:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + str_hex_fmt]
2:
    xor r13, r13
3:
    cmp byte ptr [rcx + r13], 0
    je 4f
    inc r13
    jmp 3b
4:
    lea rax, [r13 + 2]
    xor edx, edx
    mov r10, 3
    div r10
    shl rax, 2
    add rax, 5

    push rsi
    push rdi
    push rbx
    push r12
    push rcx
    push r13
    sub rsp, 48
    mov rcx, rax
    xor rdx, rdx
    call gc_malloc
    add rsp, 48
    pop r13
    pop rcx
    pop r12
    pop rbx
    pop rdi
    pop rsi

    push rsi
    push rdi
    push rbx
    push r12
    push rax
    push rax
    sub rsp, 48
    mov r8, rax
    mov rdx, r13
    call base64_encode
    add rsp, 48
    pop rax
    pop rax
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_crypto_b64_decode:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + str_hex_fmt]
2:
    xor r13, r13
3:
    cmp byte ptr [rcx + r13], 0
    je 4f
    inc r13
    jmp 3b
4:
    mov rax, r13
    shr rax, 2
    lea rax, [rax + rax * 2]
    add rax, 8

    push rsi
    push rdi
    push rbx
    push r12
    push rcx
    push r13
    sub rsp, 48
    mov rcx, rax
    xor rdx, rdx
    call gc_malloc
    add rsp, 48
    pop r13
    pop rcx
    pop r12
    pop rbx
    pop rdi
    pop rsi

    push rsi
    push rdi
    push rbx
    push r12
    push rax
    push rax
    sub rsp, 48
    mov r8, rax
    mov rdx, r13
    xor r9, r9
    call base64_decode
    add rsp, 48
    pop rax
    pop rax
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_crypto_hex_encode:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + str_hex_fmt]
2:
    xor r13, r13
3:
    cmp byte ptr [rcx + r13], 0
    je 4f
    inc r13
    jmp 3b
4:
    lea rax, [r13 * 2 + 1]

    push rsi
    push rdi
    push rbx
    push r12
    push rcx
    push r13
    sub rsp, 48
    mov rcx, rax
    xor rdx, rdx
    call gc_malloc
    add rsp, 48
    pop r13
    pop rcx
    pop r12
    pop rbx
    pop rdi
    pop rsi

    push rsi
    push rdi
    push rbx
    push r12
    push rax
    push rax
    sub rsp, 48
    mov r8, rax
    mov rdx, r13
    call hex_encode
    add rsp, 48
    pop rax
    pop rax
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_crypto_hex_decode:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + str_hex_fmt]
2:
    xor r13, r13
3:
    cmp byte ptr [rcx + r13], 0
    je 4f
    inc r13
    jmp 3b
4:
    mov rax, r13
    shr rax, 1
    inc rax

    push rsi
    push rdi
    push rbx
    push r12
    push rcx
    push r13
    sub rsp, 48
    mov rcx, rax
    xor rdx, rdx
    call gc_malloc
    add rsp, 48
    pop r13
    pop rcx
    pop r12
    pop rbx
    pop rdi
    pop rsi

    push rsi
    push rdi
    push rbx
    push r12
    push rax
    push rax
    sub rsp, 48
    mov r8, rax
    mov rdx, r13
    xor r9, r9
    call hex_decode
    add rsp, 48
    pop rax
    pop rax
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_crypto_xor_mask:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + str_hex_fmt]
2:
    mov rdx, [rbx + r9 * 8]
    test rdx, rdx
    jnz 3f
    mov rdx, [rdi + r9 * 8]
3:
    test rdx, rdx
    jnz 4f
    lea rdx, [rip + str_hex_fmt]
4:
    xor r13, r13
5:
    cmp byte ptr [rcx + r13], 0
    je 6f
    inc r13
    jmp 5b
6:
    xor r14, r14
7:
    cmp byte ptr [rdx + r14], 0
    je 8f
    inc r14
    jmp 7b
8:
    lea rax, [r13 + 1]

    push rsi
    push rdi
    push rbx
    push r12
    push rcx
    push rdx
    push r13
    push r14
    sub rsp, 48
    mov rcx, rax
    xor rdx, rdx
    call gc_malloc
    add rsp, 48
    pop r14
    pop r13
    pop rdx
    pop rcx
    pop r12
    pop rbx
    pop rdi
    pop rsi

    push rsi
    push rdi
    push rbx
    push r12
    push rax
    push rax
    sub rsp, 48
    mov [rsp + 32], rax
    mov r9, r14
    mov r8, rdx
    mov rdx, r13
    call xor_mask
    add rsp, 48
    pop rax
    pop rax
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_sys_args:
    mov r12, [rsi]       # dest
    add rsi, 8

    # Find the starting index in argv for script arguments
    mov r8d, [rip + argc_store]
    mov r9,  [rip + argv_store]
    mov r10, [rip + cli_source_file]

    # Search for cli_source_file in argv
    mov r13d, 1          # default start_idx = 1
    xor ecx, ecx
.find_arg_loop:
    cmp ecx, r8d
    jge .find_arg_done
    cmp [r9 + rcx * 8], r10
    je .found_cli_arg
    inc ecx
    jmp .find_arg_loop
.found_cli_arg:
    mov r13d, ecx        # start_idx is index of the .nx script
.find_arg_done:
    mov ecx, r8d
    sub ecx, r13d        # count = argc - start_idx
    test ecx, ecx
    jle .empty_args

    # Allocate Nexus array: count * 8 bytes (type = 3)
    push rsi
    push rdi
    push rbx
    push r12
    push r13
    push r8
    push r9
    push rcx             # count
    sub rsp, 32          # 8 pushes (64) + 32 = 96 (0 mod 16) - ALIGNED

    lea rcx, [rcx * 8]
    mov rdx, 3
    call gc_malloc

    add rsp, 32
    pop rcx              # count
    pop r9               # argv_store
    pop r8               # argc_store
    pop r13              # start_idx
    pop r12              # dest
    pop rbx
    pop rdi
    pop rsi

    # rax = array ptr
    mov r10, 0x4152524159
    mov [rax - 32], r10          # "ARRAY" type tag
    cvtsi2sd xmm0, rcx
    movsd [rax - 16], xmm0       # length

    # Populate array with strdup'd arguments
    xor edx, edx         # j = 0
.copy_args_loop:
    cmp edx, ecx
    jge .args_done
    lea r14d, [r13d + edx]       # k = start_idx + j
    cmp r14d, [rip + argc_store]
    jge .args_done
    mov r15, [r9 + r14 * 8]      # argv[k]
    test r15, r15
    jnz 1f
    lea r15, [rip + empty_str]
1:

    push r12
    push rbx
    push rdi
    push rsi
    push rax             # array ptr
    push rcx             # count
    push rdx             # j
    push r9              # argv_store
    push r13             # start_idx
    push r15             # argv[k]
    sub rsp, 48          # 10 pushes (80) + 48 = 128 (0 mod 16) - ALIGNED

    mov rcx, r15
    call strdup
    test rax, rax
    jnz 2f
    lea rax, [rip + empty_str]
2:
    mov r15, rax         # r15 = strdup result

    add rsp, 48
    pop rax              # discard saved argv[k]
    pop r13
    pop r9
    pop rdx              # j
    pop rcx              # count
    pop r14              # array ptr
    pop rsi
    pop rdi
    pop rbx
    pop r12

    mov [r14 + rdx * 8], r15     # store arg string
    mov rax, r14
    inc edx
    jmp .copy_args_loop

.args_done:
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

.empty_args:
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 32
    mov rcx, 0
    mov rdx, 3
    call gc_malloc
    add rsp, 32
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov r10, 0x4152524159
    mov [rax - 32], r10
    xorps xmm0, xmm0
    movsd [rax - 16], xmm0
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_sys_time_ms:
    mov r12, [rsi]       # dest
    add rsi, 8

    push rsi
    push rdi
    push rbx
    push r12
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    lea rcx, [rsp + 32]
    call QueryPerformanceCounter

    mov rax, [rsp + 32]          # count
    cvtsi2sd xmm0, rax
    mov rcx, 1000
    cvtsi2sd xmm1, rcx
    mulsd xmm0, xmm1             # count * 1000.0

    mov rax, [rip + perf_freq]
    cvtsi2sd xmm2, rax
    divsd xmm0, xmm2             # ms = (count * 1000.0) / freq

    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    pop rdi
    pop rsi

    movsd [rdi + r12 * 8], xmm0
    NEXT

op_sys_get_env:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # name_reg
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jz .getenv_null

    push rsi
    push rdi
    push rbx
    push r12
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 4144        # 32 shadow space + 4096 buffer + 16

    # rcx is lpName
    lea rdx, [rsp + 32]  # lpBuffer
    mov r8d, 4096        # nSize
    call GetEnvironmentVariableA

    test eax, eax
    jz .getenv_fail

    # strdup the buffer
    lea rcx, [rsp + 32]
    call strdup

    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    pop rdi
    pop rsi
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

.getenv_fail:
    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    pop rdi
    pop rsi
.getenv_null:
    lea rax, [rip + empty_str]
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_sys_set_env:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # name_reg
    mov r9,  [rsi+16]    # val_reg
    add rsi, 24

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jz .setenv_fail
    mov rdx, [rbx + r9 * 8]
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r9 * 8]
2:
    test rdx, rdx
    jnz 3f
    lea rdx, [rip + empty_str]
3:
    push rsi
    push rdi
    push rbx
    push r12
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    call SetEnvironmentVariableA

    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    pop rdi
    pop rsi

    test eax, eax
    jz .setenv_fail
    mov rax, 0x3FF0000000000000   # 1.0 double
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax
    NEXT
.setenv_fail:
    xor eax, eax
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax
    NEXT

op_sys_exec:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # cmd_reg
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jz .exec_null

    push rsi
    push rdi
    push rbx
    push r12
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    call system

    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    pop rdi
    pop rsi

    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

.exec_null:
    mov rax, -1
    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

# ---------------------------------------------------------
# OPTION B: HARDWARE AES-NI & SECURE RANDOMNESS
# ---------------------------------------------------------

aes128_key_expansion_asm:
    movdqu xmm1, [rcx]
    movdqu [rdx], xmm1           # enc_keys[0] = key

    aeskeygenassist xmm2, xmm1, 0x01
    call .aes_assist
    movdqu [rdx + 16], xmm1

    aeskeygenassist xmm2, xmm1, 0x02
    call .aes_assist
    movdqu [rdx + 32], xmm1

    aeskeygenassist xmm2, xmm1, 0x04
    call .aes_assist
    movdqu [rdx + 48], xmm1

    aeskeygenassist xmm2, xmm1, 0x08
    call .aes_assist
    movdqu [rdx + 64], xmm1

    aeskeygenassist xmm2, xmm1, 0x10
    call .aes_assist
    movdqu [rdx + 80], xmm1

    aeskeygenassist xmm2, xmm1, 0x20
    call .aes_assist
    movdqu [rdx + 96], xmm1

    aeskeygenassist xmm2, xmm1, 0x40
    call .aes_assist
    movdqu [rdx + 112], xmm1

    aeskeygenassist xmm2, xmm1, 0x80
    call .aes_assist
    movdqu [rdx + 128], xmm1

    aeskeygenassist xmm2, xmm1, 0x1b
    call .aes_assist
    movdqu [rdx + 144], xmm1

    aeskeygenassist xmm2, xmm1, 0x36
    call .aes_assist
    movdqu [rdx + 160], xmm1

    # dec_keys[0] = enc_keys[10]
    movdqu xmm0, [rdx + 160]
    movdqu [r8], xmm0

    aesimc xmm0, [rdx + 144]
    movdqu [r8 + 16], xmm0

    aesimc xmm0, [rdx + 128]
    movdqu [r8 + 32], xmm0

    aesimc xmm0, [rdx + 112]
    movdqu [r8 + 48], xmm0

    aesimc xmm0, [rdx + 96]
    movdqu [r8 + 64], xmm0

    aesimc xmm0, [rdx + 80]
    movdqu [r8 + 80], xmm0

    aesimc xmm0, [rdx + 64]
    movdqu [r8 + 96], xmm0

    aesimc xmm0, [rdx + 48]
    movdqu [r8 + 112], xmm0

    aesimc xmm0, [rdx + 32]
    movdqu [r8 + 128], xmm0

    aesimc xmm0, [rdx + 16]
    movdqu [r8 + 144], xmm0

    movdqu xmm0, [rdx]
    movdqu [r8 + 160], xmm0
    ret

.aes_assist:
    pshufd xmm2, xmm2, 0xff
    movdqa xmm3, xmm1
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pxor xmm1, xmm2
    ret

aes128_encrypt_cbc_asm:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    and rsp, -16
    sub rsp, 448     # stack buffer for keys + 16-byte key buffer + shadow space + alignment

    mov r12, rcx     # plain
    mov r13, rdx     # plain_len
    mov r14, r8      # key

    # Zero-pad key to 16 bytes at [rsp + 400]
    lea rax, [rsp + 400]
    mov qword ptr [rax], 0
    mov qword ptr [rax + 8], 0
    xor edx, edx
.aescbc_kcopy_loop:
    cmp edx, 16
    jae .aescbc_kcopy_done
    mov cl, [r14 + rdx]
    test cl, cl
    jz .aescbc_kcopy_done
    mov [rax + rdx], cl
    inc edx
    jmp .aescbc_kcopy_loop
.aescbc_kcopy_done:

    # Expand key: key=[rsp + 400], enc_keys=[rsp + 48], dec_keys=[rsp + 224]
    lea rcx, [rsp + 400]
    lea rdx, [rsp + 48]
    lea r8,  [rsp + 224]
    call aes128_key_expansion_asm

    # pad = 16 - (r13 % 16)
    mov rax, r13
    and rax, 15
    mov r15, 16
    sub r15, rax     # r15 = pad (1..16)
    lea rbx, [r13 + r15] # rbx = padded_len

    # Allocate padded buffer via gc_malloc
    mov rcx, rbx
    xor rdx, rdx
    call gc_malloc
    mov r14, rax     # r14 = padded plaintext

    test r13, r13
    jz .aescbc_pad_fill
    mov rcx, r14
    mov rdx, r12
    mov r8, r13
    call memcpy

.aescbc_pad_fill:
    xor ecx, ecx
.aescbc_pad_loop:
    cmp rcx, r15
    jae .aescbc_pad_done
    lea rdx, [r13 + rcx]
    mov [r14 + rdx], r15b
    inc rcx
    jmp .aescbc_pad_loop
.aescbc_pad_done:

    # Allocate ciphertext buffer via gc_malloc
    mov rcx, rbx
    xor rdx, rdx
    call gc_malloc
    mov r12, rax     # r12 = ciphertext bytes

    # CBC Encrypt
    pxor xmm4, xmm4  # IV = 0
    xor rcx, rcx     # offset = 0
.aescbc_enc_loop:
    cmp rcx, rbx
    jae .aescbc_enc_done

    movdqu xmm0, [r14 + rcx]
    pxor xmm0, xmm4               # XOR with IV / prev block
    pxor xmm0, [rsp + 48]         # Round 0
    aesenc xmm0, [rsp + 48 + 16]  # Round 1
    aesenc xmm0, [rsp + 48 + 32]  # Round 2
    aesenc xmm0, [rsp + 48 + 48]  # Round 3
    aesenc xmm0, [rsp + 48 + 64]  # Round 4
    aesenc xmm0, [rsp + 48 + 80]  # Round 5
    aesenc xmm0, [rsp + 48 + 96]  # Round 6
    aesenc xmm0, [rsp + 48 + 112] # Round 7
    aesenc xmm0, [rsp + 48 + 128] # Round 8
    aesenc xmm0, [rsp + 48 + 144] # Round 9
    aesenclast xmm0, [rsp + 48 + 160] # Round 10

    movdqa xmm4, xmm0        # update IV
    movdqu [r12 + rcx], xmm0 # store ciphertext block

    add rcx, 16
    jmp .aescbc_enc_loop

.aescbc_enc_done:
    # Hex-encode r12 (rbx bytes) into (2 * rbx + 1) string
    lea rcx, [rbx * 2 + 1]
    xor rdx, rdx
    call gc_malloc
    mov r14, rax     # r14 = hex string result

    lea r8, [rip + hex_chars_lower]
    xor rcx, rcx
.aescbc_hex_loop:
    cmp rcx, rbx
    jae .aescbc_hex_done
    movzx edx, byte ptr [r12 + rcx]
    mov eax, edx
    shr eax, 4
    mov al, [r8 + rax]
    mov [r14 + rcx * 2], al
    mov eax, edx
    and eax, 15
    mov al, [r8 + rax]
    mov [r14 + rcx * 2 + 1], al
    inc rcx
    jmp .aescbc_hex_loop

.aescbc_hex_done:
    mov byte ptr [r14 + rbx * 2], 0
    mov rax, r14

    lea rsp, [rbp - 48]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    pop rbp
    ret

aes128_decrypt_cbc_asm:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    and rsp, -16
    sub rsp, 448     # stack buffer for keys + 16-byte key buffer + shadow space + alignment

    mov r12, rcx     # hex_ct
    mov r13, rdx     # hex_len
    mov r14, r8      # key

    test r13, r13
    jz .aescbc_dec_empty
    test r13, 31
    jnz .aescbc_dec_empty

    # Zero-pad key to 16 bytes at [rsp + 400]
    lea rax, [rsp + 400]
    mov qword ptr [rax], 0
    mov qword ptr [rax + 8], 0
    xor edx, edx
.aescbc_dkcopy_loop:
    cmp edx, 16
    jae .aescbc_dkcopy_done
    mov cl, [r14 + rdx]
    test cl, cl
    jz .aescbc_dkcopy_done
    mov [rax + rdx], cl
    inc edx
    jmp .aescbc_dkcopy_loop
.aescbc_dkcopy_done:

    lea rcx, [rsp + 400]
    lea rdx, [rsp + 48]
    lea r8,  [rsp + 224]
    call aes128_key_expansion_asm

    mov rbx, r13
    shr rbx, 1       # rbx = ct_len

    mov rcx, rbx
    xor rdx, rdx
    call gc_malloc
    mov r15, rax     # r15 = raw ct buffer

    # Hex-decode r12 into r15
    xor rcx, rcx
.aescbc_dh_loop:
    cmp rcx, rbx
    jae .aescbc_dh_done
    movzx edx, byte ptr [r12 + rcx * 2]
    call .hex_val_nibble
    shl al, 4
    mov ah, al
    movzx edx, byte ptr [r12 + rcx * 2 + 1]
    call .hex_val_nibble
    or al, ah
    mov [r15 + rcx], al
    inc rcx
    jmp .aescbc_dh_loop
.aescbc_dh_done:

    lea rcx, [rbx + 1]
    xor rdx, rdx
    call gc_malloc
    mov r14, rax     # r14 = decrypted plaintext

    pxor xmm4, xmm4  # IV = 0
    xor rcx, rcx
.aescbc_dec_loop:
    cmp rcx, rbx
    jae .aescbc_dec_done

    movdqu xmm0, [r15 + rcx]
    movdqa xmm5, xmm0        # xmm5 = orig ct block

    pxor xmm0, [rsp + 224]        # Round 0 with dec_keys
    aesdec xmm0, [rsp + 224 + 16] # Round 1
    aesdec xmm0, [rsp + 224 + 32] # Round 2
    aesdec xmm0, [rsp + 224 + 48] # Round 3
    aesdec xmm0, [rsp + 224 + 64] # Round 4
    aesdec xmm0, [rsp + 224 + 80] # Round 5
    aesdec xmm0, [rsp + 224 + 96] # Round 6
    aesdec xmm0, [rsp + 224 + 112]# Round 7
    aesdec xmm0, [rsp + 224 + 128]# Round 8
    aesdec xmm0, [rsp + 224 + 144]# Round 9
    aesdeclast xmm0, [rsp + 224 + 160] # Round 10

    pxor xmm0, xmm4          # XOR with IV / prev ct block
    movdqa xmm4, xmm5        # IV = orig ct block

    movdqu [r14 + rcx], xmm0 # store decrypted block
    add rcx, 16
    jmp .aescbc_dec_loop

.aescbc_dec_done:
    movzx eax, byte ptr [r14 + rbx - 1]
    cmp eax, 1
    jb .aescbc_dec_badpad
    cmp eax, 16
    ja .aescbc_dec_badpad

    sub rbx, rax
    mov byte ptr [r14 + rbx], 0
    mov rax, r14
    jmp .aescbc_dec_exit

.aescbc_dec_badpad:
    mov byte ptr [r14 + rbx], 0
    mov rax, r14
    jmp .aescbc_dec_exit

.aescbc_dec_empty:
    lea rax, [rip + empty_str]

.aescbc_dec_exit:
    lea rsp, [rbp - 48]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    pop rbp
    ret

.hex_val_nibble:
    cmp dl, '9'
    jle 1f
    cmp dl, 'F'
    jle 2f
    sub dl, 'a'
    add dl, 10
    mov al, dl
    ret
1:  sub dl, '0'
    mov al, dl
    ret
2:  sub dl, 'A'
    add dl, 10
    mov al, dl
    ret

hmac_sha256_asm:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    and rsp, -16
    sub rsp, 336     # shadow space (48) + K' (64) + inner_hash (32) + outer_buf (96) + hex_temp (80) + align

    mov r12, rcx     # data
    mov r13, rdx     # data_len
    mov r14, r8      # key
    mov r15, r9      # key_len

    # Clear K' buffer at [rsp + 48] (64 bytes)
    lea rax, [rsp + 48]
    xor ecx, ecx
1:  cmp ecx, 64
    jae 2f
    mov byte ptr [rax + rcx], 0
    inc ecx
    jmp 1b
2:

    # If key_len > 64: hash key with sha256_compute
    cmp r15, 64
    jbe .hmac_key_short
    mov rcx, r14
    mov rdx, r15
    lea r8, [rsp + 240]    # hex_temp buffer
    call sha256_compute
    xor ecx, ecx
.hmac_kh_loop:
    cmp ecx, 32
    jae .hmac_kh_done
    movzx edx, byte ptr [rsp + 240 + rcx * 2]
    call .hex_val_nibble
    shl al, 4
    mov ah, al
    movzx edx, byte ptr [rsp + 240 + rcx * 2 + 1]
    call .hex_val_nibble
    or al, ah
    mov [rsp + 48 + rcx], al
    inc ecx
    jmp .hmac_kh_loop
.hmac_kh_done:
    jmp .hmac_key_ready

.hmac_key_short:
    test r15, r15
    jz .hmac_key_ready
    lea rcx, [rsp + 48]
    mov rdx, r14
    mov r8, r15
    call memcpy

.hmac_key_ready:
    lea rcx, [r13 + 64]
    xor rdx, rdx
    call gc_malloc
    mov rbx, rax     # rbx = inner_buf

    xor ecx, ecx
.hmac_ipad_loop:
    cmp ecx, 64
    jae .hmac_ipad_done
    mov al, [rsp + 48 + rcx]
    xor al, 0x36
    mov [rbx + rcx], al
    inc ecx
    jmp .hmac_ipad_loop
.hmac_ipad_done:

    test r13, r13
    jz .hmac_inner_hash
    lea rcx, [rbx + 64]
    mov rdx, r12
    mov r8, r13
    call memcpy

.hmac_inner_hash:
    mov rcx, rbx
    lea rdx, [r13 + 64]
    lea r8, [rsp + 240]
    call sha256_compute

    xor ecx, ecx
.hmac_ih_loop:
    cmp ecx, 32
    jae .hmac_ih_done
    movzx edx, byte ptr [rsp + 240 + rcx * 2]
    call .hex_val_nibble
    shl al, 4
    mov ah, al
    movzx edx, byte ptr [rsp + 240 + rcx * 2 + 1]
    call .hex_val_nibble
    or al, ah
    mov [rsp + 112 + rcx], al
    inc ecx
    jmp .hmac_ih_loop
.hmac_ih_done:

    xor ecx, ecx
.hmac_opad_loop:
    cmp ecx, 64
    jae .hmac_opad_done
    mov al, [rsp + 48 + rcx]
    xor al, 0x5c
    mov [rsp + 144 + rcx], al
    inc ecx
    jmp .hmac_opad_loop
.hmac_opad_done:

    lea rcx, [rsp + 144 + 64]
    lea rdx, [rsp + 112]
    mov r8, 32
    call memcpy

    mov rcx, 65
    xor rdx, rdx
    call gc_malloc
    mov r12, rax     # r12 = final hex string

    lea rcx, [rsp + 144]
    mov rdx, 96
    mov r8, r12
    call sha256_compute

    mov rax, r12
    lea rsp, [rbp - 48]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    pop rbp
    ret

rdrand_bytes_asm:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    and rsp, -16
    sub rsp, 48

    mov r12, rcx     # num_bytes
    test r12, r12
    jle .rdrand_zero

    lea rcx, [r12 * 2 + 1]
    xor rdx, rdx
    call gc_malloc
    mov r13, rax     # r13 = hex buffer

    lea r14, [rip + hex_chars_lower]
    xor rbx, rbx     # i = 0
.rdrand_byte_loop:
    cmp rbx, r12
    jae .rdrand_done

    mov r8d, 20
.rdrand_retry:
    rdrand eax
    jc .rdrand_have_val
    dec r8d
    jnz .rdrand_retry
    rdtsc
.rdrand_have_val:
    movzx edx, al
    mov ecx, edx
    shr ecx, 4
    mov cl, [r14 + rcx]
    mov [r13 + rbx * 2], cl
    mov ecx, edx
    and ecx, 15
    mov cl, [r14 + rcx]
    mov [r13 + rbx * 2 + 1], cl

    inc rbx
    jmp .rdrand_byte_loop

.rdrand_done:
    mov byte ptr [r13 + r12 * 2], 0
    mov r10, 0x535452494E47
    mov [r13 - 32], r10
    lea rax, [r12 * 2]
    mov [r13 - 8], rax
    cvtsi2sd xmm0, rax
    movsd [r13 - 16], xmm0
    mov rax, r13
    jmp .rdrand_exit

.rdrand_zero:
    lea rax, [rip + empty_str]

.rdrand_exit:
    lea rsp, [rbp - 48]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    pop rbp
    ret

op_crypto_aes_encrypt:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # data_reg
    mov r9,  [rsi+16]    # key_reg
    add rsi, 24

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    mov rdx, [rbx + r9 * 8]
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r9 * 8]
2:
    test rcx, rcx
    jnz 3f
    lea rcx, [rip + empty_str]
3:  test rdx, rdx
    jnz 4f
    lea rdx, [rip + empty_str]
4:
    mov r13, rcx
    mov r14, rdx
    xor rdx, rdx
5:  cmp byte ptr [r13 + rdx], 0
    je 6f
    inc rdx
    jmp 5b
6:
    mov r15, rdx      # r15 = plain_len
    push rsi
    push rdi
    push rbx
    push r12
    push r15
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    mov rcx, r13
    mov rdx, r15
    mov r8,  r14
    call aes128_encrypt_cbc_asm

    mov rsp, rbp
    pop rbp
    pop r15
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_crypto_aes_decrypt:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # data_reg (hex_ct)
    mov r9,  [rsi+16]    # key_reg
    add rsi, 24

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    mov rdx, [rbx + r9 * 8]
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r9 * 8]
2:
    test rcx, rcx
    jnz 3f
    lea rcx, [rip + empty_str]
3:  test rdx, rdx
    jnz 4f
    lea rdx, [rip + empty_str]
4:
    mov r13, rcx
    mov r14, rdx
    xor rdx, rdx
5:  cmp byte ptr [r13 + rdx], 0
    je 6f
    inc rdx
    jmp 5b
6:
    mov r15, rdx      # r15 = hex_len
    push rsi
    push rdi
    push rbx
    push r12
    push r15
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    mov rcx, r13
    mov rdx, r15
    mov r8,  r14
    call aes128_decrypt_cbc_asm

    mov rsp, rbp
    pop rbp
    pop r15
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_crypto_hmac_sha256:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # data_reg
    mov r9,  [rsi+16]    # key_reg
    add rsi, 24

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    mov rdx, [rbx + r9 * 8]
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r9 * 8]
2:
    test rcx, rcx
    jnz 3f
    lea rcx, [rip + empty_str]
3:  test rdx, rdx
    jnz 4f
    lea rdx, [rip + empty_str]
4:
    mov r13, rcx
    mov r14, rdx
    xor rdx, rdx
5:  cmp byte ptr [r13 + rdx], 0
    je 6f
    inc rdx
    jmp 5b
6:
    xor r9, r9
7:  cmp byte ptr [r14 + r9], 0
    je 8f
    inc r9
    jmp 7b
8:
    mov r15, rdx      # r15 = data_len
    push rsi
    push rdi
    push rbx
    push r12
    push r15
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    mov rcx, r13
    mov rdx, r15
    mov r8,  r14
    # r9 is key_len
    call hmac_sha256_asm

    mov rsp, rbp
    pop rbp
    pop r15
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_crypto_random_bytes:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # len_reg
    add rsi, 16

    mov rax, [rdi + r8 * 8]
    mov r10, 0x7FF0000000000000
    test rax, r10
    jz 1f
    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    jmp 2f
1:
    mov rcx, rax
2:

    push rsi
    push rdi
    push rbx
    push r12
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    call rdrand_bytes_asm

    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

# ---------------------------------------------------------
# OPTION C: NETWORKING & BAREMETAL SOCKETS (Winsock2)
# ---------------------------------------------------------

wsa_ensure_init:
    cmp qword ptr [rip + wsa_initialized], 1
    je .wsa_done
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48
    mov rcx, 0x0202           # MAKEWORD(2, 2)
    lea rdx, [rip + wsa_data_buf]
    call WSAStartup
    mov qword ptr [rip + wsa_initialized], 1
    mov rsp, rbp
    pop rbp
.wsa_done:
    ret

tcp_connect_asm:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    and rsp, -16
    sub rsp, 64

    mov r12, rcx     # host_ptr
    mov r13, rdx     # port

    call wsa_ensure_init

    mov rcx, r13
    call htons
    mov r14w, ax     # r14w = sin_port

    mov rcx, r12
    call inet_addr
    cmp eax, 0xFFFFFFFF
    jne .conn_addr_ok

    mov rcx, r12
    call gethostbyname
    test rax, rax
    jz .conn_fail
    mov rax, [rax + 24]  # h_addr_list
    test rax, rax
    jz .conn_fail
    mov rax, [rax]       # h_addr_list[0]
    test rax, rax
    jz .conn_fail
    mov eax, [rax]       # 4-byte IPv4

.conn_addr_ok:
    mov r15d, eax    # r15d = sin_addr

    mov rcx, 2       # AF_INET
    mov rdx, 1       # SOCK_STREAM
    mov r8,  6       # IPPROTO_TCP
    call socket
    cmp rax, -1
    je .conn_fail
    mov rbx, rax     # rbx = socket handle

    # Enable TCP_NODELAY (disable Nagle algorithm)
    mov dword ptr [rsp + 64], 1
    mov rcx, rbx
    mov edx, 6       # IPPROTO_TCP
    mov r8d, 1       # TCP_NODELAY
    lea r9,  [rsp + 64]
    mov qword ptr [rsp + 32], 4
    call setsockopt

    mov word ptr  [rsp + 48], 2       # sin_family = 2
    mov word ptr  [rsp + 50], r14w    # sin_port
    mov dword ptr [rsp + 52], r15d    # sin_addr
    mov qword ptr [rsp + 56], 0       # sin_zero

    mov rcx, rbx
    lea rdx, [rsp + 48]
    mov r8,  16
    call connect
    test eax, eax
    jz .conn_success

    mov rcx, rbx
    call closesocket
.conn_fail:
    mov rax, -1
    jmp .conn_exit

.conn_success:
    mov rax, rbx

.conn_exit:
    lea rsp, [rbp - 48]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    pop rbp
    ret

tcp_send_asm:
    sub rsp, 40
    xor r9d, r9d     # flags = 0
    call send
    add rsp, 40
    ret

tcp_recv_asm:
    push r12
    push r13
    push r14
    sub rsp, 40

    mov r12, rcx     # sock
    mov r13, rdx     # max_len
    cmp r13, 0
    jg 1f
    mov r13, 4096
1:
    lea rcx, [r13 + 1]
    xor rdx, rdx
    call gc_malloc
    mov r14, rax     # buffer

    mov rcx, r12
    mov rdx, r14
    mov r8,  r13
    xor r9,  r9
    call recv
    test eax, eax
    jle .recv_none

    mov byte ptr [r14 + rax], 0
    mov rax, r14
    jmp .recv_done

.recv_none:
    mov byte ptr [r14], 0
    mov rax, r14

.recv_done:
    add rsp, 40
    pop r14
    pop r13
    pop r12
    ret

tcp_close_asm:
    sub rsp, 40
    call closesocket
    xor eax, eax
    add rsp, 40
    ret

tcp_listen_asm:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    and rsp, -16
    sub rsp, 64

    mov r13, rcx     # port
    call wsa_ensure_init

    mov rcx, r13
    call htons
    mov r14w, ax     # sin_port

    mov rcx, 2
    mov rdx, 1
    mov r8,  6
    call socket
    cmp rax, -1
    je .list_fail
    mov rbx, rax     # server socket

    mov dword ptr [rsp + 48], 1
    mov rcx, rbx
    mov edx, 0xFFFF   # SOL_SOCKET
    mov r8d, 4        # SO_REUSEADDR
    lea r9,  [rsp + 48]
    mov qword ptr [rsp + 32], 4
    call setsockopt

    # Enable TCP_NODELAY on listening socket
    mov dword ptr [rsp + 48], 1
    mov rcx, rbx
    mov edx, 6        # IPPROTO_TCP
    mov r8d, 1        # TCP_NODELAY
    lea r9,  [rsp + 48]
    mov qword ptr [rsp + 32], 4
    call setsockopt

    mov word ptr  [rsp + 48], 2       # AF_INET
    mov word ptr  [rsp + 50], r14w    # sin_port
    mov dword ptr [rsp + 52], 0       # INADDR_ANY
    mov qword ptr [rsp + 56], 0

    mov rcx, rbx
    lea rdx, [rsp + 48]
    mov r8,  16
    call bind
    test eax, eax
    jnz .list_close_fail

    mov rcx, rbx
    mov rdx, 10
    call listen
    test eax, eax
    jnz .list_close_fail

    mov rax, rbx
    jmp .list_exit

.list_close_fail:
    mov rcx, rbx
    call closesocket
.list_fail:
    mov rax, -1

.list_exit:
    lea rsp, [rbp - 48]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    pop rbp
    ret

tcp_accept_asm:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    and rsp, -16
    sub rsp, 64

    xor rdx, rdx
    xor r8,  r8
    call accept
    cmp rax, -1
    je .acc_done
    mov rbx, rax

    # Enable TCP_NODELAY on accepted peer socket
    mov dword ptr [rsp + 48], 1
    mov rcx, rbx
    mov edx, 6        # IPPROTO_TCP
    mov r8d, 1        # TCP_NODELAY
    lea r9,  [rsp + 48]
    mov qword ptr [rsp + 32], 4
    call setsockopt

    mov rax, rbx
.acc_done:
    lea rsp, [rbp - 48]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    pop rbp
    ret

http_get_asm:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    and rsp, -16
    sub rsp, 2048

    # url is in rcx
    # Layout in [rsp]:
    # [rsp + 0 .. 47]   = shadow space
    # [rsp + 64 .. 319] = host_buf (256 bytes)
    # [rsp + 320 .. 831] = path_buf (512 bytes)
    # [rsp + 832 .. 1855] = req_buf (1024 bytes)

    # 1. Skip "http://" if present
    mov r12, rcx
    cmp byte ptr [r12], 'h'
    jne .hg_no_proto
    cmp byte ptr [r12 + 1], 't'
    jne .hg_no_proto
    cmp byte ptr [r12 + 2], 't'
    jne .hg_no_proto
    cmp byte ptr [r12 + 3], 'p'
    jne .hg_no_proto
    cmp byte ptr [r12 + 4], ':'
    jne .hg_no_proto
    cmp byte ptr [r12 + 5], '/'
    jne .hg_no_proto
    cmp byte ptr [r12 + 6], '/'
    jne .hg_no_proto
    add r12, 7
.hg_no_proto:

    # 2. Extract host and optional port and path
    # r12 points to start of host
    # Scan until '/', ':', or '\0'
    lea rdi, [rsp + 64]   # host_buf
    xor ecx, ecx         # i = 0
    mov r13, 80          # default port = 80
.hg_host_loop:
    mov al, [r12 + rcx]
    test al, al
    jz .hg_host_end_nul
    cmp al, '/'
    je .hg_host_end_slash
    cmp al, ':'
    je .hg_host_end_colon
    mov [rdi + rcx], al
    inc rcx
    cmp rcx, 250
    jb .hg_host_loop
    jmp .hg_host_end_nul

.hg_host_end_colon:
    mov byte ptr [rdi + rcx], 0
    lea rdx, [r12 + rcx + 1] # port start
    # Parse port until '/' or '\0'
    mov rcx, rdx
    call atoi
    test eax, eax
    jz 1f
    mov r13, rax
1:
    # Find '/' in remainder of url
.hg_scan_slash:
    cmp byte ptr [rdx], 0
    jz .hg_path_default
    cmp byte ptr [rdx], '/'
    je .hg_have_slash
    inc rdx
    jmp .hg_scan_slash

.hg_host_end_slash:
    mov byte ptr [rdi + rcx], 0
    lea rdx, [r12 + rcx]
    jmp .hg_have_slash

.hg_host_end_nul:
    mov byte ptr [rdi + rcx], 0
.hg_path_default:
    lea rdx, [rip + http_default_path]

.hg_have_slash:
    # Copy path from rdx into [rsp + 320]
    lea rdi, [rsp + 320]
    xor ecx, ecx
2:  mov al, [rdx + rcx]
    mov [rdi + rcx], al
    test al, al
    jz 3f
    inc ecx
    cmp ecx, 500
    jb 2b
    mov byte ptr [rdi + rcx], 0
3:

    # Connect: tcp_connect_asm(host_buf, port)
    lea rcx, [rsp + 64]
    mov rdx, r13
    call tcp_connect_asm
    cmp rax, -1
    je .hg_fail
    mov rbx, rax     # rbx = sock

    # Format HTTP GET request into [rsp + 832]
    lea rcx, [rsp + 832]
    mov rdx, 1024
    lea r8,  [rip + http_req_fmt]
    lea r9,  [rsp + 320]  # path
    lea rax, [rsp + 64]   # host
    mov [rsp + 32], rax
    call snprintf

    # Get request length
    lea rcx, [rsp + 832]
    call strlen
    mov r8, rax

    # Send request
    mov rcx, rbx
    lea rdx, [rsp + 832]
    call tcp_send_asm

    # Allocate response buffer: 1MB
    mov rcx, 1048576
    xor rdx, rdx
    call gc_malloc
    mov r14, rax     # r14 = response buffer
    xor r15, r15     # total received = 0

.hg_read_loop:
    mov rcx, rbx
    lea rdx, [r14 + r15]
    mov r8,  4096
    xor r9,  r9
    call recv
    test eax, eax
    jle .hg_read_done
    add r15, rax
    cmp r15, 1040000
    jae .hg_read_done
    jmp .hg_read_loop

.hg_read_done:
    mov byte ptr [r14 + r15], 0
    mov rcx, rbx
    call closesocket
    mov rax, r14
    jmp .hg_exit

.hg_fail:
    lea rax, [rip + empty_str]

.hg_exit:
    lea rsp, [rbp - 48]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    pop rbp
    ret

op_net_tcp_connect:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # host_reg
    mov r9,  [rsi+16]    # port_reg
    add rsi, 24

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + empty_str]
2:
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0

    push rsi
    push rdi
    push rbx
    push r12
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    call tcp_connect_asm

    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    pop rdi
    pop rsi

    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_net_tcp_send:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # sock_reg
    mov r9,  [rsi+16]    # data_reg
    add rsi, 24

    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    test rcx, rcx
    jz .tcps_err
    cmp rcx, -1
    je .tcps_err

    mov rdx, [rbx + r9 * 8]
    test rdx, rdx
    jnz 1f
    mov rdx, [rdi + r9 * 8]
1:
    test rdx, rdx
    jnz 2f
    lea rdx, [rip + empty_str]
2:
    mov r13, rcx     # sock
    mov r14, rdx     # data
    mov r10, 0x535452494E47
    cmp [r14 - 32], r10
    je .tcps_fast_len
    # Fast inline scan for null terminator
    mov r15, r14
1:  cmp byte ptr [r15], 0
    je 2f
    inc r15
    jmp 1b
2:  sub r15, r14
    jmp .tcps_len_ready
.tcps_fast_len:
    cvttsd2si r15, [r14 - 16]
.tcps_len_ready:
    sub rsp, 40
    mov rcx, r13
    mov rdx, r14
    mov r8,  r15
    xor r9d, r9d
    call send
    add rsp, 40

    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

.tcps_err:
    mov rax, -1
    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_net_tcp_recv:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # sock_reg
    mov r9,  [rsi+16]    # max_len_reg
    add rsi, 24

    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    movsd xmm1, [rdi + r9 * 8]
    cvttsd2si rdx, xmm1
    test rcx, rcx
    jz .tcpr_err
    cmp rcx, -1
    je .tcpr_err
    test rdx, rdx
    jle .tcpr_err

    mov r13, rcx         # sock
    mov r15, rdx         # max_len

    # Inlined bump allocation for recv buffer:
    lea rcx, [r15 + 1]
    lea r8, [rcx + 63]
    and r8, -16
    mov rax, [rip + arena_bump]
    lea r9, [rax + r8]
    cmp r9, [rip + arena_limit]
    ja .tcpr_fallback_alloc
    mov [rip + arena_bump], r9
    mov qword ptr [rax], 0
    mov qword ptr [rax + 16], 0  # type tag 0
    mov [rax + 24], rcx          # capacity
    add rax, 48
    mov r14, rax
    jmp .tcpr_do_recv

.tcpr_fallback_alloc:
    push rsi
    push rdi
    push rbx
    push r12
    push r13
    push r15
    sub rsp, 32
    lea rcx, [r15 + 1]
    xor rdx, rdx
    call gc_malloc
    add rsp, 32
    pop r15
    pop r13
    pop r12
    pop rbx
    pop rdi
    pop rsi
    mov r14, rax

.tcpr_do_recv:
    sub rsp, 40
    mov rcx, r13
    mov rdx, r14
    mov r8,  r15
    xor r9d, r9d
    call recv
    add rsp, 40

    test eax, eax
    jle .tcpr_recv_none
    mov byte ptr [r14 + rax], 0
    mov r10, 0x535452494E47
    mov [r14 - 32], r10
    cvtsi2sd xmm0, rax
    movsd [r14 - 16], xmm0
    mov rax, r14
    jmp .tcpr_store

.tcpr_recv_none:
    mov byte ptr [r14], 0
    mov r10, 0x535452494E47
    mov [r14 - 32], r10
    xorps xmm0, xmm0
    movsd [r14 - 16], xmm0
    mov rax, r14

.tcpr_store:
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

.tcpr_err:
    lea rax, [rip + empty_str]
    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_net_tcp_close:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # sock_reg
    add rsi, 16

    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    test rcx, rcx
    jz .tcpc_already_closed
    cmp rcx, -1
    je .tcpc_already_closed

    push rsi
    push rdi
    push rbx
    push r12
    push r8              # preserve sock_reg
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    call tcp_close_asm

    mov rsp, rbp
    pop rbp
    pop r8               # restore sock_reg
    pop r12
    pop rbx
    pop rdi
    pop rsi

    # Zero out socket register
    mov qword ptr [rdi + r8 * 8], 0
    mov qword ptr [rbx + r8 * 8], 0

.tcpc_already_closed:
    xor eax, eax
    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_net_tcp_listen:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # port_reg
    add rsi, 16

    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0

    push rsi
    push rdi
    push rbx
    push r12
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    call tcp_listen_asm

    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    pop rdi
    pop rsi

    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_net_tcp_accept:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # sock_reg
    add rsi, 16

    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0

    push rsi
    push rdi
    push rbx
    push r12
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    call tcp_accept_asm

    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    pop rdi
    pop rsi

    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_net_http_get:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # url_reg
    add rsi, 16

    mov rcx, [rbx + r8 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r8 * 8]
1:
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + empty_str]
2:
    push rsi
    push rdi
    push rbx
    push r12
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    call http_get_asm

    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    pop rdi
    pop rsi

    mov [rbx + r12 * 8], rax
    mov [rdi + r12 * 8], rax
    NEXT

op_push_try:
    mov rcx, [rsi]       # base reg (70)
    mov r8,  [rsi+8]     # catch offset
    add rsi, 16
    mov r9, [rbx + rcx * 8]
    lea rax, [r9 + r8]   # catch handler address
    mov r10, [rip + try_sp]
    cmp r10, 1020
    jae .try_stack_overflow
    lea r11, [rip + try_stack_rsi]
    mov [r11 + r10 * 8], rax
    lea r11, [rip + try_stack_call_sp]
    mov r12, [rip + call_sp]
    mov [r11 + r10 * 8], r12
    lea r11, [rip + try_stack_val_sp]
    mov r12, [rip + val_sp]
    mov [r11 + r10 * 8], r12
    inc r10
    mov [rip + try_sp], r10
    NEXT

op_pop_try:
    mov r10, [rip + try_sp]
    test r10, r10
    jle .pop_try_done
    dec r10
    mov [rip + try_sp], r10
.pop_try_done:
    NEXT

op_push_defer:
    mov rcx, [rsi]       # base reg (70)
    mov r8,  [rsi+8]     # offset
    add rsi, 16
    mov r9, [rbx + rcx * 8]
    lea rax, [r9 + r8]
    mov r10, [rip + defer_sp]
    cmp r10, 1020
    jae .defer_stack_overflow
    lea r11, [rip + defer_stack_rsi]
    mov [r11 + r10 * 8], rax
    lea r11, [rip + defer_stack_call_sp]
    mov r12, [rip + call_sp]
    mov [r11 + r10 * 8], r12
    inc r10
    mov [rip + defer_sp], r10
    NEXT

op_pop_run_defers:
    mov r10, [rip + defer_sp]
    test r10, r10
    jz .run_defers_done
    dec r10
    lea r11, [rip + defer_stack_call_sp]
    mov r12, [r11 + r10 * 8]
    mov r13, [rip + call_sp]
    cmp r12, r13
    jl .run_defers_done

    # Defer matches current call_sp
    mov [rip + defer_sp], r10
    lea r11, [rip + defer_stack_rsi]
    mov rax, [r11 + r10 * 8]     # defer subroutine address

    # Save r0 if not already saved
    cmp qword ptr [rip + defer_active], 0
    jnz .skip_save_ret
    mov r14, [rdi + 0 * 8]
    mov [rip + saved_ret_f], r14
    mov r14, [rbx + 0 * 8]
    mov [rip + saved_ret_p], r14
    mov qword ptr [rip + defer_active], 1
.skip_save_ret:

    # Push return address (pointing back to op_pop_run_defers) onto call_stack
    lea r11, [rip + call_sp]
    mov r12, [r11]
    lea r14, [rip + call_stack]
    lea r15, [rsi - 8]
    mov [r14 + r12 * 8], r15
    inc r12
    mov [r11], r12

    mov rsi, rax
    NEXT

.run_defers_done:
    cmp qword ptr [rip + defer_active], 0
    jz .no_restore_ret
    mov r14, [rip + saved_ret_f]
    mov [rdi + 0 * 8], r14
    mov r14, [rip + saved_ret_p]
    mov [rbx + 0 * 8], r14
    mov qword ptr [rip + defer_active], 0
.no_restore_ret:
    NEXT

op_throw:
    mov r8, [rsi]        # register containing thrown value
    add rsi, 8
    mov rax, [rdi + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rbx + r8 * 8]
1:
    mov [rip + thrown_val], rax

    mov r10, [rip + try_sp]
    test r10, r10
    jnz .has_try_handler

    # Uncaught exception
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    lea rcx, [rip + str_uncaught_exc]
    call printf
    mov rdx, [rip + thrown_val]
    lea rcx, [rip + str_fmt]
    call printf
    lea rcx, [rip + str_exc_newline]
    call printf
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    mov rcx, 1
    call exit

.has_try_handler:
    dec r10
    mov [rip + try_sp], r10

    lea r11, [rip + try_stack_rsi]
    mov rax, [r11 + r10 * 8]
    mov [rip + throw_target_catch_rsi], rax

    lea r11, [rip + try_stack_call_sp]
    mov rax, [r11 + r10 * 8]
    mov [rip + throw_target_call_sp], rax

    lea r11, [rip + try_stack_val_sp]
    mov rax, [r11 + r10 * 8]
    mov [rip + throw_target_val_sp], rax

    jmp op_throw_defer_resume

op_throw_defer_resume:
    mov r10, [rip + defer_sp]
    test r10, r10
    jz .throw_all_defers_done
    dec r10
    lea r11, [rip + defer_stack_call_sp]
    mov r12, [r11 + r10 * 8]
    mov r13, [rip + throw_target_call_sp]
    cmp r12, r13
    jl .throw_all_defers_done

    # Run this defer!
    mov [rip + defer_sp], r10
    lea r11, [rip + defer_stack_rsi]
    mov rax, [r11 + r10 * 8]

    lea r11, [rip + call_sp]
    mov r12, [r11]
    lea r14, [rip + call_stack]
    lea r15, [rip + throw_defer_resume_op]
    mov [r14 + r12 * 8], r15
    inc r12
    mov [r11], r12
    mov rsi, rax
    NEXT

.throw_all_defers_done:
    # All defers finished! Restore call_sp and val_sp
    mov r12, [rip + throw_target_call_sp]
    mov [rip + call_sp], r12
    mov r13, [rip + throw_target_val_sp]
    mov [rip + val_sp], r13

    # Push thrown value onto val_stack
    mov rax, [rip + thrown_val]
    lea r9, [rip + val_stack]
    mov [r9 + r13 * 8], rax
    inc r13
    mov [rip + val_sp], r13

    # Jump to catch handler
    mov rsi, [rip + throw_target_catch_rsi]
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
    movsd xmm1, [rdi + r9 * 8]
    xorpd xmm2, xmm2
    ucomisd xmm1, xmm2
    jp .div_do_op
    jne .div_do_op
    jmp .err_div_zero
.div_do_op:
    movsd xmm0, [rdi + r8 * 8]
    divsd xmm0, xmm1
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_gt:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    movsd xmm0, [rdi + r8 * 8]
    movsd xmm1, [rdi + r9 * 8]
    comisd xmm0, xmm1
    seta al
    movzx eax, al
    neg rax
    mov r10, 0x3FF0000000000000
    and rax, r10
    mov [rdi + rcx * 8], rax
    NEXT

op_neq:
    mov rcx, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    mov rdx, [rbx + r9 * 8]
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r9 * 8]
2:
    mov r10, 0x7FF0000000000000
    test rax, r10
    jnz .neq_float
    cmp rax, 0x10000
    jb .neq_float
    mov r10, 0x00007FFFFFFFFFFF
    cmp rax, r10
    ja .neq_float
    mov r10, 0x7FF0000000000000
    test rdx, r10
    jnz .neq_float
    cmp rdx, 0x10000
    jb .neq_float
    mov r10, 0x00007FFFFFFFFFFF
    cmp rdx, r10
    ja .neq_float
    push rsi
    push rdi
    push rbx
    push rcx
    sub rsp, 32
    mov rcx, rax
    call strcmp
    add rsp, 32
    pop rcx
    pop rbx
    pop rdi
    pop rsi
    test eax, eax
    setne al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT
.neq_float:
    cmp rax, rdx
    setne al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_mov:
    mov rcx, [rsi]; mov r8, [rsi+8]; add rsi, 16
    mov rax, [rdi + r8 * 8]
    mov [rdi + rcx * 8], rax
    mov [rbx + rcx * 8], rax
    NEXT

op_not:
    mov rcx, [rsi]; mov r8, [rsi+8]; add rsi, 16
    mov rax, [rdi + r8 * 8]
    add rax, rax
    setz al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_and:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    mov rax, [rdi + r8 * 8]
    mov rdx, [rdi + r9 * 8]
    add rax, rax
    setne al
    add rdx, rdx
    setne dl
    and al, dl
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_or:
    mov rcx, [rsi]; mov r8, [rsi+8]; mov r9, [rsi+16]; add rsi, 24
    mov rax, [rdi + r8 * 8]
    mov rdx, [rdi + r9 * 8]
    add rax, rax
    add rdx, rdx
    or rax, rdx
    setne al
    and eax, 1
    cvtsi2sd xmm0, eax
    movsd [rdi + rcx * 8], xmm0
    NEXT

op_store_ptr:
    mov rcx, [rsi]; mov r8, [rsi+8]; add rsi, 16
    mov rax, [rbx + rcx * 8]   # rax = pointer
    test rax, rax
    jnz 1f
    mov rax, [rdi + rcx * 8]
1:
    test rax, rax
    jz .store_ptr_null
    mov rdx, [rbx + r8 * 8]    # rdx = value
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r8 * 8]
2:
    mov [rax], rdx
.store_ptr_null:
    NEXT

op_load_ptr:
    mov rcx, [rsi]; mov r8, [rsi+8]; add rsi, 16
    mov rax, [rbx + r8 * 8]    # rax = pointer
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .load_ptr_null
    mov rdx, [rax]
    mov [rbx + rcx * 8], rdx
    mov [rdi + rcx * 8], rdx
    NEXT
.load_ptr_null:
    xor eax, eax
    mov [rbx + rcx * 8], rax
    mov [rdi + rcx * 8], rax
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
    mov r8,  [rsi+8]     # ptr_reg
    mov r9,  [rsi+16]    # offset_reg (float bank)
    add rsi, 24
    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .load_f_null
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0        # offset
    test rdx, rdx
    js .load_f_null
    mov r10, [rax + rdx]       # load 64-bit value
    mov [rdi + rcx * 8], r10   # store in float bank
    mov [rbx + rcx * 8], r10   # store in pointer bank
    NEXT
.load_f_null:
    xor r10, r10
    mov [rdi + rcx * 8], r10
    mov [rbx + rcx * 8], r10
    NEXT

op_store_f:
    mov r8,  [rsi]       # ptr_reg
    mov r9,  [rsi+8]     # offset_reg (float bank)
    mov r10, [rsi+16]    # val_reg (float bank)
    add rsi, 24
    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .store_f_null
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0        # offset
    test rdx, rdx
    js .store_f_null
    mov r11, [rbx + r10 * 8]
    test r11, r11
    jnz 2f
    mov r11, [rdi + r10 * 8]
2:
    mov [rax + rdx], r11       # store 64-bit value
.store_f_null:
    NEXT

op_index_get:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # ptr_reg
    mov r9,  [rsi+16]    # key_reg
    add rsi, 24
    cmp r12, 8192
    jae .dict_get_null
    cmp r8, 8192
    jae .dict_get_null
    cmp r9, 8192
    jae .dict_get_null

    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .dict_get_null
    cmp rax, 0x10000
    jb .dict_get_null

    cmp qword ptr [rax - 32], 1   # type tag == 1 (Dictionary)?
    je 3f
    mov r10, 0x44494354          # "DICT"?
    cmp [rax - 32], r10
    jne .idx_get_array
3:

    # DICTIONARY GET:
    mov r10, rax
    mov r11, [rbx + r9 * 8]
    test r11, r11
    jnz 2f
    mov r11, [rdi + r9 * 8]
2:
    test r11, r11
    jz .dict_get_not_found
    jmp .dict_get_loop_start

.idx_get_array:
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0
    test rdx, rdx
    js .idx_get_oob
    cmp rdx, [rax - 8]
    jae .idx_get_oob
    mov rax, [rax + rdx * 8]
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax
    NEXT

.idx_get_oob:
    xor eax, eax
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax
    NEXT

op_index_set:
    mov r8,  [rsi]       # ptr_reg
    mov r9,  [rsi+8]     # key_reg
    mov r10, [rsi+16]    # val_reg
    add rsi, 24
    cmp r8, 8192
    jae .idx_set_done
    cmp r9, 8192
    jae .idx_set_done
    cmp r10, 8192
    jae .idx_set_done

    mov rax, [rbx + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rdi + r8 * 8]
1:
    test rax, rax
    jz .idx_set_done
    cmp rax, 0x10000
    jb .idx_set_done

    cmp qword ptr [rax - 32], 1   # type tag == 1 (Dictionary)?
    je 4f
    mov r10, 0x44494354          # "DICT"?
    cmp [rax - 32], r10
    jne .idx_set_array
4:

    # DICTIONARY SET:
    mov r14, [rbx + r10 * 8]
    test r14, r14
    jnz 2f
    mov r14, [rdi + r10 * 8]
2:
    mov r11, [rbx + r9 * 8]
    test r11, r11
    jnz 3f
    mov r11, [rdi + r9 * 8]
3:
    mov r10, rax
    jmp .dict_set_loop_start

.idx_set_array:
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rdx, xmm0
    test rdx, rdx
    js .idx_set_done
    mov rcx, [rax - 24]          # array capacity in bytes
    lea r13, [rdx * 8 + 8]
    cmp r13, rcx
    ja .idx_set_done             # prevent out-of-bounds write past buffer
    mov r11, [rbx + r10 * 8]
    test r11, r11
    jnz 4f
    mov r11, [rdi + r10 * 8]
4:
    mov [rax + rdx * 8], r11
    mov r14, [rax - 8]
    inc rdx
    cmp rdx, r14
    jle .idx_set_done
    mov [rax - 8], rdx
    cvtsi2sd xmm1, rdx
    movsd [rax - 16], xmm1
.idx_set_done:
    NEXT

op_gpu_dispatch:
    mov r12, [rsi]       # dest
    mov r8,  [rsi+8]     # op_reg
    mov r9,  [rsi+16]    # args_reg
    add rsi, 24

    push rsi
    push rdi
    push rbx
    push r12
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 48

    mov rcx, r12
    mov rdx, r8
    mov r8,  r9
    mov r9,  rdi
    call asm_gpu_dispatch

    mov rsp, rbp
    pop rbp
    pop r12
    pop rbx
    pop rdi
    pop rsi
    mov rax, [rdi + r12 * 8]
    mov [rbx + r12 * 8], rax
    NEXT

op_load_ptr_o:
    mov r8, [rsi]; mov r9, [rsi+8]; mov r10, [rsi+16]; add rsi, 24
    mov rax, [rdi + r9 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rbx + r9 * 8]
1:
    test rax, rax
    jz .lpo_null
    movsd xmm0, [rdi + r10 * 8]
    cvttsd2si rcx, xmm0
    test rcx, rcx
    js .lpo_null
    mov rdx, [rax + rcx]
    mov [rdi + r8 * 8], rdx
    mov [rbx + r8 * 8], rdx
    NEXT
.lpo_null:
    xor eax, eax
    mov [rdi + r8 * 8], rax
    mov [rbx + r8 * 8], rax
    NEXT

op_store_ptr_o:
    mov r8, [rsi]; mov r9, [rsi+8]; mov r10, [rsi+16]; add rsi, 24
    mov rax, [rdi + r8 * 8]
    test rax, rax
    jnz 1f
    mov rax, [rbx + r8 * 8]
1:
    test rax, rax
    jz .spo_null
    movsd xmm0, [rdi + r9 * 8]
    cvttsd2si rcx, xmm0
    test rcx, rcx
    js .spo_null
    mov rdx, [rdi + r10 * 8]
    test rdx, rdx
    jnz 2f
    mov rdx, [rbx + r10 * 8]
2:
    mov [rax + rcx], rdx
.spo_null:
    NEXT

op_push_ptr:
    mov rcx, [rsi]; add rsi, 8
    mov rax, [rdi + rcx * 8]
    mov rdx, [rip + ptr_sp]
    cmp rdx, 524280
    jae .ptr_stack_overflow
    lea r9, [rip + ptr_stack]
    mov [r9 + rdx * 8], rax
    inc rdx
    mov [rip + ptr_sp], rdx
    NEXT

op_pop_ptr:
    mov rcx, [rsi]; add rsi, 8
    mov rdx, [rip + ptr_sp]
    test rdx, rdx
    jle .ptr_stack_underflow
    dec rdx
    mov [rip + ptr_sp], rdx
    lea r9, [rip + ptr_stack]
    mov rax, [r9 + rdx * 8]
    mov [rdi + rcx * 8], rax
    NEXT

.ptr_stack_underflow:
    xor eax, eax
    mov [rdi + rcx * 8], rax
    NEXT

op_halt:
    jmp vm_exit

op_enum_tag:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov r10, [rdi + r9 * 8]
    push rsi
    push rdi
    push rbx
    push r8
    push r10
    sub rsp, 40
    mov rcx, 32
    mov rdx, 0xAA01
    call gc_malloc
    add rsp, 40
    pop r10
    pop r8
    pop rbx
    pop rdi
    pop rsi
    mov [rax], r8
    mov qword ptr [rax + 8], 0xAA01
    mov qword ptr [rax + 16], 1
    mov [rax + 24], r10
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax
    NEXT

op_enum_get_tag:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16
    mov rax, [rdi + r8 * 8]
    test rax, rax
    jz .egt_zero
    mov r9, [rax]
    cvtsi2sd xmm0, r9
    movsd [rdi + r12 * 8], xmm0
    movq rax, xmm0
    mov [rbx + r12 * 8], rax
    NEXT
.egt_zero:
    xorpd xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    mov qword ptr [rbx + r12 * 8], 0
    NEXT

op_enum_get_field:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    mov r9,  [rsi+16]
    add rsi, 24
    mov rax, [rdi + r8 * 8]
    test rax, rax
    jz .egf_zero
    lea r10, [rax + 24]
    mov r11, [r10 + r9 * 8]
    mov [rdi + r12 * 8], r11
    mov [rbx + r12 * 8], r11
    NEXT
.egf_zero:
    mov qword ptr [rdi + r12 * 8], 0
    mov qword ptr [rbx + r12 * 8], 0
    NEXT

op_region_enter:
    mov rax, [rip + region_scope_depth]
    cmp rax, 250
    jae .re_skip
    lea r10, [rip + region_scope_stack]
    mov r11, [rip + region_arena_bump]
    mov [r10 + rax * 8], r11
    inc qword ptr [rip + region_scope_depth]
.re_skip:
    NEXT

op_region_leave:
    mov rax, [rip + region_scope_depth]
    test rax, rax
    jz .rl_skip
    dec rax
    mov [rip + region_scope_depth], rax
    lea r10, [rip + region_scope_stack]
    mov r11, [r10 + rax * 8]
    mov [rip + region_arena_bump], r11
    inc qword ptr [rip + global_generation]
.rl_skip:
    NEXT

op_gen_check:
    mov r8, [rsi]
    mov r9, [rsi+8]
    add rsi, 16
    mov rax, [rdi + r8 * 8]
    test rax, rax
    jz .gc_ok
    mov r10, [rip + region_arena_base]
    cmp rax, r10
    jb .gc_ok
    cmp rax, [rip + region_arena_limit]
    jae .gc_ok
    cmp rax, [rip + region_arena_bump]
    jb .gc_ok
    call report_runtime_use_after_free
    mov ecx, 1
    call exit
.gc_ok:
    NEXT

op_region_alloc:
    mov r12, [rsi]
    mov r8,  [rsi+8]
    add rsi, 16
    movsd xmm0, [rdi + r8 * 8]
    cvttsd2si rcx, xmm0
    test rcx, rcx
    jg 1f
    mov rcx, 16
1:
    lea rcx, [rcx + 15]
    and rcx, -16
    mov rax, [rip + region_arena_bump]
    lea r10, [rax + rcx]
    cmp r10, [rip + region_arena_limit]
    ja .ra_oom
    mov [rip + region_arena_bump], r10
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax
    NEXT
.ra_oom:
    push rsi
    push rdi
    push rbx
    sub rsp, 40
    call malloc
    add rsp, 40
    pop rbx
    pop rdi
    pop rsi
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax
    NEXT

.globl report_runtime_use_after_free
report_runtime_use_after_free:
    sub rsp, 40
    mov rcx, [rip + cli_source_file]
    test rcx, rcx
    jnz 1f
    lea rcx, [rip + str_default_src]
1:
    mov rdx, rcx
    lea rcx, [rip + str_uaf_err]
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    ret
    jmp vm_exit

# ============================================================================
# PHASE 3: CONCURRENCY, ASYNCHRONOUS I/O & ACTOR NETWORKING
# ============================================================================

ensure_scheduler_init:
    cmp qword ptr [rip + scheduler_initialized], 1
    je .esi_done
    mov qword ptr [rip + scheduler_initialized], 1
    
    lea rax, [rip + main_fcb]
    mov qword ptr [rax + 0], 0       # fid = 0
    mov qword ptr [rax + 8], 1       # state = 1 (RUNNING)
    mov qword ptr [rax + 96], 0      # call_sp_base = 0
    mov qword ptr [rax + 104], 0     # return_val = 0
    mov qword ptr [rax + 112], -1    # waiter_fid = -1
    mov qword ptr [rax + 120], 0     # saved call_sp
    
    lea rdx, [rip + fiber_table]
    mov [rdx], rax                   # fiber_table[0] = &main_fcb
    mov qword ptr [rip + current_fiber_id], 0
    mov qword ptr [rip + fiber_count], 1
    mov qword ptr [rip + ready_head], 0
    mov qword ptr [rip + ready_tail], 0
    mov qword ptr [rip + ready_count], 0
.esi_done:
    ret

# fiber_switch_context(from_fcb: rcx, to_fcb: rdx)
fiber_switch_context:
    # Save current CPU non-volatile registers to from_fcb
    mov [rcx + 16], rsp
    mov [rcx + 24], rbp
    mov [rcx + 32], rbx
    mov [rcx + 40], r12
    mov [rcx + 48], r13
    mov [rcx + 56], r14
    mov [rcx + 64], r15
    mov [rcx + 72], rsi
    mov [rcx + 80], rdi
    
    # Save VM call stack depth
    mov rax, [rip + call_sp]
    mov [rcx + 120], rax
    
    # Restore CPU non-volatile registers from to_fcb
    mov rsp, [rdx + 16]
    mov rbp, [rdx + 24]
    mov rbx, [rdx + 32]
    mov r12, [rdx + 40]
    mov r13, [rdx + 48]
    mov r14, [rdx + 56]
    mov r15, [rdx + 64]
    mov rsi, [rdx + 72]
    mov rdi, [rdx + 80]
    
    # Restore VM call stack depth
    mov rax, [rdx + 120]
    mov [rip + call_sp], rax
    ret

fiber_entry_trampoline:
    mov r8, [rip + current_fiber_id]
    lea rax, [rip + fiber_table]
    mov rcx, [rax + r8 * 8]     # rcx = current FCB
    mov r10, [rcx + 96]         # call_sp_base
    mov [rip + call_sp], r10
    NEXT

.fiber_terminate:
    mov r8, [rip + current_fiber_id]
    lea rax, [rip + fiber_table]
    mov rcx, [rax + r8 * 8]     # rcx = current FCB
    
    # Record return value from r0
    mov r9, [rdi + 0 * 8]
    mov [rcx + 104], r9
    mov qword ptr [rcx + 8], 3  # state = 3 (TERMINATED)
    
    # Wake up waiter if any
    mov r10, [rcx + 112]        # waiter_fid
    cmp r10, -1
    je .fiber_sched_next
    mov r11, [rax + r10 * 8]    # waiter FCB
    test r11, r11
    jz .fiber_sched_next
    mov qword ptr [r11 + 8], 0  # waiter state = READY
    
    mov rax, [rip + ready_tail]
    lea rdx, [rip + fiber_ready_queue]
    mov [rdx + rax * 8], r10
    inc rax
    and rax, 8191
    mov [rip + ready_tail], rax
    inc qword ptr [rip + ready_count]

.fiber_sched_next:
    mov rax, [rip + ready_count]
    test rax, rax
    jz .fiber_switch_main
    
    mov r8, [rip + ready_head]
    lea rdx, [rip + fiber_ready_queue]
    mov r9, [rdx + r8 * 8]      # next_fid
    inc r8
    and r8, 8191
    mov [rip + ready_head], r8
    dec qword ptr [rip + ready_count]
    
    mov [rip + current_fiber_id], r9
    lea rax, [rip + fiber_table]
    mov rdx, [rax + r9 * 8]     # to_fcb
    mov qword ptr [rdx + 8], 1  # state = RUNNING
    call fiber_switch_context
    NEXT

.fiber_switch_main:
    mov qword ptr [rip + current_fiber_id], 0
    lea rax, [rip + fiber_table]
    mov rdx, [rax]              # main FCB
    mov qword ptr [rdx + 8], 1  # state = RUNNING
    call fiber_switch_context
    NEXT

op_fiber_spawn:
    mov r12, [rsi]       # dest_reg
    mov r13, [rsi+8]     # fn_reg
    add rsi, 16
    
    call ensure_scheduler_init
    
    # Allocate 128-byte FCB
    mov rcx, 128
    sub rsp, 40
    call malloc
    add rsp, 40
    mov r15, rax         # r15 = new FCB
    
    mov rax, [rip + fiber_count]
    mov [r15 + 0], rax   # fcb->fid
    inc qword ptr [rip + fiber_count]
    mov qword ptr [r15 + 8], 0   # state = READY
    
    mov rdx, [r15 + 0]
    shl rdx, 10          # fid * 1024
    mov [r15 + 96], rdx  # call_sp_base
    mov qword ptr [r15 + 104], 0 # return_val
    mov qword ptr [r15 + 112], -1 # waiter_fid
    mov [r15 + 120], rdx # initial call_sp
    
    # Resolve target PC from fn_reg (r13)
    movsd xmm0, [rdi + r13 * 8]
    cvttsd2si r14, xmm0
    test r14, r14
    jnz .f_have_offset
    
    mov r14, [rdi + r13 * 8]
    mov r8, 0x00007FFFFFFFFFFF
    cmp r14, 0x10000
    jb .f_have_offset
    cmp r14, r8
    jbe .f_have_direct_ptr

.f_have_offset:
    mov r10, [rip + active_dynamic_buf]
    test r10, r10
    jnz 4f
    mov r10, [rbx + 70 * 8]
    test r10, r10
    jnz 4f
    mov r10, [rdi + 70 * 8]
    test r10, r10
    jnz 4f
    mov r10, [rip + vm_bytecode_base]
4:
    lea rax, [r10 + r14]
    jmp 5f

.f_have_direct_ptr:
    mov rax, r14

5:
    mov [r15 + 72], rax  # saved_rsi = target PC
    
    # Allocate 4KB stack
    mov rcx, 4096
    sub rsp, 40
    call malloc
    add rsp, 40
    mov [r15 + 88], rax  # stack_base
    lea rdx, [rax + 4096]
    and rdx, -16         # 16-byte align
    sub rdx, 48          # shadow space (32) + ret addr (8) + align (8)
    lea r11, [rip + fiber_entry_trampoline]
    mov [rdx], r11
    mov [r15 + 16], rdx  # saved_rsp
    mov [r15 + 24], rdx  # saved_rbp
    mov [r15 + 32], rbx  # saved_rbx
    mov [r15 + 80], rdi  # saved_rdi
    
    # Store into fiber_table
    mov rdx, [r15 + 0]   # fid
    lea rax, [rip + fiber_table]
    mov [rax + rdx * 8], r15
    
    # Enqueue to fiber_ready_queue
    mov rax, [rip + ready_tail]
    lea rcx, [rip + fiber_ready_queue]
    mov [rcx + rax * 8], rdx
    inc rax
    and rax, 8191
    mov [rip + ready_tail], rax
    inc qword ptr [rip + ready_count]
    
    # Return fid to dest_reg
    cvtsi2sd xmm0, rdx
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_fiber_yield:
    mov rax, [rip + ready_count]
    test rax, rax
    jz .yield_noop
    
    mov r8, [rip + current_fiber_id]
    mov rax, [rip + ready_tail]
    lea rdx, [rip + fiber_ready_queue]
    mov [rdx + rax * 8], r8
    inc rax
    and rax, 8191
    mov [rip + ready_tail], rax
    inc qword ptr [rip + ready_count]
    
    mov r8, [rip + ready_head]
    lea rdx, [rip + fiber_ready_queue]
    mov r9, [rdx + r8 * 8]       # next_fid
    inc r8
    and r8, 8191
    mov [rip + ready_head], r8
    dec qword ptr [rip + ready_count]
    
    lea rax, [rip + fiber_table]
    mov r10, [rip + current_fiber_id]
    mov rcx, [rax + r10 * 8]     # from_fcb
    mov rdx, [rax + r9 * 8]      # to_fcb
    mov qword ptr [rcx + 8], 0   # state = READY
    mov qword ptr [rdx + 8], 1   # state = RUNNING
    mov [rip + current_fiber_id], r9
    call fiber_switch_context

.yield_noop:
    NEXT

op_fiber_await:
    mov r12, [rsi]       # dest_reg
    mov r13, [rsi+8]     # fid_reg
    add rsi, 16
    
    movsd xmm0, [rdi + r13 * 8]
    cvttsd2si r14, xmm0
    test r14, r14
    jnz 1f
    mov r14, [rbx + r13 * 8]
1:
    lea rax, [rip + fiber_table]
    mov rcx, [rax + r14 * 8]     # target FCB
    test rcx, rcx
    jz .await_bad_fid
    
.await_check_state:
    cmp qword ptr [rcx + 8], 3   # TERMINATED?
    je .await_finished
    
    mov r8, [rip + current_fiber_id]
    mov [rcx + 112], r8          # target->waiter_fid = current_fiber_id
    lea rax, [rip + fiber_table]
    mov r9, [rax + r8 * 8]       # current FCB
    mov qword ptr [r9 + 8], 2    # state = BLOCKED
    
    mov rax, [rip + ready_count]
    test rax, rax
    jz .await_spin
    
    mov r8, [rip + ready_head]
    lea rdx, [rip + fiber_ready_queue]
    mov r10, [rdx + r8 * 8]
    inc r8
    and r8, 8191
    mov [rip + ready_head], r8
    dec qword ptr [rip + ready_count]
    
    mov [rip + current_fiber_id], r10
    lea rax, [rip + fiber_table]
    mov rdx, [rax + r10 * 8]     # to_fcb
    mov qword ptr [rdx + 8], 1   # state = RUNNING
    mov rcx, r9                  # from_fcb
    call fiber_switch_context
    
    lea rax, [rip + fiber_table]
    mov rcx, [rax + r14 * 8]
    jmp .await_check_state

.await_spin:
    pause
    jmp .await_check_state

.await_finished:
    mov rax, [rcx + 104]         # return_val
    mov [rdi + r12 * 8], rax
    NEXT

.await_bad_fid:
    xorps xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    NEXT

# ---------------------------------------------------------
# LOCK-FREE MESSAGE CHANNELS (CSP / Actor Model)
# ---------------------------------------------------------

op_chan_new:
    mov r12, [rsi]       # dest_reg
    mov r13, [rsi+8]     # cap_reg
    add rsi, 16
    
    movsd xmm0, [rdi + r13 * 8]
    cvttsd2si r8, xmm0
    test r8, r8
    jg 1f
    mov r8, 64
1:
    mov rax, 16
.cn_pow2:
    cmp rax, r8
    jae .cn_pow2_done
    shl rax, 1
    jmp .cn_pow2
.cn_pow2_done:
    mov r15, rax          # r15 = power of 2 capacity (non-volatile)
    
    mov rcx, r15
    shl rcx, 5           # * 32
    add rcx, 40          # + 40
    
    sub rsp, 40
    call malloc
    add rsp, 40
    mov r14, rax
    
    mov [r14 + 0], r15    # capacity
    lea rax, [r15 - 1]
    mov [r14 + 8], rax   # mask
    mov qword ptr [r14 + 16], 0 # head
    mov qword ptr [r14 + 24], 0 # tail
    mov qword ptr [r14 + 32], 0 # closed
    
    xor ecx, ecx
    lea rdx, [r14 + 40]
.cn_cell_init:
    cmp rcx, r15
    jge .cn_cell_done
    mov [rdx], rcx
    mov qword ptr [rdx + 8], 0
    mov qword ptr [rdx + 16], 0
    mov qword ptr [rdx + 24], 0
    add rdx, 32
    inc rcx
    jmp .cn_cell_init
.cn_cell_done:
    mov [rdi + r12 * 8], r14
    mov [rbx + r12 * 8], r14
    NEXT

op_chan_send:
    mov r12, [rsi]       # dest_reg
    mov r13, [rsi+8]     # chan_reg
    mov r14, [rsi+16]    # val_reg
    add rsi, 24
    
    mov rcx, [rbx + r13 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r13 * 8]
1:
    test rcx, rcx
    jz .cs_fail
    
    mov r8, [rdi + r14 * 8]
    mov r9, [rbx + r14 * 8]
    
.cs_retry:
    mov r10, [rcx + 16]         # head
    mov r11, [rcx + 8]          # mask
    mov rax, r10
    and rax, r11
    shl rax, 5
    lea rdx, [rcx + 40 + rax]   # cell
    
    mov rax, [rdx]              # cell->sequence
    mov r15, rax
    sub r15, r10
    test r15, r15
    jz .cs_try_cas
    js .cs_full
    pause
    jmp .cs_retry

.cs_try_cas:
    lea r15, [r10 + 1]
    mov rax, r10
    lock cmpxchg [rcx + 16], r15
    jnz .cs_retry
    
    mov [rdx + 8], r8
    mov [rdx + 16], r9
    inc r10
    mov [rdx], r10
    
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

.cs_full:
    xorps xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    NEXT

.cs_fail:
    xorps xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_chan_recv:
    mov r12, [rsi]       # dest_reg
    mov r13, [rsi+8]     # chan_reg
    add rsi, 16
    
    mov rcx, [rbx + r13 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r13 * 8]
1:
    test rcx, rcx
    jz .cr_fail

.cr_retry:
    mov r10, [rcx + 24]         # tail
    mov r11, [rcx + 8]          # mask
    mov rax, r10
    and rax, r11
    shl rax, 5
    lea rdx, [rcx + 40 + rax]   # cell
    
    mov rax, [rdx]              # cell->sequence
    lea r15, [r10 + 1]
    sub rax, r15
    test rax, rax
    jz .cr_try_cas
    js .cr_empty
    pause
    jmp .cr_retry

.cr_try_cas:
    lea r15, [r10 + 1]
    mov rax, r10
    lock cmpxchg [rcx + 24], r15
    jnz .cr_retry
    
    mov r8, [rdx + 8]
    
    mov rax, [rcx + 8]
    inc rax
    add rax, r10
    mov [rdx], rax
    
    mov [rdi + r12 * 8], r8
    NEXT

.cr_empty:
    cmp qword ptr [rcx + 32], 1
    je .cr_closed
    xorps xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    NEXT

.cr_closed:
    mov rax, -1
    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

.cr_fail:
    xorps xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_chan_len:
    mov r12, [rsi]       # dest_reg
    mov r13, [rsi+8]     # chan_reg
    add rsi, 16
    
    mov rcx, [rbx + r13 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r13 * 8]
1:
    test rcx, rcx
    jz .cl_zero
    
    mov rax, [rcx + 16]  # head
    sub rax, [rcx + 24]  # tail
    jns 2f
    xor eax, eax
2:
    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

.cl_zero:
    xorps xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_chan_close:
    mov r13, [rsi]       # chan_reg
    add rsi, 8
    
    mov rcx, [rbx + r13 * 8]
    test rcx, rcx
    jnz 1f
    mov rcx, [rdi + r13 * 8]
1:
    test rcx, rcx
    jz .cc_done
    mov qword ptr [rcx + 32], 1  # closed = 1
.cc_done:
    NEXT

# ---------------------------------------------------------
# HIGH-PERFORMANCE ASYNC EVENT LOOP (Windows IOCP)
# ---------------------------------------------------------

op_iocp_init:
    mov r12, [rsi]
    add rsi, 8
    
    call wsa_ensure_init
    
    mov rcx, -1
    xor edx, edx
    xor r8d, r8d
    xor r9d, r9d
    sub rsp, 40
    call CreateIoCompletionPort
    add rsp, 40
    mov [rip + iocp_global_handle], rax
    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_iocp_poll:
    mov r12, [rsi]       # dest_reg
    mov r13, [rsi+8]     # timeout_ms_reg
    add rsi, 16
    
    mov rax, [rip + iocp_global_handle]
    test rax, rax
    jnz 1f
    call wsa_ensure_init
    mov rcx, -1
    xor edx, edx
    xor r8d, r8d
    xor r9d, r9d
    sub rsp, 40
    call CreateIoCompletionPort
    add rsp, 40
    mov [rip + iocp_global_handle], rax
1:
    movsd xmm0, [rdi + r13 * 8]
    cvttsd2si r14, xmm0
    
    mov rcx, [rip + iocp_global_handle]
    lea rdx, [rip + iocp_bytes_transferred]
    lea r8,  [rip + iocp_completion_key]
    lea r9,  [rip + iocp_overlapped]
    sub rsp, 40
    mov [rsp + 32], r14
    call GetQueuedCompletionStatus
    add rsp, 40
    test eax, eax
    jz .ip_timeout
    
    mov eax, [rip + iocp_bytes_transferred]
    test eax, eax
    jnz 2f
    mov rax, [rip + iocp_completion_key]
2:
    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

.ip_timeout:
    xorps xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_async_listen:
    mov r12, [rsi]       # dest_reg
    mov r13, [rsi+8]     # port_reg
    mov r14, [rsi+16]    # backlog_reg
    add rsi, 24
    
    call wsa_ensure_init
    
    cmp qword ptr [rip + iocp_global_handle], 0
    jnz 1f
    mov rcx, -1
    xor edx, edx
    xor r8d, r8d
    xor r9d, r9d
    sub rsp, 40
    call CreateIoCompletionPort
    add rsp, 40
    mov [rip + iocp_global_handle], rax
1:
    movsd xmm0, [rdi + r13 * 8]
    cvttsd2si rcx, xmm0
    sub rsp, 40
    call tcp_listen_asm
    add rsp, 40
    cmp rax, -1
    je .al_fail
    
    mov r15, rax         # socket
    
    mov rcx, r15
    mov edx, 0x8004667E  # FIONBIO
    lea r8,  [rip + sock_nonblocking_mode]
    sub rsp, 40
    call ioctlsocket
    add rsp, 40
    
    mov rcx, r15
    mov rdx, [rip + iocp_global_handle]
    mov r8,  r15
    xor r9d, r9d
    sub rsp, 40
    call CreateIoCompletionPort
    add rsp, 40
    
    cvtsi2sd xmm0, r15
    movsd [rdi + r12 * 8], xmm0
    NEXT

.al_fail:
    mov rax, -1
    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_async_accept:
    mov r12, [rsi]       # dest_reg
    mov r13, [rsi+8]     # listen_sock_reg
    add rsi, 16
    
    movsd xmm0, [rdi + r13 * 8]
    cvttsd2si rcx, xmm0
    test rcx, rcx
    jnz 1f
    mov rcx, [rbx + r13 * 8]
1:
    xor edx, edx
    xor r8d, r8d
    sub rsp, 40
    call accept
    add rsp, 40
    cmp rax, -1
    je .aa_wouldblock
    
    mov r15, rax         # client socket
    
    mov rcx, r15
    mov edx, 0x8004667E  # FIONBIO
    lea r8,  [rip + sock_nonblocking_mode]
    sub rsp, 40
    call ioctlsocket
    add rsp, 40
    
    mov rcx, r15
    mov rdx, [rip + iocp_global_handle]
    mov r8,  r15
    xor r9d, r9d
    sub rsp, 40
    call CreateIoCompletionPort
    add rsp, 40
    
    mov rcx, [rip + iocp_global_handle]
    mov edx, 1
    mov r8,  r15
    xor r9d, r9d
    sub rsp, 40
    call PostQueuedCompletionStatus
    add rsp, 40
    
    cvtsi2sd xmm0, r15
    movsd [rdi + r12 * 8], xmm0
    NEXT

.aa_wouldblock:
    mov rax, -1
    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_async_recv:
    mov r12, [rsi]       # dest_reg
    mov r13, [rsi+8]     # sock_reg
    mov r14, [rsi+16]    # max_len_reg
    add rsi, 24
    
    movsd xmm0, [rdi + r13 * 8]
    cvttsd2si rcx, xmm0
    test rcx, rcx
    jnz 1f
    mov rcx, [rbx + r13 * 8]
1:
    mov r15, rcx
    
    movsd xmm0, [rdi + r14 * 8]
    cvttsd2si r8, xmm0
    test r8, r8
    jg 2f
    mov r8, 4096
2:
    push r15
    push r8
    push r12
    sub rsp, 32
    lea rcx, [r8 + 1]
    xor rdx, rdx
    call gc_malloc
    add rsp, 32
    pop r12
    pop r8
    pop r15
    mov r13, rax
    
    sub rsp, 40
    mov rcx, r15
    mov rdx, r13
    xor r9d, r9d
    call recv
    add rsp, 40
    cmp eax, 0
    jle .ar_empty
    
    mov byte ptr [r13 + rax], 0
    mov r10, 0x535452494E47
    mov [r13 - 32], r10
    cvtsi2sd xmm0, rax
    movsd [r13 - 16], xmm0
    mov [rdi + r12 * 8], r13
    mov [rbx + r12 * 8], r13
    NEXT

.ar_empty:
    lea rax, [rip + empty_str]
    mov [rdi + r12 * 8], rax
    mov [rbx + r12 * 8], rax
    NEXT

op_async_send:
    mov r12, [rsi]       # dest_reg
    mov r13, [rsi+8]     # sock_reg
    mov r14, [rsi+16]    # data_reg
    add rsi, 24
    
    movsd xmm0, [rdi + r13 * 8]
    cvttsd2si rcx, xmm0
    test rcx, rcx
    jnz 1f
    mov rcx, [rbx + r13 * 8]
1:
    mov r15, rcx
    
    mov rdx, [rbx + r14 * 8]
    test rdx, rdx
    jnz 2f
    mov rdx, [rdi + r14 * 8]
2:
    mov r8, rdx
.as_len_loop:
    cmp byte ptr [r8], 0
    je .as_len_done
    inc r8
    jmp .as_len_loop
.as_len_done:
    sub r8, rdx
    
    mov rcx, r15
    xor r9d, r9d
    sub rsp, 40
    call send
    add rsp, 40
    cmp rax, 0
    jle .as_fail
    
    mov rcx, [rip + iocp_global_handle]
    mov edx, eax
    mov r8,  r15
    xor r9d, r9d
    sub rsp, 40
    call PostQueuedCompletionStatus
    add rsp, 40
    
    cvtsi2sd xmm0, rax
    movsd [rdi + r12 * 8], xmm0
    NEXT

.as_fail:
    xorps xmm0, xmm0
    movsd [rdi + r12 * 8], xmm0
    NEXT

op_ret_dynamic:
    mov r8, [rip + current_fiber_id]
    test r8, r8
    jnz .fiber_op_ret_dynamic
    lea r8, [rip + call_sp]
    mov r9, [r8]
    test r9, r9
    jle .ret_dynamic_underflow
    dec r9
    mov [r8], r9
    lea r10, [rip + call_stack]
    mov rsi, [r10 + r9 * 8]
    NEXT

.fiber_op_ret_dynamic:
    lea rax, [rip + fiber_table]
    mov rcx, [rax + r8 * 8]
    mov r10, [rcx + 96]
    lea r8, [rip + call_sp]
    mov r9, [r8]
    cmp r9, r10
    jle .fiber_terminate
    dec r9
    mov [r8], r9
    lea r11, [rip + call_stack]
    mov rsi, [r11 + r9 * 8]
    NEXT

.ret_dynamic_underflow:
    jmp vm_exit

.ptr_stack_overflow:
    sub rsp, 40
    lea rcx, [rip + str_ptr_stack_overflow]
    call printf
    mov rcx, 0
    call fflush
    add rsp, 40
    jmp vm_exit


fast_fscanf:
    mov r11, [rip + asm_mem_ptr]
    test r11, r11
    jz .fast_scan_eof

.fast_scan_ws:
    mov al, byte ptr [r11]
    test al, al
    jz .fast_scan_eof
    cmp al, ' '
    jbe .fast_scan_ws_inc
    jmp .fast_scan_tok_start
.fast_scan_ws_inc:
    inc r11
    jmp .fast_scan_ws

.fast_scan_tok_start:
    mov r10, r8
.fast_scan_tok_loop:
    mov al, byte ptr [r11]
    test al, al
    jz .fast_scan_tok_done
    cmp al, ' '
    jbe .fast_scan_tok_done
    mov [r10], al
    inc r10
    inc r11
    jmp .fast_scan_tok_loop

.fast_scan_tok_done:
    mov byte ptr [r10], 0
    mov [rip + asm_mem_ptr], r11
    mov eax, 1
    ret

.fast_scan_eof:
    mov eax, -1
    ret

fast_fgetc:
    mov r11, [rip + asm_mem_ptr]
    test r11, r11
    jz .fast_fgetc_eof
    movzx eax, byte ptr [r11]
    test al, al
    jz .fast_fgetc_eof
    inc r11
    mov [rip + asm_mem_ptr], r11
    ret
.fast_fgetc_eof:
    mov eax, -1
    ret

.global crash_handler
crash_handler:
    push rbp
    mov rbp, rsp
    sub rsp, 80

    # Prevent recursive crash handler invocations
    cmp dword ptr [rip + in_crash_handler], 0
    jne .crash_direct_exit
    mov dword ptr [rip + in_crash_handler], 1

    # Check exception code
    mov rax, [rcx]       # rax = ExceptionRecord
    test rax, rax
    jz .crash_exit
    mov edx, [rax]       # ExceptionCode
    # Only handle actual fatal errors:
    # 0xC0000005 = STATUS_ACCESS_VIOLATION
    # Only handle actual fatal errors:
    # 0xC0000005 = STATUS_ACCESS_VIOLATION
    # 0xC000001D = STATUS_ILLEGAL_INSTRUCTION
    # 0xC00000FD = STATUS_STACK_OVERFLOW
    # 0xC0000094 = STATUS_INTEGER_DIVIDE_BY_ZERO
    # 0xC000008E = STATUS_FLOAT_DIVIDE_BY_ZERO
    cmp edx, 0xC0000005
    je .crash_handle_fatal
    cmp edx, 0xC000001D
    je .crash_handle_fatal
    cmp edx, 0xC00000FD
    je .crash_handle_fatal
    cmp edx, 0xC0000094
    je .err_div_zero
    cmp edx, 0xC000008E
    je .err_div_zero

    # Other non-fatal exception -> continue search
    mov dword ptr [rip + in_crash_handler], 0
    xor eax, eax         # EXCEPTION_CONTINUE_SEARCH
    leave
    ret

.crash_handle_fatal:
    mov r14d, edx        # save ExceptionCode in r14d
    mov rax, [rcx + 8]   # rax = ContextRecord
    test rax, rax
    jz .crash_exit
    mov r12, [rax + 0xf8] # r12 = Rip
    mov r13, [rax + 0x78] # r13 = RAX

    # Determine source filename in rdx
    mov rdx, [rip + cli_source_file]
    test rdx, rdx
    jnz .have_src_name
    mov rdx, [rip + target_asm_file]
    test rdx, rdx
    jnz .have_src_name
    lea rdx, [rip + str_default_src]
.have_src_name:

    # If debug flag is set, also print the raw registers
    cmp dword ptr [rip + vm_debug], 0
    jz .skip_debug_dump
    push rdx
    mov r8,  [rax + 0xa8] # RSI
    mov r9,  [rax + 0xc8] # R10
    mov r10, [rax + 0xd0] # R11
    mov [rsp + 32], r10
    mov r10, [rax + 0xd8] # R12
    mov [rsp + 40], r10
    mov r10, [rax + 0xe0] # R13
    mov [rsp + 48], r10
    mov r10, [rax + 0x78] # RAX
    mov [rsp + 56], r10
    mov r10, [rax + 0x88] # RDX
    mov rdx, r12          # RIP
    lea rcx, [rip + str_crash_fmt]
    call printf
    pop rdx
.skip_debug_dump:

    # Branch by ExceptionCode (in r14d)
    cmp r14d, 0xC00000FD
    je .err_stack_overflow
    cmp r14d, 0xC000001D
    je .err_illegal_insn
    cmp r14d, 0xC0000094
    je .err_div_zero
    cmp r14d, 0xC000008E
    je .err_div_zero

    # Access Violation (0xC0000005)
    # Check if we were in compilation phase
    mov rax, [rip + cli_source_file]
    test rax, rax
    jz .err_runtime_access
    cmp qword ptr [rip + active_dynamic_buf], 0
    jnz .err_runtime_access

    # Compilation phase syntax error! Run preflight diagnostic
    mov rcx, [rip + cli_source_file]
    sub rsp, 32
    call scan_and_diagnose_preflight
    add rsp, 32
    test eax, eax
    jnz .crash_flush_exit
    jmp .err_runtime_access

.err_runtime_access:
    mov rcx, [rip + cli_source_file]
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + str_default_src]
2:
    mov rdx, r12          # RIP
    sub rsp, 32
    call report_runtime_access_violation
    add rsp, 32
    jmp .crash_flush_exit

.err_stack_overflow:
    mov rcx, [rip + cli_source_file]
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + str_default_src]
2:
    mov rdx, r12          # RIP
    sub rsp, 32
    call report_runtime_stack_overflow
    add rsp, 32
    jmp .crash_flush_exit

.err_illegal_insn:
    lea rcx, [rip + str_rust_illegal_err]
    mov r8, r12           # RIP
    call printf
    jmp .crash_flush_exit

.err_div_zero:
    mov rcx, [rip + cli_source_file]
    test rcx, rcx
    jnz 2f
    lea rcx, [rip + str_default_src]
2:
    sub rsp, 32
    call report_runtime_div_zero
    add rsp, 32
    jmp .crash_flush_exit

.crash_flush_exit:
    mov rcx, 0
    call fflush
    mov ecx, 1
    call exit

.crash_exit:
    mov ecx, 1
    call exit

.crash_direct_exit:
    mov ecx, 1
    call exit

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

    mov ecx, 1
    lea rdx, [rip + crash_handler]
    call AddVectoredExceptionHandler

    lea rcx, [rip + perf_freq]
    call QueryPerformanceFrequency
    call nexus_jit_init

    # Allocate VM Registers Array (rdi/rbx) -------- 8192 regs * 8 bytes (zeroed)
    mov rcx, 8192
    mov rdx, 8
    call calloc
    mov rdi, rax
    mov rbx, rdi
    mov [rip + vm_stack_base], rax
    
    # Allocate Bytecode Array -------- 32MB for complex programs
    mov rcx, 33554432
    call malloc
    mov r12, rax
    mov r13, rax
    mov [rip + vm_bytecode_base], rax
    mov dword ptr [rip + sock_nonblocking_mode], 1

    # Allocate Fast Bump Arena (512MB)
    mov rcx, 536870912
    call malloc
    mov [rip + arena_base], rax
    mov [rip + arena_bump], rax
    add rax, 536870912
    mov [rip + arena_limit], rax

    # Allocate Scoped Region Bump Arena (64MB)
    mov rcx, 67108864
    call malloc
    mov [rip + region_arena_base], rax
    mov [rip + region_arena_bump], rax
    add rax, 67108864
    mov [rip + region_arena_limit], rax
    mov qword ptr [rip + region_scope_depth], 0
    mov qword ptr [rip + global_generation], 1

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
    # Run ultra-fast preflight diagnostic scan if .nx source file is specified
    mov rcx, [rip + cli_source_file]
    test rcx, rcx
    jz .skip_preflight_diag
    sub rsp, 32
    call scan_and_diagnose_preflight
    add rsp, 32
    test eax, eax
    jz .skip_preflight_diag
    mov ecx, 1
    call exit
.skip_preflight_diag:

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
    lea rdx, [rip + read_bin_mode]
    call fopen
    cmp rax, 0
    jne .file_opened
    lea rcx, [rip + err_msg]
    mov rdx, [rip + target_asm_file]
    call printf
    jmp .end

.file_opened:
    mov r14, rax
    mov rcx, r14
    xor edx, edx
    mov r8d, 2                   # SEEK_END
    call fseek

    mov rcx, r14
    call ftell
    mov [rip + file_size_bytes], rax

    mov rcx, r14
    xor edx, edx
    xor r8d, r8d                 # SEEK_SET
    call fseek

    mov rcx, [rip + file_size_bytes]
    add rcx, 16
    call malloc
    mov [rip + asm_mem_buf], rax
    mov [rip + asm_mem_ptr], rax

    mov rcx, rax
    mov rdx, 1
    mov r8, [rip + file_size_bytes]
    mov r9, r14
    call fread

    mov rcx, [rip + asm_mem_buf]
    mov rdx, [rip + file_size_bytes]
    mov byte ptr [rcx + rdx], 0

    mov rcx, r14
    call fclose
    xor r14, r14
    jmp .read_loop

fscanf:
    mov r10, [rip + asm_mem_ptr]
.fst_ws:
    mov al, [r10]
    test al, al
    jz .fst_eof
    cmp al, ' '
    jbe .fst_skip_ws
    jmp .fst_read
.fst_skip_ws:
    inc r10
    jmp .fst_ws

.fst_read:
    mov r11, r8
.fst_copy:
    mov al, [r10]
    test al, al
    jz .fst_done
    cmp al, ' '
    jbe .fst_done
    mov [r11], al
    inc r11
    inc r10
    jmp .fst_copy

.fst_done:
    mov byte ptr [r11], 0
    mov [rip + asm_mem_ptr], r10
    mov eax, 1
    ret

.fst_eof:
    mov [rip + asm_mem_ptr], r10
    xor eax, eax
    ret

fgets:
    mov r10, [rip + asm_mem_ptr]
.fsl_loop:
    mov al, [r10]
    test al, al
    jz .fsl_done
    inc r10
    cmp al, '\n'
    jne .fsl_loop
.fsl_done:
    mov [rip + asm_mem_ptr], r10
    mov rax, rcx
    ret

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
    mov al, byte ptr [rax]
    cmp al, '#'
    je .comment_loop
    cmp al, 'L'
    je .check_LOAD
    cmp al, 'A'
    je .check_ADD
    cmp al, 'P'
    je .check_PRINT
    cmp al, 'J'
    je .check_JMP
    cmp al, 'S'
    je .check_SUB
    cmp al, 'C'
    je .check_CALL
    cmp al, 'R'
    je .check_RET
    cmp al, 'D'
    je .check_DIV
    cmp al, 'E'
    je .check_EQ
    cmp al, 'G'
    je .check_GT
    cmp al, 'M'
    je .check_MUL
    cmp al, 'N'
    je .check_NEQ
    cmp al, 'F'
    je .check_FOPEN
    cmp al, 'H'
    je .check_HALT
    cmp al, 'I'
    je .check_IOCP_INIT
    jmp .print_bad_token
    
.comment_loop:
    lea rcx, [rip + val_buf]
    mov edx, 1024
    mov r8, r14
    sub rsp, 32
    call fgets
    add rsp, 32
    jmp .read_loop
    
.check_LOAD:
    # check LOAD
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD]
    call strcmp
    cmp eax, 0
    jne .check_LT
    
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
    call strcmp
    cmp eax, 0
    jne .check_ALLOC
    
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
    call strcmp
    cmp eax, 0
    jne .check_PRINT_C
    
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
    call strcmp
    cmp eax, 0
    jne .print_bad_token
    
    lea rax, [rip + op_halt]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.read_reg_arg:
    sub rsp, 40
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    mov [r13], rax
    add r13, 8
    add rsp, 40
    ret

.check_REGION_ENTER:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_REGION_ENTER]
    call strcmp
    test eax, eax
    jne .check_REGION_LEAVE
    lea rax, [rip + op_region_enter]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_REGION_LEAVE:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_REGION_LEAVE]
    call strcmp
    test eax, eax
    jne .check_REGION_ALLOC
    lea rax, [rip + op_region_leave]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_REGION_ALLOC:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_REGION_ALLOC]
    call strcmp
    test eax, eax
    jne .check_GEN_CHECK
    lea rax, [rip + op_region_alloc]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_GEN_CHECK:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_GEN_CHECK]
    call strcmp
    test eax, eax
    jne .check_ENUM_TAG
    lea rax, [rip + op_gen_check]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_ENUM_TAG:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_ENUM_TAG]
    call strcmp
    test eax, eax
    jne .check_ENUM_GET_TAG
    lea rax, [rip + op_enum_tag]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_ENUM_GET_TAG:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_ENUM_GET_TAG]
    call strcmp
    test eax, eax
    jne .check_ENUM_GET_FIELD
    lea rax, [rip + op_enum_get_tag]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_ENUM_GET_FIELD:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_ENUM_GET_FIELD]
    call strcmp
    test eax, eax
    jne .print_bad_token
    lea rax, [rip + op_enum_get_field]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_LT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LT]
    call strcmp
    cmp eax, 0
    jne .check_LABEL
    
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
    call strcmp
    cmp eax, 0
    jne .check_EXEC_DYNAMIC
    
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
    call strcmp
    cmp eax, 0
    jne .check_LOAD_STR
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + reg_buf]
    call fscanf
    lea rcx, [rip + reg_buf]
    call atoi
    movsxd rax, eax
    cmp rax, 524280
    jae .read_loop
    lea r8, [rip + labels_array]
    mov [r8 + rax * 8], r13      # labels_array[id] = current r13
    jmp .read_loop

.check_JMP:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_JMP]
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
    call strcmp
    cmp eax, 0
    jne .check_JMP_O
    
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
    call strcmp
    cmp eax, 0
    jne .check_LOAD_PTR
    
    # Emit op_load_raw (stores pointer, NOT float)
    lea rax, [rip + op_load_raw]
    mov [r13], rax
    add r13, 8
    
    # Read the string argument and strdup it -------- store raw pointer with STRING header
    push rdi
    sub rsp, 40
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + val_buf]
    call fscanf
    lea rcx, [rip + val_buf]
    call strlen
    mov r15, rax
    lea rcx, [r15 + 49]
    call malloc
    mov qword ptr [rax], 0
    mov qword ptr [rax + 8], 0
    mov r10, 0x535452494E47
    mov [rax + 16], r10
    mov [rax + 24], r15
    cvtsi2sd xmm0, r15
    movsd [rax + 32], xmm0
    mov [rax + 40], r15
    add rax, 48
    mov [rsp + 32], rax
    mov rcx, rax
    lea rdx, [rip + val_buf]
    call strcpy
    mov rax, [rsp + 32]
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
    
    
    call strcmp
    cmp eax, 0
    jne .check_FOPEN_W
    
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

.check_FOPEN_W:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_FOPEN_W]
    call strcmp
    cmp eax, 0
    jne .check_FGETC
    
    lea rax, [rip + op_fopen_w]
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
    call strcmp
    cmp eax, 0
    jne .check_FREE
    
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
    call strcmp
    cmp eax, 0
    jne .check_PUTS
    
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
    call strcmp
    cmp eax, 0
    jne .check_STORE_PTR
    
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
    call strcmp
    cmp eax, 0
    jne .check_MOV
    
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
    call strcmp
    cmp eax, 0
    jne .check_DICT_NEW
    
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
    call strcmp
    cmp eax, 0
    jne .check_GET_OP
    
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
    call strcmp
    cmp eax, 0
    jne .check_NOT
    
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
    call strcmp
    cmp eax, 0
    jne .print_bad_token
    
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
    call strcmp
    cmp eax, 0
    jne .check_AND
    
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

.check_AND:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_AND]
    call strcmp
    cmp eax, 0
    jne .check_OR
    
    lea rax, [rip + op_and]
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

.check_OR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_OR]
    call strcmp
    cmp eax, 0
    jne .print_bad_token
    
    lea rax, [rip + op_or]
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

.check_STORE_PTR:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_STORE_PTR]
    call strcmp
    cmp eax, 0
    jne .check_STORE_B
    
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
    call strcmp
    cmp eax, 0
    jne .check_LOAD_B
    
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
    call strcmp
    cmp eax, 0
    jne .check_PUSH
    
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
    # val_buf now has the string -------- embed it directly into bytecode
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
    call strcmp
    cmp eax, 0
    jne .check_ASYNC_LISTEN
    
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

.check_ASYNC_LISTEN:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_ASYNC_LISTEN]
    call strcmp
    test eax, eax
    jne .check_ASYNC_ACCEPT
    lea rax, [rip + op_async_listen]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_ASYNC_ACCEPT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_ASYNC_ACCEPT]
    call strcmp
    test eax, eax
    jne .check_ASYNC_RECV
    lea rax, [rip + op_async_accept]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_ASYNC_RECV:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_ASYNC_RECV]
    call strcmp
    test eax, eax
    jne .check_ASYNC_SEND
    lea rax, [rip + op_async_recv]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_ASYNC_SEND:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_ASYNC_SEND]
    call strcmp
    test eax, eax
    jne .check_IOCP_INIT
    lea rax, [rip + op_async_send]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_IOCP_INIT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_IOCP_INIT]
    call strcmp
    test eax, eax
    jne .check_IOCP_POLL
    lea rax, [rip + op_iocp_init]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    jmp .read_loop

.check_IOCP_POLL:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_IOCP_POLL]
    call strcmp
    test eax, eax
    jne .print_bad_token
    lea rax, [rip + op_iocp_poll]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_DICT_NEW:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_DICT_NEW]
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
    call strcmp
    cmp eax, 0
    jne .check_DICT_COPY
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

.check_DICT_COPY:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_DICT_COPY]
    call strcmp
    cmp eax, 0
    jne .print_bad_token
    lea rax, [rip + op_dict_copy]
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
    call strcmp
    cmp eax, 0
    jne .check_FIBER_SPAWN
    
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

.check_FIBER_SPAWN:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_FIBER_SPAWN]
    call strcmp
    test eax, eax
    jne .check_FIBER_YIELD
    lea rax, [rip + op_fiber_spawn]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_FIBER_YIELD:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_FIBER_YIELD]
    call strcmp
    test eax, eax
    jne .check_FIBER_AWAIT
    lea rax, [rip + op_fiber_yield]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_FIBER_AWAIT:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_FIBER_AWAIT]
    call strcmp
    test eax, eax
    jne .print_bad_token
    lea rax, [rip + op_fiber_await]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_LOAD_B:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD_B]
    call strcmp
    cmp eax, 0
    jne .check_LOAD_F
    
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
    call strcmp
    cmp eax, 0
    jne .check_STORE_I
    
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
    call strcmp
    cmp eax, 0
    jne .check_ENUM_TAG
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
    call strcmp
    cmp eax, 0
    jne .print_bad_token
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
    call strcmp
    cmp eax, 0
    jne .check_STORE_F
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
    call strcmp
    cmp eax, 0
    jne .check_GEN_CHECK
    
    mov rcx, r14
    lea rdx, [rip + scan_fmt]
    lea r8, [rip + val_buf]
    call fscanf

    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_DICT_NEW]
    
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_ADD
    lea r15, [rip + op_dict_new]
    jmp .get_op_found

.check_GET_OP_ADD:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ADD]
    
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_DICT_GET
    lea r15, [rip + op_add]
    jmp .get_op_found

.check_GET_OP_DICT_GET:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_DICT_GET]
    
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_DICT_SET
    lea r15, [rip + op_dict_get]
    jmp .get_op_found

.check_GET_OP_DICT_SET:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_DICT_SET]
    
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_DICT_COPY
    lea r15, [rip + op_dict_set]
    jmp .get_op_found

.check_GET_OP_DICT_COPY:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_DICT_COPY]
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_JMP_F_O
    lea r15, [rip + op_dict_copy]
    jmp .get_op_found

.check_GET_OP_JMP_F_O:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_JMP_F_O]
    
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_JMP_O
    lea r15, [rip + op_jmp_f_o]
    jmp .get_op_found

.check_GET_OP_JMP_O:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_JMP_O]
    
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_LOAD
    lea r15, [rip + op_jmp_o]
    jmp .get_op_found

.check_GET_OP_LOAD:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_LOAD]
    
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_LOAD_RAW
    lea r15, [rip + op_load_const]
    jmp .get_op_found

.check_GET_OP_LOAD_RAW:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_LOAD_RAW]
    
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_POP
    lea r15, [rip + op_load_raw]
    jmp .get_op_found

.check_GET_OP_POP:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_POP]
    
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_PRINT
    lea r15, [rip + op_pop]
    jmp .get_op_found

.check_GET_OP_PRINT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_PRINT]
    
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_PUSH
    lea r15, [rip + op_print]
    jmp .get_op_found

.check_GET_OP_PUSH:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_PUSH]
    
    
    call strcmp
    cmp eax, 0
    jne .check_GET_OP_RET
    lea r15, [rip + op_push]
    jmp .get_op_found

.check_GET_OP_RET:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_RET]
    
    
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
    jne .check_GET_OP_MOD
    lea r15, [rip + op_exit]
    jmp .get_op_found

.check_GET_OP_MOD:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_MOD]
    call strcmp
    test eax, eax
    jne .check_GET_OP_FLOOR
    lea r15, [rip + op_mod]
    jmp .get_op_found

.check_GET_OP_FLOOR:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_FLOOR]
    call strcmp
    test eax, eax
    jne .check_GET_OP_CEIL
    lea r15, [rip + op_floor]
    jmp .get_op_found

.check_GET_OP_CEIL:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_CEIL]
    call strcmp
    test eax, eax
    jne .check_GET_OP_STR_LEN
    lea r15, [rip + op_ceil]
    jmp .get_op_found

.check_GET_OP_STR_LEN:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_STR_LEN]
    call strcmp
    test eax, eax
    jne .check_GET_OP_TO_STR
    lea r15, [rip + op_str_len]
    jmp .get_op_found

.check_GET_OP_TO_STR:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_TO_STR]
    call strcmp
    test eax, eax
    jne .check_GET_OP_AND
    lea r15, [rip + op_to_str]
    jmp .get_op_found

.check_GET_OP_AND:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_AND]
    call strcmp
    test eax, eax
    jne .check_GET_OP_OR
    lea r15, [rip + op_and]
    jmp .get_op_found

.check_GET_OP_OR:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_OR]
    call strcmp
    test eax, eax
    jne .check_GET_OP_NOT
    lea r15, [rip + op_or]
    jmp .get_op_found

.check_GET_OP_NOT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_NOT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_SET_LEN
    lea r15, [rip + op_not]
    jmp .get_op_found

.check_GET_OP_SET_LEN:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_SET_LEN]
    call strcmp
    test eax, eax
    jne .check_GET_OP_ARRAY_PUSH
    lea r15, [rip + op_set_len]
    jmp .get_op_found

.check_GET_OP_ARRAY_PUSH:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ARRAY_PUSH]
    call strcmp
    test eax, eax
    jne .check_GET_OP_ARRAY_POP
    lea r15, [rip + op_array_push]
    jmp .get_op_found

.check_GET_OP_ARRAY_POP:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ARRAY_POP]
    call strcmp
    test eax, eax
    jne .check_GET_OP_STR_SUB
    lea r15, [rip + op_array_pop]
    jmp .get_op_found

.check_GET_OP_STR_SUB:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_STR_SUB]
    call strcmp
    test eax, eax
    jne .check_GET_OP_FOPEN
    lea r15, [rip + op_str_sub]
    jmp .get_op_found

.check_GET_OP_FOPEN:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_FOPEN]
    call strcmp
    test eax, eax
    jne .check_GET_OP_FOPEN_W
    lea r15, [rip + op_fopen]
    jmp .get_op_found

.check_GET_OP_FOPEN_W:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_FOPEN_W]
    call strcmp
    test eax, eax
    jne .check_GET_OP_FCLOSE
    lea r15, [rip + op_fopen_w]
    jmp .get_op_found

.check_GET_OP_FCLOSE:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_FCLOSE]
    call strcmp
    test eax, eax
    jne .check_GET_OP_FREAD
    lea r15, [rip + op_fclose]
    jmp .get_op_found

.check_GET_OP_FREAD:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_FREAD]
    call strcmp
    test eax, eax
    jne .check_GET_OP_FWRITE
    lea r15, [rip + op_fread]
    jmp .get_op_found

.check_GET_OP_FWRITE:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_FWRITE]
    call strcmp
    test eax, eax
    jne .check_GET_OP_FILE_READ_TEXT
    lea r15, [rip + op_fwrite]
    jmp .get_op_found

.check_GET_OP_FILE_READ_TEXT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_FILE_READ_TEXT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_FILE_WRITE_TEXT
    lea r15, [rip + op_file_read_text]
    jmp .get_op_found

.check_GET_OP_FILE_WRITE_TEXT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_FILE_WRITE_TEXT]
    call strcmp
    jne .check_GET_OP_ARRAY_SLICE
    lea r15, [rip + op_file_write_text]
    jmp .get_op_found

.check_GET_OP_ARRAY_SLICE:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ARRAY_SLICE]
    call strcmp
    test eax, eax
    jne .check_GET_OP_STR_CONTAINS
    lea r15, [rip + op_array_slice]
    jmp .get_op_found

.check_GET_OP_STR_CONTAINS:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_STR_CONTAINS]
    call strcmp
    test eax, eax
    jne .check_GET_OP_STR_INDEX_OF
    lea r15, [rip + op_str_contains]
    jmp .get_op_found

.check_GET_OP_STR_INDEX_OF:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_STR_INDEX_OF]
    call strcmp
    test eax, eax
    jne .check_GET_OP_STR_SPLIT
    lea r15, [rip + op_str_index_of]
    jmp .get_op_found

.check_GET_OP_STR_SPLIT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_STR_SPLIT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_STR_TO_UPPER
    lea r15, [rip + op_str_split]
    jmp .get_op_found

.check_GET_OP_STR_TO_UPPER:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_STR_TO_UPPER]
    call strcmp
    test eax, eax
    jne .check_GET_OP_STR_TO_LOWER
    lea r15, [rip + op_str_to_upper]
    jmp .get_op_found

.check_GET_OP_STR_TO_LOWER:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_STR_TO_LOWER]
    call strcmp
    test eax, eax
    jne .check_GET_OP_DICT_HAS_KEY
    lea r15, [rip + op_str_to_lower]
    jmp .get_op_found

.check_GET_OP_DICT_HAS_KEY:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_DICT_HAS_KEY]
    call strcmp
    test eax, eax
    jne .check_GET_OP_DICT_KEYS
    lea r15, [rip + op_dict_has_key]
    jmp .get_op_found

.check_GET_OP_DICT_KEYS:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_DICT_KEYS]
    call strcmp
    test eax, eax
    jne .check_GET_OP_DICT_VALUES
    lea r15, [rip + op_dict_keys]
    jmp .get_op_found

.check_GET_OP_DICT_VALUES:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_DICT_VALUES]
    call strcmp
    test eax, eax
    jne .check_GET_OP_PUSH_TRY
    lea r15, [rip + op_dict_values]
    jmp .get_op_found

.check_GET_OP_PUSH_TRY:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_PUSH_TRY]
    call strcmp
    test eax, eax
    jne .check_GET_OP_POP_TRY
    lea r15, [rip + op_push_try]
    jmp .get_op_found

.check_GET_OP_POP_TRY:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_POP_TRY]
    call strcmp
    test eax, eax
    jne .check_GET_OP_THROW
    lea r15, [rip + op_pop_try]
    jmp .get_op_found

.check_GET_OP_THROW:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_THROW]
    call strcmp
    test eax, eax
    jne .check_GET_OP_PUSH_DEFER
    lea r15, [rip + op_throw]
    jmp .get_op_found

.check_GET_OP_PUSH_DEFER:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_PUSH_DEFER]
    call strcmp
    test eax, eax
    jne .check_GET_OP_POP_RUN_DEFERS
    lea r15, [rip + op_push_defer]
    jmp .get_op_found

.check_GET_OP_POP_RUN_DEFERS:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_POP_RUN_DEFERS]
    call strcmp
    test eax, eax
    jne .check_GET_OP_SHA256
    lea r15, [rip + op_pop_run_defers]
    jmp .get_op_found

.check_GET_OP_SHA256:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_SHA256]
    call strcmp
    test eax, eax
    jne .check_GET_OP_MD5
    lea r15, [rip + op_crypto_sha256]
    jmp .get_op_found

.check_GET_OP_MD5:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_MD5]
    call strcmp
    test eax, eax
    jne .check_GET_OP_BASE64_ENCODE
    lea r15, [rip + op_crypto_md5]
    jmp .get_op_found

.check_GET_OP_BASE64_ENCODE:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_BASE64_ENCODE]
    call strcmp
    test eax, eax
    jne .check_GET_OP_BASE64_DECODE
    lea r15, [rip + op_crypto_b64_encode]
    jmp .get_op_found

.check_GET_OP_BASE64_DECODE:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_BASE64_DECODE]
    call strcmp
    test eax, eax
    jne .check_GET_OP_HEX_ENCODE
    lea r15, [rip + op_crypto_b64_decode]
    jmp .get_op_found

.check_GET_OP_HEX_ENCODE:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_HEX_ENCODE]
    call strcmp
    test eax, eax
    jne .check_GET_OP_HEX_DECODE
    lea r15, [rip + op_crypto_hex_encode]
    jmp .get_op_found

.check_GET_OP_HEX_DECODE:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_HEX_DECODE]
    call strcmp
    test eax, eax
    jne .check_GET_OP_XOR_MASK
    lea r15, [rip + op_crypto_hex_decode]
    jmp .get_op_found

.check_GET_OP_XOR_MASK:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_XOR_MASK]
    call strcmp
    test eax, eax
    jne .check_GET_OP_SYS_ARGS
    lea r15, [rip + op_crypto_xor_mask]
    jmp .get_op_found

.check_GET_OP_SYS_ARGS:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_SYS_ARGS]
    call strcmp
    test eax, eax
    jne .check_GET_OP_SYS_TIME_MS
    lea r15, [rip + op_sys_args]
    jmp .get_op_found

.check_GET_OP_SYS_TIME_MS:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_SYS_TIME_MS]
    call strcmp
    test eax, eax
    jne .check_GET_OP_SYS_GET_ENV
    lea r15, [rip + op_sys_time_ms]
    jmp .get_op_found

.check_GET_OP_SYS_GET_ENV:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_SYS_GET_ENV]
    call strcmp
    test eax, eax
    jne .check_GET_OP_SYS_SET_ENV
    lea r15, [rip + op_sys_get_env]
    jmp .get_op_found

.check_GET_OP_SYS_SET_ENV:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_SYS_SET_ENV]
    call strcmp
    test eax, eax
    jne .check_GET_OP_SYS_EXEC
    lea r15, [rip + op_sys_set_env]
    jmp .get_op_found

.check_GET_OP_SYS_EXEC:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_SYS_EXEC]
    call strcmp
    test eax, eax
    jne .check_GET_OP_SYS_GC
    lea r15, [rip + op_sys_exec]
    jmp .get_op_found

.check_GET_OP_SYS_GC:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_SYS_GC]
    call strcmp
    test eax, eax
    jne .check_GET_OP_AES_ENCRYPT
    lea r15, [rip + op_sys_gc]
    jmp .get_op_found

.check_GET_OP_AES_ENCRYPT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_AES_ENCRYPT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_AES_DECRYPT
    lea r15, [rip + op_crypto_aes_encrypt]
    jmp .get_op_found

.check_GET_OP_AES_DECRYPT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_AES_DECRYPT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_HMAC_SHA256
    lea r15, [rip + op_crypto_aes_decrypt]
    jmp .get_op_found

.check_GET_OP_HMAC_SHA256:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_HMAC_SHA256]
    call strcmp
    test eax, eax
    jne .check_GET_OP_RANDOM_BYTES
    lea r15, [rip + op_crypto_hmac_sha256]
    jmp .get_op_found

.check_GET_OP_RANDOM_BYTES:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_RANDOM_BYTES]
    call strcmp
    test eax, eax
    jne .check_GET_OP_TCP_CONNECT
    lea r15, [rip + op_crypto_random_bytes]
    jmp .get_op_found

.check_GET_OP_TCP_CONNECT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_TCP_CONNECT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_TCP_SEND
    lea r15, [rip + op_net_tcp_connect]
    jmp .get_op_found

.check_GET_OP_TCP_SEND:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_TCP_SEND]
    call strcmp
    test eax, eax
    jne .check_GET_OP_TCP_RECV
    lea r15, [rip + op_net_tcp_send]
    jmp .get_op_found

.check_GET_OP_TCP_RECV:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_TCP_RECV]
    call strcmp
    test eax, eax
    jne .check_GET_OP_TCP_CLOSE
    lea r15, [rip + op_net_tcp_recv]
    jmp .get_op_found

.check_GET_OP_TCP_CLOSE:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_TCP_CLOSE]
    call strcmp
    test eax, eax
    jne .check_GET_OP_TCP_LISTEN
    lea r15, [rip + op_net_tcp_close]
    jmp .get_op_found

.check_GET_OP_TCP_LISTEN:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_TCP_LISTEN]
    call strcmp
    test eax, eax
    jne .check_GET_OP_TCP_ACCEPT
    lea r15, [rip + op_net_tcp_listen]
    jmp .get_op_found

.check_GET_OP_TCP_ACCEPT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_TCP_ACCEPT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_HTTP_GET
    lea r15, [rip + op_net_tcp_accept]
    jmp .get_op_found

.check_GET_OP_HTTP_GET:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_HTTP_GET]
    call strcmp
    test eax, eax
    jne .check_GET_OP_INDEX_GET
    lea r15, [rip + op_net_http_get]
    jmp .get_op_found

.check_GET_OP_INDEX_GET:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_INDEX_GET]
    call strcmp
    test eax, eax
    jne .check_GET_OP_INDEX_SET
    lea r15, [rip + op_index_get]
    jmp .get_op_found

.check_GET_OP_INDEX_SET:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_INDEX_SET]
    call strcmp
    test eax, eax
    jne .check_GET_OP_GPU_DISPATCH
    lea r15, [rip + op_index_set]
    jmp .get_op_found

.check_GET_OP_GPU_DISPATCH:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_GPU_DISPATCH]
    call strcmp
    test eax, eax
    jne .check_GET_OP_MOV
    lea r15, [rip + op_gpu_dispatch]
    jmp .get_op_found

.check_GET_OP_MOV:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_MOV]
    call strcmp
    test eax, eax
    jne .check_GET_OP_HALT
    lea r15, [rip + op_mov]
    jmp .get_op_found

.check_GET_OP_HALT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_HALT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_ENUM_TAG
    lea r15, [rip + op_halt]
    jmp .get_op_found

.check_GET_OP_ENUM_TAG:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ENUM_TAG]
    call strcmp
    test eax, eax
    jne .check_GET_OP_ENUM_GET_TAG
    lea r15, [rip + op_enum_tag]
    jmp .get_op_found

.check_GET_OP_ENUM_GET_TAG:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ENUM_GET_TAG]
    call strcmp
    test eax, eax
    jne .check_GET_OP_ENUM_GET_FIELD
    lea r15, [rip + op_enum_get_tag]
    jmp .get_op_found

.check_GET_OP_ENUM_GET_FIELD:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ENUM_GET_FIELD]
    call strcmp
    test eax, eax
    jne .check_GET_OP_REGION_ENTER
    lea r15, [rip + op_enum_get_field]
    jmp .get_op_found

.check_GET_OP_REGION_ENTER:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_REGION_ENTER]
    call strcmp
    test eax, eax
    jne .check_GET_OP_REGION_LEAVE
    lea r15, [rip + op_region_enter]
    jmp .get_op_found

.check_GET_OP_REGION_LEAVE:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_REGION_LEAVE]
    call strcmp
    test eax, eax
    jne .check_GET_OP_GEN_CHECK
    lea r15, [rip + op_region_leave]
    jmp .get_op_found

.check_GET_OP_GEN_CHECK:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_GEN_CHECK]
    call strcmp
    test eax, eax
    jne .check_GET_OP_REGION_ALLOC
    lea r15, [rip + op_gen_check]
    jmp .get_op_found

.check_GET_OP_REGION_ALLOC:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_REGION_ALLOC]
    call strcmp
    test eax, eax
    jne .check_GET_OP_FIBER_SPAWN
    lea r15, [rip + op_region_alloc]
    jmp .get_op_found

.check_GET_OP_FIBER_SPAWN:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_FIBER_SPAWN]
    call strcmp
    test eax, eax
    jne .check_GET_OP_FIBER_YIELD
    lea r15, [rip + op_fiber_spawn]
    jmp .get_op_found

.check_GET_OP_FIBER_YIELD:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_FIBER_YIELD]
    call strcmp
    test eax, eax
    jne .check_GET_OP_FIBER_AWAIT
    lea r15, [rip + op_fiber_yield]
    jmp .get_op_found

.check_GET_OP_FIBER_AWAIT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_FIBER_AWAIT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_CHAN_NEW
    lea r15, [rip + op_fiber_await]
    jmp .get_op_found

.check_GET_OP_CHAN_NEW:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_CHAN_NEW]
    call strcmp
    test eax, eax
    jne .check_GET_OP_CHAN_SEND
    lea r15, [rip + op_chan_new]
    jmp .get_op_found

.check_GET_OP_CHAN_SEND:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_CHAN_SEND]
    call strcmp
    test eax, eax
    jne .check_GET_OP_CHAN_RECV
    lea r15, [rip + op_chan_send]
    jmp .get_op_found

.check_GET_OP_CHAN_RECV:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_CHAN_RECV]
    call strcmp
    test eax, eax
    jne .check_GET_OP_CHAN_LEN
    lea r15, [rip + op_chan_recv]
    jmp .get_op_found

.check_GET_OP_CHAN_LEN:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_CHAN_LEN]
    call strcmp
    test eax, eax
    jne .check_GET_OP_CHAN_CLOSE
    lea r15, [rip + op_chan_len]
    jmp .get_op_found

.check_GET_OP_CHAN_CLOSE:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_CHAN_CLOSE]
    call strcmp
    test eax, eax
    jne .check_GET_OP_IOCP_INIT
    lea r15, [rip + op_chan_close]
    jmp .get_op_found

.check_GET_OP_IOCP_INIT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_IOCP_INIT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_IOCP_POLL
    lea r15, [rip + op_iocp_init]
    jmp .get_op_found

.check_GET_OP_IOCP_POLL:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_IOCP_POLL]
    call strcmp
    test eax, eax
    jne .check_GET_OP_ASYNC_LISTEN
    lea r15, [rip + op_iocp_poll]
    jmp .get_op_found

.check_GET_OP_ASYNC_LISTEN:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ASYNC_LISTEN]
    call strcmp
    test eax, eax
    jne .check_GET_OP_ASYNC_ACCEPT
    lea r15, [rip + op_async_listen]
    jmp .get_op_found

.check_GET_OP_ASYNC_ACCEPT:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ASYNC_ACCEPT]
    call strcmp
    test eax, eax
    jne .check_GET_OP_ASYNC_RECV
    lea r15, [rip + op_async_accept]
    jmp .get_op_found

.check_GET_OP_ASYNC_RECV:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ASYNC_RECV]
    call strcmp
    test eax, eax
    jne .check_GET_OP_ASYNC_SEND
    lea r15, [rip + op_async_recv]
    jmp .get_op_found

.check_GET_OP_ASYNC_SEND:
    lea rcx, [rip + val_buf]
    lea rdx, [rip + str_ASYNC_SEND]
    call strcmp
    test eax, eax
    jne .check_GET_OP_NOT_FOUND
    lea r15, [rip + op_async_send]
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
    call strcmp
    cmp eax, 0
    jne .check_CHAN_NEW
    
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

.check_CHAN_NEW:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_CHAN_NEW]
    call strcmp
    test eax, eax
    jne .check_CHAN_SEND
    lea rax, [rip + op_chan_new]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_CHAN_SEND:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_CHAN_SEND]
    call strcmp
    test eax, eax
    jne .check_CHAN_RECV
    lea rax, [rip + op_chan_send]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_CHAN_RECV:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_CHAN_RECV]
    call strcmp
    test eax, eax
    jne .check_CHAN_LEN
    lea rax, [rip + op_chan_recv]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_CHAN_LEN:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_CHAN_LEN]
    call strcmp
    test eax, eax
    jne .check_CHAN_CLOSE
    lea rax, [rip + op_chan_len]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    call .read_reg_arg
    jmp .read_loop

.check_CHAN_CLOSE:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_CHAN_CLOSE]
    call strcmp
    test eax, eax
    jne .print_bad_token
    lea rax, [rip + op_chan_close]
    mov [r13], rax
    add r13, 8
    call .read_reg_arg
    jmp .read_loop

.check_RET:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_RET]
    call strcmp
    cmp eax, 0
    jne .check_REGION_ENTER
    
    lea rax, [rip + op_ret]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.check_PUSH:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_PUSH]
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
    call strcmp
    cmp eax, 0
    jne .check_PUSH_PTR
    
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
    call strcmp
    cmp eax, 0
    jne .check_LOAD_PTR_O
    
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
    call strcmp
    cmp eax, 0
    jne .check_STORE_PTR_O
    jmp .store_f_match

.check_LOAD_PTR_O:
    lea rcx, [rip + token_buf]
    lea rdx, [rip + str_LOAD_PTR_O]
    call strcmp
    cmp eax, 0
    jne .print_bad_token
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
    call strcmp
    cmp eax, 0
    jne .print_bad_token
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
    
    
    call strcmp
    cmp eax, 0
    jne .print_bad_token
    lea rax, [rip + op_panic]
    mov [r13], rax
    add r13, 8
    jmp .read_loop

.print_bad_token:
    sub rsp, 48
    lea rcx, [rip + bad_token_fmt]
    lea rdx, [rip + token_buf]
    call printf
    mov rcx, 0
    call fflush

    lea rcx, [rip + str_bad_tok_hex]
    movzx rdx, byte ptr [rip + token_buf]
    movzx r8,  byte ptr [rip + token_buf + 1]
    movzx r9,  byte ptr [rip + token_buf + 2]
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
    test r14, r14
    jz 2f
    mov rcx, r14
    call fclose
2:
    
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
    lea rcx, [rip + fmt_words]
    # rdx already has rcx
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

.include "src/vm/nexus_diag.s"

.include "src/vm/nexus_jit.s"
