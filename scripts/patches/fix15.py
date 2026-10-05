with open('nexus_core.s', 'r', encoding='utf-8') as f:
    lines = f.readlines()
lines = lines[:1362] + lines[1369:]
with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.writelines(lines)
