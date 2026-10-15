import time

def main():
    N = 1000000
    arr = []
    t1 = time.perf_counter()
    for i in range(N):
        arr.append(0.0)
    for i in range(N):
        arr[i] = float(i) * 2.5 + 1.0
    total = 0.0
    for i in range(N):
        total += arr[i]
    t2 = time.perf_counter()
    ms = (t2 - t1) * 1000.0
    print(f"Total: {int(total)}, Time: {ms:.2f} ms")

if __name__ == "__main__":
    main()
