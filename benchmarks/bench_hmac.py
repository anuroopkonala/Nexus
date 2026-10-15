import hmac
import hashlib
import time

def main():
    key = b"SecretKeyNexusBaremetal2026"
    msg = b"TheQuickBrownFoxJumpsOverTheLazyDogAndRunsFast"
    t1 = time.perf_counter()
    total_len = 0
    for _ in range(25000):
        mac = hmac.new(key, msg, hashlib.sha256).hexdigest()
        total_len += len(mac)
    t2 = time.perf_counter()
    ms = (t2 - t1) * 1000.0
    print(f"Total: {total_len}, Time: {ms:.2f} ms")

if __name__ == "__main__":
    main()
