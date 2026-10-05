# Nexus Baremetal VM — Architecture Reference
**Status**: Self-Hosting Stage 3 — Full Lexer running in .nxasm

## Register Banks
| Bank | x64 Register | Purpose | Slots |
|------|-------------|---------|-------|
| Float | `rdi` | Doubles for arithmetic, chars (as ASCII doubles), booleans (0.0/1.0) | 0–255 |
| Pointer | `rbx` | Raw 64-bit pointers: `char*`, `FILE*`, `malloc` ptrs | 0–255 |

> **Rule**: Same register NUMBER refers to different banks depending on the opcode.
> `FGETC 3 0` → dest=float bank[3], file=pointer bank[0]
> `STORE_B 6 7 1` → ptr=pointer bank[6], offset=float bank[7], val=float bank[1]

## Opcode Table

| Opcode | Syntax | Banks | Notes |
|--------|--------|-------|-------|
| LOAD | `LOAD <float> <dest>` | dest→float | Load constant double |
| LOAD_STR | `LOAD_STR <word> <dest>` | dest→ptr | strdup's the string token |
| ALLOC | `ALLOC <dest> <size_reg>` | dest→ptr, size←float | malloc(size) |
| FREE | `FREE <ptr_reg>` | ptr←ptr | free(ptr) |
| FOPEN | `FOPEN <dest> <path_reg>` | dest→ptr, path←ptr | fopen(path,"r") |
| FGETC | `FGETC <dest> <file_reg>` | dest→float, file←ptr | returns char as double |
| LOAD_B | `LOAD_B <dest> <ptr> <off>` | dest→float, ptr←ptr, off←float | byte at ptr+off |
| STORE_B | `STORE_B <ptr> <off> <val>` | ptr←ptr, off←float, val←float | write byte |
| PRINT_STR | `PRINT_STR <ptr_reg>` | ptr←ptr | printf("%s\n", ptr) |
| PRINT_C | `PRINT_C <char_reg>` | char←float | printf("%c", char) |
| PRINT | `PRINT <float_reg>` | ←float | printf("%f\n", val) |
| PUTS | `PUTS <word>` | inline | embed literal string into bytecode |
| ADD | `ADD <d> <a> <b>` | all float | d=a+b |
| SUB | `SUB <d> <a> <b>` | all float | d=a-b |
| MUL | `MUL <d> <a> <b>` | all float | d=a*b |
| DIV | `DIV <d> <a> <b>` | all float | d=a/b |
| LT | `LT <d> <a> <b>` | all float | d=(a<b)?1:0 |
| GT | `GT <d> <a> <b>` | all float | d=(a>b)?1:0 |
| EQ | `EQ <d> <a> <b>` | all float | d=(a==b)?1:0 |
| NEQ | `NEQ <d> <a> <b>` | all float | d=(a!=b)?1:0 |
| NOT | `NOT <d> <a>` | all float | d=(a==0)?1:0 |
| MOV | `MOV <d> <s>` | all float | d=s (raw bits) |
| CALL | `CALL <label_id>` | call_stack | push return address (rsi), jump to label |
| RET | `RET` | call_stack | pop return address to rsi, continue |
| PUSH | `PUSH <reg>` | val_stack | push float register to 64-bit value stack |
| POP | `POP <reg>` | val_stack | pop value stack into float register |
| JMP | `JMP <label_id>` | — | jump to label |
| JMP_F | `JMP_F <cond> <label>` | cond←float | jump if cond==0.0 |
| LABEL | `LABEL <id>` | — | define jump target |
| HALT | `HALT` | — | stop VM |

## Bootstrap Stages
```
Stage 0: Hardware VM in nexus_core.s (Assembly only) [COMPLETED]
Stage 1: .nxasm text parsed + executed by VM [COMPLETED]
Stage 2: Control flow (JMP/LABEL/EQ/LT) → Turing complete [COMPLETED]
Stage 3: File I/O + Heap Memory → String processing capable [COMPLETED]
Stage 4: Full Lexer in nexus_lexer.nxasm [COMPLETED & VERIFIED]
Stage 5: [IN PROGRESS] Parser in .nxasm → AST nodes in heap memory
Stage 6: Code Gen in .nxasm → emits new .nxasm
Stage 7: Nexus compiles itself (full self-host)
```

## Lexer Output Tokens
```
TOK_LET  TOK_MUT  TOK_FN  TOK_CLASS  TOK_IMPORT  TOK_FROM
TOK_IF   TOK_ELSE  TOK_WHILE  TOK_RETURN
IDENT:   NUMBER:  STRING:
TOK_PLUS  TOK_MINUS  TOK_STAR  TOK_SLASH
TOK_EQ  TOK_EQEQ  TOK_LT  TOK_LTEQ  TOK_GT  TOK_GTEQ
TOK_LBRACE  TOK_RBRACE  TOK_LPAREN  TOK_RPAREN
TOK_COMMA  TOK_DOT  TOK_EOF
```

## Files
| File | Purpose |
|------|---------|
| `nexus_core.s` | Pure x86-64 ASM — VM + Text Parser |
| `nexus_lexer.nxasm` | Complete Nexus Lexer written in .nxasm |
| `lexer_test.nx` | Test Nexus source file for the lexer |
| `boot.nxasm` | Entry point (copy nexus_lexer.nxasm here to run) |
| `build.ps1` | Compiles nexus_core.s with gcc |
