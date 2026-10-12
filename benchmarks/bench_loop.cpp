#include <iostream>
#include <chrono>

int main(int argc, char** argv) {
    long long n = 1000000; // 1 Million iterations default
    if (argc > 1) {
        n = std::atoll(argv[1]);
    }

    auto start = std::chrono::high_resolution_clock::now();

    volatile double sum = 0;
    for (long long i = 0; i < n; ++i) {
        sum = sum + i;
    }

    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> elapsed = end - start;

    std::cout << "C++ " << n << " loop done!\n";
    std::cout << "Sum: " << (long long)sum << "\n";
    std::cout << "Loop duration: " << elapsed.count() << " ms\n";

    return 0;
}
