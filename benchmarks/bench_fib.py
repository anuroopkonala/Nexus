import time

def fib(n):
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)

def main():
    t1 = time.perf_counter()
    r = fib(35)
    t2 = time.perf_counter()
    ms = (t2 - t1) * 1000.0
    print(f"Fib: {r}, Time: {ms:.2f} ms")

if __name__ == "__main__":
    main()
