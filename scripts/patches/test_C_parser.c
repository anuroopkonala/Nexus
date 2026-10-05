#include <stdio.h>
#include <string.h>

int main() {
    FILE *f = fopen("compiler_full.nxasm", "r");
    char token[256];
    char val[256];
    char reg[256];
    int count = 0;
    while (fscanf(f, "%s", token) == 1) {
        if (token[0] == '#') {
            int c;
            while ((c = fgetc(f)) != '\n' && c != EOF) ;
            continue;
        }
        count++;
        if (strcmp(token, "GET_OP") == 0) {
            fscanf(f, "%s", val);
            fscanf(f, "%s", reg);
            count += 2;
        } else if (strcmp(token, "LOAD") == 0 || strcmp(token, "LOAD_STR") == 0 || strcmp(token, "ALLOC") == 0 || strcmp(token, "FOPEN") == 0 || strcmp(token, "JMP_F") == 0 || strcmp(token, "JMP_O") == 0 || strcmp(token, "JMP_F_O") == 0 || strcmp(token, "FGETC") == 0 || strcmp(token, "MOV") == 0 || strcmp(token, "NOT") == 0 || strcmp(token, "FWRITE") == 0 || strcmp(token, "STR_CAT") == 0) {
            fscanf(f, "%s %s", val, reg);
            count += 2;
        } else if (strcmp(token, "STORE_F") == 0 || strcmp(token, "STORE_I") == 0 || strcmp(token, "STORE_PTR_O") == 0 || strcmp(token, "DICT_SET") == 0 || strcmp(token, "DICT_GET") == 0 || strcmp(token, "EQ") == 0 || strcmp(token, "LT") == 0 || strcmp(token, "GT") == 0 || strcmp(token, "ADD") == 0 || strcmp(token, "SUB") == 0 || strcmp(token, "MUL") == 0 || strcmp(token, "DIV") == 0 || strcmp(token, "STORE_B") == 0 || strcmp(token, "STORE_B_R") == 0 || strcmp(token, "LOAD_B_R") == 0 || strcmp(token, "CMP") == 0 || strcmp(token, "LOAD_B") == 0 || strcmp(token, "LOAD_F") == 0 || strcmp(token, "LOAD_PTR_O") == 0) {
            fscanf(f, "%s %s %s", val, reg, reg);
            count += 3;
        } else if (strcmp(token, "EXEC_DYNAMIC") == 0 || strcmp(token, "CALL") == 0 || strcmp(token, "LABEL") == 0 || strcmp(token, "JMP") == 0 || strcmp(token, "FCLOSE") == 0 || strcmp(token, "DICT_NEW") == 0 || strcmp(token, "POP") == 0 || strcmp(token, "POP_PTR") == 0 || strcmp(token, "PUSH") == 0 || strcmp(token, "PRINT") == 0 || strcmp(token, "LOAD_RAW") == 0 || strcmp(token, "PUSH_PTR") == 0 || strcmp(token, "INPUT") == 0 || strcmp(token, "PRINT_C") == 0 || strcmp(token, "SQRT") == 0 || strcmp(token, "SIN") == 0) {
            fscanf(f, "%s", val);
            count += 1;
        } else if (strcmp(token, "PANIC") == 0 || strcmp(token, "HALT") == 0 || strcmp(token, "RET") == 0) {
            // no args
        }
    }
    printf("Total parsed tokens (instructions + args): %d\n", count);
    return 0;
}
