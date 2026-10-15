#include <iostream>
#include <chrono>

int main() {
    auto t1 = std::chrono::high_resolution_clock::now();
    long long sum = 0;
    long long i = 0;
    volatile long long n = 50000000;
    while (i < n) {
        sum += i;
        i += 1;
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    double ms = std::chrono::duration<double, std::milli>(t2 - t1).count();
    std::cout << "Sum: " << sum << ", Time: " << ms << " ms\n";
    return 0;
}
