#include <iostream>
#include <chrono>

class ICounter {
public:
    virtual long long add(long long n) = 0;
    virtual ~ICounter() = default;
};

class BaseCounter : public ICounter {
public:
    long long val = 0;
    long long add(long long n) override {
        return n + 1;
    }
};

class Counter1 : public BaseCounter {
public:
    long long add(long long n) override {
        return n + 1;
    }
};

class Counter2 : public BaseCounter {
public:
    long long add(long long n) override {
        return n + 1;
    }
};

__attribute__((noinline)) ICounter* get_counter(int i) {
    static Counter1 c1;
    static Counter2 c2;
    return (i & 1) ? (ICounter*)&c1 : (ICounter*)&c2;
}

int main() {
    auto t1 = std::chrono::high_resolution_clock::now();
    long long total = 0;
    for (int i = 0; i < 5000000; i++) {
        ICounter* c = get_counter(i);
        total = c->add(total);
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    double ms = std::chrono::duration<double, std::milli>(t2 - t1).count();
    std::cout << "Total: " << total << ", Time: " << ms << " ms\n";
    return 0;
}