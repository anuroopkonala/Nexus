#include <stdio.h>
#include <string.h>

int main() {
    FILE *f = fopen("compiler_full.nxasm", "r");
    char token[256];
    char val[256];
    while (1) {
        int r1 = fscanf(f, "%s", token);
        if (r1 != 1) break;
        if (token[0] == '#') {
            int c;
            while ((c = fgetc(f)) != '\n' && c != EOF) ;
            continue;
        }
        if (strcmp(token, "GET_OP") == 0) {
            int r2 = fscanf(f, "%s", val);
            printf("GET_OP matched. Next fscanf returned %d. val='%s'\n", r2, val);
            break;
        }
    }
    return 0;
}
