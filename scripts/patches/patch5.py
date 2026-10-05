with open('parser_lexer.nxasm', 'rb') as f:
    c = f.read()

old = b'''## No keyword matched ??? emit IDENT
LABEL 299

LOAD 28.0 20
STORE_F 50 60 20'''

new = b'''## No keyword matched ??? emit IDENT
LABEL 299

STORE_B 6 7 11
LOAD 28.0 20
STORE_F 50 60 20'''

c = c.replace(old, new)
with open('parser_lexer.nxasm', 'wb') as f:
    f.write(c)
