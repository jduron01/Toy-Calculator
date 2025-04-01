let rec parse_int_paren ls =
  match ls with
    Lexer.Int n::t1 -> (Ast.Int n, t1)
  |
    Lexer.LParen::t1 ->
      let expr, rest = parse_expr t1 in
      (
        match rest with
          Lexer.RParen::t2 -> (Ast.Parenthesized expr, t2)
        |
          _ -> failwith "Missing closing parenthesis."
      )
  |
    _ -> failwith "Expected integer or '('."
and parse_mul_div ls =
  let left, t1 = parse_int_paren ls in
  let rec chain left t1 =
    match t1 with
      Lexer.Mul::t2 ->
        let right, t3 = parse_int_paren t2 in
        chain (Ast.Operation (Ast.Mul, left, right)) t3
    |
      Lexer.Div::t2 ->
        let right, t3 = parse_int_paren t2 in
        (
          match right with
            Ast.Int 0 -> failwith "Division by zero."
          |
            _ -> chain (Ast.Operation (Ast.Div, left, right)) t3
        )
    |
      _ -> (left, t1)
  in chain left t1
and parse_add_sub ls =
  let left, t1 = parse_mul_div ls in
  let rec chain left t1 =
    match t1 with
      Lexer.Add::t2 ->
        let right, t3 = parse_mul_div t2 in
        chain (Ast.Operation (Ast.Add, left, right)) t3
    |
      Lexer.Sub::t2 ->
        let right, t3 = parse_mul_div t2 in
        chain (Ast.Operation (Ast.Sub, left, right)) t3
    |
      _ -> (left, t1)
  in chain left t1
and parse_expr ls = parse_add_sub ls

let parse ls =
  let expr, rest = parse_expr ls in
  match rest with
    [] -> expr
  |
    Lexer.EOF::[] -> expr
  |
    _ -> failwith "Unexpected tokens at end of input."