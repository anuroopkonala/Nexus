#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>

typedef struct {
    char delim;
    int line;
    int col;
    const char* line_ptr;
} DelimEntry;

static DelimEntry delim_stack[2048];
static int delim_top = 0;

void print_diagnostic(int is_warning, const char* code, const char* title, const char* filename,
                      int line, int col, const char* src_line, int caret_width,
                      const char* caret_label, const char* note, const char* help) {
    char clean_line[512];
    char pad[512];
    char caret[512];

    int len = 0;
    while (src_line[len] && src_line[len] != '\r' && src_line[len] != '\n' && len < 500) {
        clean_line[len] = src_line[len];
        len++;
    }
    clean_line[len] = '\0';

    int pad_len = (col > 1) ? (col - 1) : 0;
    if (pad_len > 480) pad_len = 480;
    for (int i = 0; i < pad_len; i++) pad[i] = ' ';
    pad[pad_len] = '\0';

    int c_idx = 0;
    if (caret_width < 1) caret_width = 1;
    for (int i = 0; i < caret_width && c_idx < 450; i++) {
        caret[c_idx++] = '^';
    }
    caret[c_idx++] = ' ';
    int l_idx = 0;
    while (caret_label[l_idx] && c_idx < 500) {
        caret[c_idx++] = caret_label[l_idx++];
    }
    caret[c_idx] = '\0';

    const char* color_code = is_warning ? "\033[1;33m" : "\033[1;31m";
    printf("\n%s%s\033[0m: \033[1m%s\033[0m\n", color_code, code, title);
    printf("  \033[1;34m-->\033[0m \033[1;37m%s:%d:%d\033[0m\n", filename, line, col);
    printf("   \033[1;34m|\033[0m\n");
    printf(" \033[1;34m%3d |\033[0m %s\n", line, clean_line);
    printf("   \033[1;34m|\033[0m %s%s%s\033[0m\n", pad, color_code, caret);
    printf("   \033[1;34m|\033[0m\n");
    printf("   \033[1;34m=\033[0m \033[1mnote\033[0m: %s\n", note);
    printf("   \033[1;34m=\033[0m \033[1mhelp\033[0m: %s\n\n", help);
    fflush(stdout);
}

int scan_and_diagnose_preflight(const char* filename) {
    if (!filename) return 0;
    FILE* f = fopen(filename, "rb");
    if (!f) return 0;

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    if (size <= 0 || size > 32 * 1024 * 1024) {
        fclose(f);
        return 0;
    }

    char* buf = (char*)malloc(size + 16);
    if (!buf) {
        fclose(f);
        return 0;
    }

    fread(buf, 1, size, f);
    fclose(f);
    buf[size] = '\0';

    delim_top = 0;
    int line_no = 1;
    const char* line_start = buf;
    const char* p = buf;

    while (*p) {
        char c = *p;

        if (c == '\n') {
            line_no++;
            line_start = p + 1;
            p++;
            continue;
        }

        if (c == ' ' || c == '\t' || c == '\r') {
            p++;
            continue;
        }

        if (c == '#' || (c == '/' && *(p + 1) == '/')) {
            while (*p && *p != '\n') p++;
            continue;
        }

        if (c == '/' && *(p + 1) == '*') {
            p += 2;
            while (*p && !(*p == '*' && *(p + 1) == '/')) {
                if (*p == '\n') {
                    line_no++;
                    line_start = p + 1;
                }
                p++;
            }
            if (*p) p += 2;
            continue;
        }

        if (c == '"') {
            int str_line = line_no;
            int str_col = (int)(p - line_start + 1);
            const char* str_line_ptr = line_start;
            p++;
            int closed = 0;
            while (*p && *p != '\n') {
                if (*p == '\\') {
                    p++;
                    if (*p) p++;
                    continue;
                }
                if (*p == '"') {
                    closed = 1;
                    p++;
                    break;
                }
                p++;
            }
            if (!closed) {
                print_diagnostic(0, "error[E0002]", "lexical error: unclosed string literal",
                                 filename, str_line, str_col, str_line_ptr, 1,
                                 "string literal is missing closing quote",
                                 "string literal was opened with '\"' but never terminated before newline or EOF",
                                 "add a matching double quote '\"' before the end of the line");
                free(buf);
                return 1;
            }
            continue;
        }

        if (c == '=') {
            char prev = (p > line_start) ? *(p - 1) : ' ';
            char next = *(p + 1);
            if (prev != '!' && prev != '<' && prev != '>' && prev != '=' &&
                prev != '+' && prev != '-' && prev != '*' && prev != '/' &&
                next != '=') {
                const char* q = p + 1;
                while (*q == ' ' || *q == '\t' || *q == '\r') q++;
                if (*q == ';' || *q == '\n' || *q == '\0') {
                    int err_col = (int)(q - line_start + 1);
                    print_diagnostic(0, "error[E0001]", "syntax error: expected expression after '='",
                                     filename, line_no, err_col, line_start, 1,
                                     "expected expression here",
                                     "assignment operator '=' requires a right-hand side expression",
                                     "provide a value or expression, e.g., 'let x = 0;'");
                    free(buf);
                    return 1;
                }
            }
        }

        if (c == '(' || c == '[' || c == '{') {
            if (delim_top < 2000) {
                delim_stack[delim_top].delim = c;
                delim_stack[delim_top].line = line_no;
                delim_stack[delim_top].col = (int)(p - line_start + 1);
                delim_stack[delim_top].line_ptr = line_start;
                delim_top++;
            }
            p++;
            continue;
        }

        if (c == ')' || c == ']' || c == '}') {
            char expected = (c == ')') ? '(' : (c == ']' ? '[' : '{');
            if (delim_top > 0 && delim_stack[delim_top - 1].delim == expected) {
                delim_top--;
            } else {
                int err_col = (int)(p - line_start + 1);
                char label[64];
                sprintf(label, "unexpected closing delimiter '%c'", c);
                char help[64];
                sprintf(help, "check delimiter matching and remove unmatched '%c'", c);
                print_diagnostic(0, "error[E0102]", "syntax error: mismatched closing delimiter",
                                 filename, line_no, err_col, line_start, 1,
                                 label, "delimiter closing does not match any open delimiter", help);
                free(buf);
                return 1;
            }
            p++;
            continue;
        }

        if (c == '@' || c == '$' || c == '`' || c == '\\') {
            int err_col = (int)(p - line_start + 1);
            char label[64];
            sprintf(label, "character '%c' is not recognized in Nexus syntax", c);
            print_diagnostic(0, "error[E0003]", "lexical error: unrecognized character",
                             filename, line_no, err_col, line_start, 1,
                             label, "character is not a valid identifier or operator in Nexus",
                             "remove the invalid character or replace with a supported operator");
            free(buf);
            return 1;
        }

        if ((c == 'r') && (p == line_start || *(p-1) == ' ' || *(p-1) == '\t' || *(p-1) == ';' || *(p-1) == '{') &&
            strncmp(p, "return", 6) == 0 &&
            (*(p+6) == ' ' || *(p+6) == '\t' || *(p+6) == ';' || *(p+6) == '\n' || *(p+6) == '\r' || *(p+6) == '}')) {
            const char* q = p + 6;
            while (*q && *q != ';' && *q != '\n' && *q != '}') q++;
            if (*q == ';') q++;
            int dead_line = line_no;
            const char* dead_line_start = line_start;
            while (*q == ' ' || *q == '\t' || *q == '\r' || *q == '\n') {
                if (*q == '\n') {
                    dead_line++;
                    dead_line_start = q + 1;
                }
                q++;
            }
            if (*q && *q != '}' && *q != '#' && *q != '/') {
                int warn_col = (int)(q - dead_line_start + 1);
                print_diagnostic(1, "warning[W0001]", "unreachable statement detected",
                                 filename, dead_line, warn_col, dead_line_start, 19,
                                 "this code will never be executed",
                                 "statement follows a 'return' statement in the same block",
                                 "remove the unreachable statement or move it before 'return'");
            }
        }

        p++;
    }

    if (delim_top > 0) {
        DelimEntry top = delim_stack[delim_top - 1];
        char exp_close = (top.delim == '(') ? ')' : (top.delim == '[' ? ']' : '}');
        char label[64];
        sprintf(label, "unclosed '%c', expected matching '%c'", top.delim, exp_close);
        char help[64];
        sprintf(help, "add matching closing delimiter '%c'", exp_close);
        print_diagnostic(0, "error[E0102]", "syntax error: unclosed delimiter",
                         filename, top.line, top.col, top.line_ptr, 1,
                         label, "delimiter was opened here but never closed before end of file", help);
        free(buf);
        return 1;
    }

    free(buf);
    return 0;
}

void report_runtime_unresolved(const char* filename, const char* hint_method) {
    if (!filename) return;
    FILE* f = fopen(filename, "rb");
    if (!f) {
        printf("\n\033[1;31merror[E0502]\033[0m: \033[1mruntime exception: unresolved method or function call\033[0m\n");
        printf("  \033[1;34m-->\033[0m \033[1;37m%s\033[0m\n", filename);
        printf("   \033[1;34m|\033[0m\n");
        printf("   \033[1;34m=\033[0m \033[1mnote\033[0m: attempted to call an undefined function or null method pointer\n");
        printf("   \033[1;34m=\033[0m \033[1mhelp\033[0m: verify method spelling or ensure the target object supports this method\n\n");
        fflush(stdout);
        return;
    }

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    char* buf = (char*)malloc(size + 16);
    if (!buf) {
        fclose(f);
        return;
    }
    fread(buf, 1, size, f);
    fclose(f);
    buf[size] = '\0';

    int line_no = 1;
    const char* line_start = buf;
    const char* p = buf;

    int found_line = 0;
    int found_col = 0;
    int found_len = 0;
    const char* found_line_ptr = NULL;
    char found_ident[128] = "unknown_method";

    while (*p) {
        if (*p == '\n') {
            line_no++;
            line_start = p + 1;
            p++;
            continue;
        }

        if (*p == '.' && ((*(p+1) >= 'a' && *(p+1) <= 'z') || (*p+1 >= 'A' && *(p+1) <= 'Z') || *(p+1) == '_')) {
            const char* ident_start = p + 1;
            const char* q = ident_start;
            while ((*q >= 'a' && *q <= 'z') || (*q >= 'A' && *q <= 'Z') || (*q >= '0' && *q <= '9') || *q == '_') q++;
            const char* after_ws = q;
            while (*after_ws == ' ' || *after_ws == '\t') after_ws++;
            if (*after_ws == '(') {
                int id_len = (int)(q - ident_start);
                if (!hint_method || strncmp(ident_start, hint_method, id_len) == 0) {
                    found_line = line_no;
                    found_col = (int)(ident_start - line_start + 1);
                    found_len = id_len;
                    found_line_ptr = line_start;
                    if (id_len < 120) {
                        strncpy(found_ident, ident_start, id_len);
                        found_ident[id_len] = '\0';
                    }
                    if (hint_method) break;
                }
            }
        }
        p++;
    }

    if (found_line > 0) {
        char label[256];
        sprintf(label, "method '%s' is not defined on target object", found_ident);
        print_diagnostic(0, "error[E0502]", "runtime exception: unresolved method or function call",
                         filename, found_line, found_col, found_line_ptr, found_len,
                         label, "attempted to call an undefined function or null method pointer",
                         "verify method spelling or ensure the target object implements this method");
    } else {
        printf("\n\033[1;31merror[E0502]\033[0m: \033[1mruntime exception: unresolved method or function call\033[0m\n");
        printf("  \033[1;34m-->\033[0m \033[1;37m%s\033[0m\n", filename);
        printf("   \033[1;34m|\033[0m\n");
        printf("   \033[1;34m=\033[0m \033[1mnote\033[0m: attempted to call an undefined function or null method pointer\n");
        printf("   \033[1;34m=\033[0m \033[1mhelp\033[0m: verify method spelling or ensure the target object supports this method\n\n");
        fflush(stdout);
    }
    free(buf);
}

void report_runtime_div_zero(const char* filename) {
    if (!filename) return;
    FILE* f = fopen(filename, "rb");
    if (!f) {
        printf("\n\033[1;31merror[E0503]\033[0m: \033[1mruntime exception: division by zero\033[0m\n");
        printf("  \033[1;34m-->\033[0m \033[1;37m%s\033[0m\n", filename);
        printf("   \033[1;34m|\033[0m\n");
        printf("   \033[1;34m=\033[0m \033[1mnote\033[0m: mathematical operation resulted in division by zero\n");
        printf("   \033[1;34m=\033[0m \033[1mhelp\033[0m: verify denominator is non-zero before performing division or modulo\n\n");
        fflush(stdout);
        return;
    }

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    char* buf = (char*)malloc(size + 16);
    if (!buf) {
        fclose(f);
        return;
    }
    fread(buf, 1, size, f);
    fclose(f);
    buf[size] = '\0';

    int line_no = 1;
    const char* line_start = buf;
    const char* p = buf;

    int found_line = 0;
    int found_col = 0;
    const char* found_line_ptr = NULL;

    while (*p) {
        if (*p == '\n') {
            line_no++;
            line_start = p + 1;
            p++;
            continue;
        }

        if (*p == '#' || (*p == '/' && *(p+1) == '/')) {
            while (*p && *p != '\n') p++;
            continue;
        }

        if ((*p == '/' && *(p+1) != '/') || *p == '%') {
            found_line = line_no;
            found_col = (int)(p - line_start + 1);
            found_line_ptr = line_start;
            const char* q = p + 1;
            while (*q == ' ' || *q == '\t') q++;
            if (*q == '0') {
                break;
            }
        }
        p++;
    }

    if (found_line > 0) {
        print_diagnostic(0, "error[E0503]", "runtime exception: division by zero",
                         filename, found_line, found_col, found_line_ptr, 1,
                         "division or modulo by zero",
                         "mathematical operation resulted in division by zero",
                         "verify denominator is non-zero before performing division or modulo");
    } else {
        printf("\n\033[1;31merror[E0503]\033[0m: \033[1mruntime exception: division by zero\033[0m\n");
        printf("  \033[1;34m-->\033[0m \033[1;37m%s\033[0m\n", filename);
        printf("   \033[1;34m|\033[0m\n");
        printf("   \033[1;34m=\033[0m \033[1mnote\033[0m: mathematical operation resulted in division by zero\n");
        printf("   \033[1;34m=\033[0m \033[1mhelp\033[0m: verify denominator is non-zero before performing division or modulo\n\n");
        fflush(stdout);
    }
    free(buf);
}

void report_runtime_stack_overflow(const char* filename, void* rip) {
    printf("\n\033[1;31merror[E0505]\033[0m: \033[1mruntime exception: call stack overflow\033[0m\n");
    printf("  \033[1;34m-->\033[0m \033[1;37m%s\033[0m\n", filename ? filename : "<script.nx>");
    printf("   \033[1;34m|\033[0m\n");
    printf("   \033[1;34m=\033[0m \033[1mnote\033[0m: maximum call recursion depth exceeded (RIP=%p)\n", rip);
    printf("   \033[1;34m=\033[0m \033[1mhelp\033[0m: check for unbounded recursion or missing base case in function calls\n\n");
    fflush(stdout);
}

void report_runtime_access_violation(const char* filename, void* rip) {
    printf("\n\033[1;31merror[E0501]\033[0m: \033[1mruntime exception: memory access violation\033[0m\n");
    printf("  \033[1;34m-->\033[0m \033[1;37m%s\033[0m\n", filename ? filename : "<script.nx>");
    printf("   \033[1;34m|\033[0m\n");
    printf("   \033[1;34m=\033[0m \033[1mnote\033[0m: attempted to access unmapped memory or dereference null pointer (RIP=%p)\n", rip);
    printf("   \033[1;34m=\033[0m \033[1mhelp\033[0m: verify object initialization, array bounds, and memory safety invariants\n\n");
    fflush(stdout);
}
