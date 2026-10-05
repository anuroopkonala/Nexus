import re

with open('nexus_core2.s', 'r', encoding='utf-8') as f:
    c2 = f.read()

strings_match = re.search(r'(str_DICT_NEW:.*?str_LOAD_RAW:.*?asciz "LOAD_RAW")', c2, re.DOTALL)
opcodes_match = re.search(r'(op_dict_new:.*NEXT\n\n)', c2, re.DOTALL)
checks_match = re.search(r'(\.check_DICT_NEW:.*?\.check_LOAD_RAW_next:\n)', c2, re.DOTALL)

with open('nexus_core.s', 'r', encoding='utf-8') as f:
    c = f.read()

if strings_match:
    c = c.replace('str_STORE_I: .asciz "STORE_I"', 'str_STORE_I: .asciz "STORE_I"\n' + strings_match.group(1))

if opcodes_match:
    c = c.replace('op_free:', opcodes_match.group(1) + 'op_free:')

if checks_match:
    c = c.replace('.check_POP_PTR:', checks_match.group(1) + '    jmp .read_loop\n.check_POP_PTR:')

with open('nexus_core.s', 'w', encoding='utf-8') as f:
    f.write(c)
