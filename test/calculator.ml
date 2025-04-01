let rec eval ls =
  match ls with
    Ast.Int n -> n
  |
    Ast.Operation (Ast.Add, a, b) -> eval a + eval b
  |
    Ast.Operation (Ast.Sub, a, b) -> eval a - eval b
  |
    Ast.Operation (Ast.Mul, a, b) -> eval a * eval b
  |
    Ast.Operation (Ast.Div, a, b) -> eval a / eval b
  |
    Ast.Parenthesized expr -> eval expr