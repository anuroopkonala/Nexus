import hashlib
import time

def main():
    s = b"NexusBaremetalSpeedTestStringOptimization2026"
    t1 = time.perf_counter()
    total_len = 0
    for _ in range(50000):
        h = hashlib.sha256(s).hexdigest()
        total_len += len(h)
    t2 = time.perf_counter()
    ms = (t2 - t1) * 1000.0
    print(f"Total: {total_len}, Time: {ms:.2f} ms")

if __name__ == "__main__":
    main()
