let test_addition () =
  let tokens = Lexer.tokenize (Utils.explode "3 + 4") in
  let ast = Parser.parse tokens in
  let result = Calculator.eval ast in
  Alcotest.(check int) "3 + 4 = 7" 7 result

let test_subtraction () =
  let tokens = Lexer.tokenize (Utils.explode "5 - 12") in
  let ast = Parser.parse tokens in
  let result = Calculator.eval ast in
  Alcotest.(check int) "5 - 12 = -7" (-7) result

let test_multiplication () =
  let tokens = Lexer.tokenize (Utils.explode "3 * 4") in
  let ast = Parser.parse tokens in
  let result = Calculator.eval ast in
  Alcotest.(check int) "3 * 4 = 12" 12 result

let test_division () =
  let tokens = Lexer.tokenize (Utils.explode "8 / 2") in
  let ast = Parser.parse tokens in
  let result = Calculator.eval ast in
  Alcotest.(check int) "8 / 2 = 4" 4 result

let test_left_associativity () =
  let tokens = Lexer.tokenize (Utils.explode "3 - 2 - 1") in
  let ast = Parser.parse tokens in
  let result = Calculator.eval ast in
  Alcotest.(check int) "3 - 2 - 1 = 0" 0 result

let test_add_subtract () =
  let tokens = Lexer.tokenize (Utils.explode "1 - 2 + 5") in
  let ast = Parser.parse tokens in
  let result = Calculator.eval ast in
  Alcotest.(check int) "1 - 2 + 5 = 4" 4 result

let test_multiply_divide () =
  let tokens = Lexer.tokenize (Utils.explode "9 * 2 / 6") in
  let ast = Parser.parse tokens in
  let result = Calculator.eval ast in
  Alcotest.(check int) "9 * 2 / 6 = 3" 3 result

let test_multiplication_precedence () =
  let tokens = Lexer.tokenize (Utils.explode "3 + 4 * 2") in
  let ast = Parser.parse tokens in
  let result = Calculator.eval ast in
  Alcotest.(check int) "3 + 4 * 2 = 11" 11 result

let test_division_precedence () =
  let tokens = Lexer.tokenize (Utils.explode "10 - 6 / 3 + 1") in
  let ast = Parser.parse tokens in
  let result = Calculator.eval ast in
  Alcotest.(check int) "10 - 6 / 3 + 1 = 9" 9 result

let test_parenthesized_precedence () =
  let tokens = Lexer.tokenize (Utils.explode "(2 + 3) * 4 / 10") in
  let ast = Parser.parse tokens in
  let result = Calculator.eval ast in
  Alcotest.(check int) "(2 + 3) * 4 / 10 = 2" 2 result

let test_whitespace () =
  let tokens = Lexer.tokenize (Utils.explode ("   1 \012\n\r\t + 1   ")) in
  let ast = Parser.parse tokens in
  let result = Calculator.eval ast in
  Alcotest.(check int) "1 + 1 = 2" 2 result

let test_division_by_zero () =
  Alcotest.check_raises "Division by zero" (Failure "Division by zero.")
    (fun () ->
      let tokens = Lexer.tokenize (Utils.explode "3 / 0") in
      let ast = Parser.parse tokens in
      ignore (Calculator.eval ast))

let test_invalid_char () =
  Alcotest.check_raises "Invalid char fails" (Failure "Invalid character: $")
    (fun () -> ignore (Lexer.tokenize (Utils.explode "3 $ 4")))

let test_incomplete_expression () =
  Alcotest.check_raises "Incomplete expression" (Failure "Expected integer or '('.")
    (fun () -> 
      let tokens = Lexer.tokenize (Utils.explode "3 + ") in
      ignore (Parser.parse tokens))

let test_no_open_paren () =
  Alcotest.check_raises "Missing open parenthesis" (Failure "Missing closing parenthesis.")
    (fun () ->
      let tokens = Lexer.tokenize (Utils.explode "(3 + 4") in
      ignore (Parser.parse tokens))

let test_no_closed_paren () =
  Alcotest.check_raises "Missing closed parenthesis" (Failure "Unexpected tokens at end of input.")
    (fun () ->
      let tokens = Lexer.tokenize (Utils.explode "3 + 4)") in
      ignore (Parser.parse tokens))

let test_invalid_expression () =
  Alcotest.check_raises "Invalid expression" (Failure "Expected integer or '('.")
    (fun () ->
      let tokens = Lexer.tokenize (Utils.explode "+") in
      ignore (Parser.parse tokens))

let () =
  Alcotest.run "Calculator Tests" [
    ("Arithmetic", [
      Alcotest.test_case "Addition" `Quick test_addition;
      Alcotest.test_case "Subtraction" `Quick test_subtraction;
      Alcotest.test_case "Multiplication" `Quick test_multiplication;
      Alcotest.test_case "Division" `Quick test_division;
    ]);
    ("Associativity", [
      Alcotest.test_case "Left associativity" `Quick test_left_associativity;
      Alcotest.test_case "Addition and subtraction" `Quick test_add_subtract;
      Alcotest.test_case "Multiplication and division" `Quick test_multiply_divide;
    ]);
    ("Precedence", [
      Alcotest.test_case "Multiplication precedence" `Quick test_multiplication_precedence;
      Alcotest.test_case "Division precedence" `Quick test_division_precedence;
      Alcotest.test_case "Parenthesized precedence" `Quick test_parenthesized_precedence;
    ]);
    ("Whitespace", [
      Alcotest.test_case "Ignore whitespace" `Quick test_whitespace;
    ]);
    ("Errors", [
      Alcotest.test_case "Division by zero" `Quick test_division_by_zero;
      Alcotest.test_case "Invalid character" `Quick test_invalid_char;
      Alcotest.test_case "Incomplete expression" `Quick test_incomplete_expression;
      Alcotest.test_case "Missing open parenthesis" `Quick test_no_open_paren;
      Alcotest.test_case "Missing closed parenthesis" `Quick test_no_closed_paren;
      Alcotest.test_case "Invalid expression" `Quick test_invalid_expression;
    ]);
  ]
