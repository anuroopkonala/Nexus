import time

class BaseCounter:
    def add(self, n):
        return n + 1

class Counter1(BaseCounter):
    def add(self, n):
        return n + 1

class Counter2(BaseCounter):
    def add(self, n):
        return n + 1

c1 = Counter1()
c2 = Counter2()

def get_counter(i):
    return c1 if (i & 1) else c2

def main():
    t1 = time.perf_counter()
    total = 0
    for i in range(5000000):
        c = get_counter(i)
        total = c.add(total)
    t2 = time.perf_counter()
    ms = (t2 - t1) * 1000.0
    print(f"Total: {total}, Time: {ms:.2f} ms")

if __name__ == "__main__":
    main()
