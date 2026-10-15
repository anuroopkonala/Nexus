@
#include <iostream>
#include <chrono>

class BaseCounter {
public:
    virtual long long add(long long n) = 0;
};

class Counter : public BaseCounter {
public:
    long long add(long long n) override {
        return n + 1;
    }
};

int main() {
    BaseCounter* c = new Counter();
    auto t1 = std::chrono::high_resolution_clock::now();
    long long total = 0;
    for (int i = 0; i < 5000000; i++) {
        total = c->add(total);
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    double ms = std::chrono::duration<double, std::milli>(t2 - t1).count();
    std::cout << " Total: \ << total << " Time: \ << ms << " ms\n\;
 return 0;
}
@
