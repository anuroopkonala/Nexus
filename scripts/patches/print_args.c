#include <stdio.h>
int main(int argc, char** argv) {
    printf("argc=%d, argv[0]=%s, argv[1]=%s\n", argc, argv[0], argc > 1 ? argv[1] : "none");
    return 0;
}
