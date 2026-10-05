#include <stdio.h>
#include <string.h>

int main() {
    FILE *f = fopen("compiler_full.nxasm", "r");
    char token[256];
    char val[256];
    while (fscanf(f, "%s", token) == 1) {
        if (token[0] == '#') {
            int c;
            while ((c = fgetc(f)) != '\n' && c != EOF) ;
            continue;
        }
        if (strcmp(token, "GET_OP") == 0) {
            fscanf(f, "%s", val);
            printf("Found GET_OP, next token: '%s'\n", val);
            break;
        }
    }
    return 0;
}
