#include <iostream>
#include <chrono>

long long fib(long long n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}

int main() {
    auto t1 = std::chrono::high_resolution_clock::now();
    long long r = fib(35);
    auto t2 = std::chrono::high_resolution_clock::now();
    double ms = std::chrono::duration<double, std::milli>(t2 - t1).count();
    std::cout << "Fib: " << r << ", Time: " << ms << " ms\n";
    return 0;
}
