# Nexus AST & Token Stream Design

## Token Stream Representation
The lexer outputs a contiguous array of tokens in heap memory.
Each token is 32 bytes long, aligned to 8-byte boundaries.

| Offset | Field        | Type            | Description                                      |
|--------|--------------|-----------------|--------------------------------------------------|
| 0      | `type`       | Float (`rdi`)   | Token type code (e.g., 1=LET, 11=IDENT, etc.)    |
| 8      | `string_ptr` | Pointer (`rbx`) | Raw 64-bit pointer to the string/name, or 0      |
| 16     | `value`      | Float (`rdi`)   | Numeric value (if TOK_NUMBER), else 0.0          |
| 24     | `line_num`   | Float (`rdi`)   | Line number for error reporting                  |

Token Types:
- Keywords: `TOK_LET` (1), `TOK_MUT` (2), `TOK_FN` (3), `TOK_IF` (4), `TOK_ELSE` (5), `TOK_WHILE` (6), `TOK_RETURN` (7)
- Identifiers & Literals: `TOK_IDENT` (11), `TOK_NUMBER` (12), `TOK_STRING` (13)
- Operators: `TOK_PLUS` (20), `TOK_MINUS` (21), `TOK_STAR` (22), `TOK_SLASH` (23)
- Punctuation: `TOK_EQ` (30), `TOK_LBRACE` (40), etc.

## AST Node Memory Layout
Nodes are allocated on the heap using the `ALLOC` instruction. The pointer to the node is returned in the pointer bank. Each node begins with a Node Type Float at offset 0.

### Node Types
**Statements:**
1. `LET_STMT` (Type = 101.0)
2. `FN_STMT` (Type = 102.0)
3. `IF_STMT` (Type = 103.0)
4. `WHILE_STMT` (Type = 104.0)
5. `RETURN_STMT` (Type = 105.0)
6. `EXPR_STMT` (Type = 106.0)
7. `BLOCK_STMT` (Type = 107.0)

**Expressions:**
11. `BINARY_EXPR` (Type = 201.0)
12. `NUMBER_EXPR` (Type = 202.0)
13. `STRING_EXPR` (Type = 203.0)
14. `IDENT_EXPR` (Type = 204.0)
15. `CALL_EXPR` (Type = 205.0)

### Layout Specifications

**1. LET_STMT (32 bytes)**
- `0`: Node Type (101.0) (Float)
- `8`: Name (Pointer)
- `16`: Type annotation (Pointer) - 0 if omitted
- `24`: Initializer Expression (Pointer to AST Node)

**2. FN_STMT (40 bytes)**
- `0`: Node Type (102.0) (Float)
- `8`: Name (Pointer)
- `16`: Param Count (Float)
- `24`: Params Array (Pointer to array of Name pointers)
- `32`: Body Block (Pointer to BLOCK_STMT)

**3. IF_STMT (32 bytes)**
- `0`: Node Type (103.0) (Float)
- `8`: Condition Expression (Pointer)
- `16`: Then Block (Pointer)
- `24`: Else Block (Pointer) - 0 if no else

**4. WHILE_STMT (24 bytes)**
- `0`: Node Type (104.0) (Float)
- `8`: Condition Expression (Pointer)
- `16`: Body Block (Pointer)

**5. RETURN_STMT (16 bytes)**
- `0`: Node Type (105.0) (Float)
- `8`: Return Expression (Pointer) - 0 if void

**6. EXPR_STMT (16 bytes)**
- `0`: Node Type (106.0) (Float)
- `8`: Expression (Pointer)

**7. NUMBER_EXPR (16 bytes)**
- `0`: Node Type (202.0) (Float)
- `8`: Value (Float)

**8. IDENT_EXPR (16 bytes)**
- `0`: Node Type (204.0) (Float)
- `8`: Name (Pointer)

**9. BINARY_EXPR (32 bytes)**
- `0`: Node Type (201.0) (Float)
- `8`: Operator Token Type (Float)
- `16`: Left Expression (Pointer)
- `24`: Right Expression (Pointer)

## Parsing Algorithm (Recursive Descent)
The parser logic in `.nxasm` will maintain:
- `rdi[100]` : Current token index (Float)
- `rdi[101]` : Total tokens count (Float)
- `rbx[10]` : Pointer to the start of the token array

The parser provides subroutines (implemented via `JMP` and `LABEL` with manual return addresses stored in a simulated call stack or designated registers):
- `parse_statement`
- `parse_expression`
- `advance_token`
- `match_token`

Memory instructions like `LOAD_B` (for bytes) and custom memory ops (if we need to read 8-byte floats/ptrs we might need to rely on the VM, but looking at `ARCHITECTURE.md`, `LOAD_B` and `STORE_B` are byte-level. Wait, we have `LOAD_PTR`, `STORE_PTR`, and `LOAD`, `STORE` logic if available, wait, `ARCHITECTURE.md` says `STORE_B` is for bytes, but there's no `STORE_F`? Let's check `nexus_core.s`: it has `op_store_ptr` and `op_load_ptr`, which deal with 64-bit pointers. It doesn't seem to have a float store to arbitrary memory! Ah, `LOAD_B` and `STORE_B` deal with bytes. If we want to store floats, we might have to store them byte-by-byte or just store them as pointers if we can cast. Actually, wait. We can just use `STORE_PTR` to store the 64-bit bits of a float if we had a way to cast, but we don't. We'll store Floats in AST using `STORE_B` loop if necessary, or we only store integers/pointers for AST nodes using `STORE_PTR` and `LOAD_PTR`).

Actually, `LOAD_PTR` reads a 64-bit value to a pointer register. `STORE_PTR` writes from a pointer register. So we can use pointer registers to hold integer data (like node types, token types) and store them via `STORE_PTR`. Float values in `rdi` can't easily be written to memory except via `STORE_B`.
