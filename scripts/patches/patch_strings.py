import re

with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()

c = c.replace('str_STORE_I: .asciz "STORE_I"', 'str_STORE_I: .asciz "STORE_I"\nstr_DICT_NEW: .asciz "DICT_NEW"\nstr_DICT_SET: .asciz "DICT_SET"\nstr_DICT_GET: .asciz "DICT_GET"\nstr_LOAD_RAW: .asciz "LOAD_RAW"')

with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
