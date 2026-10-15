#include <iostream>
#include <vector>
#include <chrono>

int main() {
    int N = 1000000;
    std::vector<double> arr;
    auto t1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < N; i++) {
        arr.push_back(0.0);
    }
    for (int i = 0; i < N; i++) {
        arr[i] = (double)i * 2.5 + 1.0;
    }
    double total = 0.0;
    for (int i = 0; i < N; i++) {
        total += arr[i];
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    double ms = std::chrono::duration<double, std::milli>(t2 - t1).count();
    std::cout << "Total: " << (long long)total << ", Time: " << ms << " ms\n";
    return 0;
}