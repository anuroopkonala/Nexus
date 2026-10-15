#include <iostream>
#include <string>
#include <chrono>
#include <winsock2.h>
#include <ws2tcpip.h>

#pragma comment(lib, "ws2_32.lib")

int main() {
    WSADATA wsa;
    WSAStartup(MAKEWORD(2, 2), &wsa);

    int port = 28999;

    SOCKET srv = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    int opt = 1;
    setsockopt(srv, SOL_SOCKET, SO_REUSEADDR, (const char*)&opt, sizeof(opt));
    setsockopt(srv, IPPROTO_TCP, TCP_NODELAY, (const char*)&opt, sizeof(opt));

    sockaddr_in srv_addr{};
    srv_addr.sin_family = AF_INET;
    srv_addr.sin_port = htons(port);
    srv_addr.sin_addr.s_addr = htonl(INADDR_ANY);

    bind(srv, (sockaddr*)&srv_addr, sizeof(srv_addr));
    listen(srv, 10);

    SOCKET cli = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    setsockopt(cli, IPPROTO_TCP, TCP_NODELAY, (const char*)&opt, sizeof(opt));

    sockaddr_in cli_target{};
    cli_target.sin_family = AF_INET;
    cli_target.sin_port = htons(port);
    cli_target.sin_addr.s_addr = inet_addr("127.0.0.1");

    connect(cli, (sockaddr*)&cli_target, sizeof(cli_target));

    SOCKET peer = accept(srv, nullptr, nullptr);
    setsockopt(peer, IPPROTO_TCP, TCP_NODELAY, (const char*)&opt, sizeof(opt));

    std::string req_msg = "PING_REQ_DATA_9876543210";
    std::string ack_msg = "PONG_ACK_DATA_9876543210";

    char recv_buf[65];

    auto t1 = std::chrono::high_resolution_clock::now();

    long long total_bytes = 0;
    for (int i = 0; i < 10000; i++) {
        send(cli, req_msg.c_str(), (int)req_msg.length(), 0);
        int n1 = recv(peer, recv_buf, 64, 0);
        if (n1 > 0) total_bytes += n1;

        send(peer, ack_msg.c_str(), (int)ack_msg.length(), 0);
        int n2 = recv(cli, recv_buf, 64, 0);
        if (n2 > 0) total_bytes += n2;
    }

    auto t2 = std::chrono::high_resolution_clock::now();
    double ms = std::chrono::duration<double, std::milli>(t2 - t1).count();

    closesocket(cli);
    closesocket(peer);
    closesocket(srv);
    WSACleanup();

    std::cout << "TotalBytes: " << total_bytes << ", Time: " << ms << " ms\n";
    return 0;
}
