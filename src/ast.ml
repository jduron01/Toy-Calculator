type expression =
    Operation of operator * expression * expression
  |
    Parenthesized of expression
  |
    Int of int
and operator = Add | Sub | Mul | Div