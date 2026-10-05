# Nexus Baremetal Status Report

## 1. Bugs Fixed & Integrated
- **Wrong Entrypoint Fix**: The lexer's EOF handler was executing `JMP 800` (which crashed by dropping into a dead parsing loop from an old iteration). Fixed to `JMP 5000` to properly initialize the compiler main.
- **Semicolon Corruption Bug**: `LET_STMT` and `PRINT_STMT` were not consuming trailing semicolons (`;`). The leftover semicolons caused the compiler to mistakenly parse them as empty `EXPR_STMT`s, corrupting the AST pointer stack. I patched `parser_stmt.nxasm` to correctly consume them.
- **Latent GC Corruption Bug**: `gc_malloc` in `nexus_core.s` was allocating `size + 32` bytes but returning the pointer offset at `+24`. This meant the application payload was overwriting the GC's internal `next` pointer linked list! Fixed to `add rax, 32`.
- **AST Register Collision Bug (CRITICAL)**: `CALL 5200` and `CALL 5100` do not preserve caller-saved registers. `NUMBER_EXPR` was clobbering register `202` by writing its literal float value into it (e.g., `100.0`). But `DICT_EXPR` was using `202` to store the loop bound (pair count = `1.0`). Since `202` was overwritten with `100.0`, the loop erroneously iterated 100 times instead of 1, read unallocated AST memory, got a `NULL` pointer, and crashed on `op_load_f`. I fixed this by re-assigning registers in `NUMBER_EXPR` and adding `PUSH` / `POP` blocks around recursive calls in `DICT_EXPR` and `BLOCK_STMT`.

## 2. GitHub Initialization
- Initialized an empty Git repository.
- Added and committed **only** the assembly files (`*.s`, `*.nxasm`, `*.nx`) as explicitly requested (`git add *.s *.nxasm *.nx`).
- The repository has two clean commits with all the above fixes.

## 3. Current State
- The VM perfectly parses, compiles, and dynamically executes `test_dict.nx` to output exactly `100.000000`, leveraging the full pipeline (String Interning, Dictionary Operations, GC Malloc, etc).
- I've fully stopped using python/patch scripts and stuck exclusively to native file editors.

## 4. Next Steps
- We have solid implementations of block statements, variables, strings, dicts, math, etc.
- The `test_math.nx` file currently uses `fn` (functions). **Our compiler currently does not support compiling functions (`FN_STMT`) yet**, though the parser does parse them.
- I will need you to provide the **GitHub Remote URL** (e.g., `https://github.com/your-username/repo.git`) so I can push the commits, or you can push them manually.
