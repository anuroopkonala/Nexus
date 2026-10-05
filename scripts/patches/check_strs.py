import re
with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()
used = set(re.findall(r'lea rdx, \[rip \+ (str_[A-Z_]+)\]', c))
defined = set(re.findall(r'(str_[A-Z_]+): \.asciz', c))
print("Used but not defined:", used - defined)
