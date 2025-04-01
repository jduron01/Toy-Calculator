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

let rec calculator () =
  print_string "> ";
  let input = read_line () in
  if input = "q" then exit 0
  else
    let tokens = Lexer.tokenize (Utils.explode input) in
    let ast = Parser.parse tokens in
    let result = eval ast in
    Printf.printf "Result: %d\n" result;
    calculator ()

let () = calculator ()