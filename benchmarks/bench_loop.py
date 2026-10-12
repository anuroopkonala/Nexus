import sys
import time

def main():
    n = 1000000
    if len(sys.argv) > 1:
        n = int(sys.argv[1])

    start = time.perf_counter()
    sum_val = 0
    i = 0
    while i < n:
        sum_val += i
        i += 1
    end = time.perf_counter()

    elapsed_ms = (end - start) * 1000.0
    print(f"Python {n} loop done!")
    print(f"Sum: {sum_val}")
    print(f"Loop duration: {elapsed_ms:.2f} ms")

if __name__ == "__main__":
    main()
