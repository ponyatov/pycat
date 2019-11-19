
## Pycat syntax parser

import ply.lex  as lex
import ply.yacc as yacc

tokens = ['var']

def t_var(t):
    r'[A-Z][A-Za-z0-9_]*'
    return Var(t.value)

def t_error(t):
    raise SyntaxError(t)

lexer = lex.lex()
