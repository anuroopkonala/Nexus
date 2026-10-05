import re
with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()

checks = re.findall(r'(\.check_[A-Z_]+):\n.*?jne (\.[a-zA-Z_]+)', c, re.DOTALL)
for block, jump in checks:
    print(f"{block} -> {jump}")
