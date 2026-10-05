with open('compiler_full.nxasm', 'rb') as f:
    c = f.read()
idx = c.find(b'GET_OP DICT_NEW')
print(c[idx-20:idx+20])
