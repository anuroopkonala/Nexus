#include <iostream>
#include <string>
#include <chrono>
#include <cstdint>
#include <vector>

static inline uint32_t rotr(uint32_t x, uint32_t n) { return (x >> n) | (x << (32 - n)); }

std::string sha256_bytes(const std::vector<uint8_t>& msg_in) {
    uint32_t h[8] = {
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    };
    static const uint32_t k[64] = {
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    };

    size_t len = msg_in.size();
    size_t padded_len = ((len + 8) / 64 + 1) * 64;
    std::vector<uint8_t> msg = msg_in;
    msg.push_back(0x80);
    while (msg.size() < padded_len - 8) msg.push_back(0);
    uint64_t bit_len = (uint64_t)len * 8;
    for (int i = 7; i >= 0; i--) msg.push_back((uint8_t)((bit_len >> (i * 8)) & 0xFF));

    for (size_t chunk = 0; chunk < padded_len; chunk += 64) {
        uint32_t w[64];
        for (int i = 0; i < 16; i++) {
            w[i] = ((uint32_t)msg[chunk + i*4] << 24) |
                   ((uint32_t)msg[chunk + i*4 + 1] << 16) |
                   ((uint32_t)msg[chunk + i*4 + 2] << 8) |
                   ((uint32_t)msg[chunk + i*4 + 3]);
        }
        for (int i = 16; i < 64; i++) {
            uint32_t s0 = rotr(w[i-15], 7) ^ rotr(w[i-15], 18) ^ (w[i-15] >> 3);
            uint32_t s1 = rotr(w[i-2], 17) ^ rotr(w[i-2], 19) ^ (w[i-2] >> 10);
            w[i] = w[i-16] + s0 + w[i-7] + s1;
        }

        uint32_t a = h[0], b = h[1], c = h[2], d = h[3];
        uint32_t e = h[4], f = h[5], g = h[6], h_val = h[7];

        for (int i = 0; i < 64; i++) {
            uint32_t S1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25);
            uint32_t ch = (e & f) ^ ((~e) & g);
            uint32_t temp1 = h_val + S1 + ch + k[i] + w[i];
            uint32_t S0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22);
            uint32_t maj = (a & b) ^ (a & c) ^ (b & c);
            uint32_t temp2 = S0 + maj;

            h_val = g; g = f; f = e; e = d + temp1;
            d = c; c = b; b = a; a = temp1 + temp2;
        }

        h[0] += a; h[1] += b; h[2] += c; h[3] += d;
        h[4] += e; h[5] += f; h[6] += g; h[7] += h_val;
    }

    char hex[65];
    for (int i = 0; i < 8; i++) sprintf(hex + i*8, "%08x", h[i]);
    hex[64] = 0;
    return std::string(hex);
}

std::string hmac_sha256(const std::string& msg, const std::string& key) {
    uint8_t k_pad[64] = {0};
    for (size_t i = 0; i < key.length() && i < 64; i++) k_pad[i] = (uint8_t)key[i];
    
    std::vector<uint8_t> ipad(64);
    std::vector<uint8_t> opad(64);
    for (int i = 0; i < 64; i++) {
        ipad[i] = k_pad[i] ^ 0x36;
        opad[i] = k_pad[i] ^ 0x5c;
    }
    
    for (char c : msg) ipad.push_back((uint8_t)c);
    std::string inner_hex = sha256_bytes(ipad);
    
    for (size_t i = 0; i < inner_hex.length(); i += 2) {
        uint8_t byte = (uint8_t)std::stoi(inner_hex.substr(i, 2), nullptr, 16);
        opad.push_back(byte);
    }
    return sha256_bytes(opad);
}

int main() {
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string key = "SecretKeyNexusBaremetal2026";
    std::string msg = "TheQuickBrownFoxJumpsOverTheLazyDogAndRunsFast";
    long long total_len = 0;
    for (int i = 0; i < 25000; i++) {
        std::string mac = hmac_sha256(msg, key);
        total_len += mac.length();
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    double ms = std::chrono::duration<double, std::milli>(t2 - t1).count();
    std::cout << "TotalLen: " << total_len << ", Time: " << ms << " ms\n";
    return 0;
}
