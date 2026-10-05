#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    FILE* f = fopen("test_gc.nxasm", "r");
    char token[256];
    char reg[256];
    char val[256];
    while(fscanf(f, "%s", token) > 0) {
        printf("Token: %s\n", token);
        if (strcmp(token, "LOAD") == 0) {
            fscanf(f, "%s %s", val, reg);
            printf("  -> val: %f, reg: %d\n", atof(val), atoi(reg));
        } else if (strcmp(token, "LABEL") == 0) {
            fscanf(f, "%s", reg);
            printf("  -> id: %d\n", atoi(reg));
        } else if (strcmp(token, "ALLOC") == 0) {
            fscanf(f, "%s %s", val, reg);
            printf("  -> dest: %d, size_reg: %d\n", atoi(val), atoi(reg));
        } else if (strcmp(token, "ADD") == 0 || strcmp(token, "LT") == 0) {
            char r1[256], r2[256];
            fscanf(f, "%s %s %s", val, r1, r2);
            printf("  -> %s %s %s\n", val, r1, r2);
        } else if (strcmp(token, "JMP_F") == 0) {
            fscanf(f, "%s %s", val, reg);
            printf("  -> cond: %d, target: %d\n", atoi(val), atoi(reg));
        } else if (strcmp(token, "JMP") == 0) {
            fscanf(f, "%s", reg);
            printf("  -> target: %d\n", atoi(reg));
        }
    }
    fclose(f);
    return 0;
}
