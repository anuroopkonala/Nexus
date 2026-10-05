#include <stdio.h>
int main() {
    FILE *f = fopen("lexer_test.nx", "r");
    int c;
    while ((c = fgetc(f)) != EOF) {}
    printf("EOF is: %d\n", c);
    return 0;
}
