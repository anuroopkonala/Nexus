import time

def main():
    a = 1.00000001
    b = 0.00000002
    c = 0.5
    total = 0.0
    t1 = time.perf_counter()
    for _ in range(20000000):
        c = (c * a) + b
        total += c
    t2 = time.perf_counter()
    ms = (t2 - t1) * 1000.0
    print(f"Total: {int(total)}, Time: {ms:.2f} ms")

if __name__ == "__main__":
    main()
