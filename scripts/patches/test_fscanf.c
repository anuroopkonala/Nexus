#include <stdio.h>
int main() {
    FILE *f = fopen("compiler_full.nxasm", "r");
    char buf[256];
    int res = fscanf(f, "%s", buf);
    printf("Result: %d, String: %s\n", res, buf);
    return 0;
}
