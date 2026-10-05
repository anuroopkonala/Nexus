with open('nexus_core.s', 'r', encoding='utf-8') as f:
    for line in f:
        if 'str_GET_OP:' in line:
            print(repr(line))
