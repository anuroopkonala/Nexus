#include <iostream>
#include <chrono>

int main() {
    double a = 1.00000001;
    double b = 0.00000002;
    double c = 0.5;
    double total = 0.0;
    auto t1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < 20000000; i++) {
        c = (c * a) + b;
        total += c;
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    double ms = std::chrono::duration<double, std::milli>(t2 - t1).count();
    std::cout << "Total: " << (long long)total << ", Time: " << ms << " ms\n";
    return 0;
}