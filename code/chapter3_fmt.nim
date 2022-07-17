type
  TokenKind = enum  # <1>
    Literal # <2>
    NimExpr # <3>

iterator tokenize(s: string): (TokenKind, string) = # <4>
  var i = 0
  var tok = Literal # <5>
  while i < s.len:
    let start = i
    case tok
    of Literal:
      while i < s.len and s[i] != '{': inc i # <6>
    of NimExpr:
      while i < s.len and s[i] != '}': inc i # <7>
    yield (tok, s.substr(start, i-1))
    tok = if tok == Literal: NimExpr else: Literal # <8>
    inc i


# this must be line 21

import macros

macro fmt*(pattern: static[string]): string = # <1>
  var args = newTree(nnkBracket) # <2>
  for (k, s) in tokenize(pattern): # <3>
    case k
    of Literal:
      if s != "":
        args.add newLit(s) # <4>
    of NimExpr:
      args.add newCall(bindSym"$", parseExpr(s)) # <5>
  if args.len == 0: # <6>
    result = newLit("")
  else:
    result = nestList(bindSym"&", args) # <7>

var x = 0.9
var y = "abc"

echo fmt"{x} {y}" <8>
