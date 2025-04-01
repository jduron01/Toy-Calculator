type token = Int of int | Add | Sub | Mul | Div | LParen | RParen | EOF

let tokenize lexemes =
  let rec aux ls tokens =
    match ls with
      [] -> List.rev (EOF::tokens)
    |
      n::t when Utils.is_digit n ->
        let integer_str = Utils.read_integer (n::t) in
        let rest = Utils.drop (String.length integer_str) (n::t) in
        aux rest (Int (int_of_string integer_str)::tokens)
    |
      '+'::t -> aux t (Add::tokens)
    |
      '-'::h::t ->
        if Utils.is_digit h then
          let integer_str = Utils.read_integer ('-'::h::t) in
          let rest = Utils.drop (String.length integer_str) ('-'::h::t) in
          aux rest (Int (int_of_string integer_str)::tokens)
        else aux t (Sub::tokens)
    |
      '*'::t -> aux t (Mul::tokens)
    |
      '/'::t -> aux t (Div::tokens)
    |
      '('::t -> aux t (LParen::tokens)
    |
      ')'::t -> aux t (RParen::tokens)
    |
      w::t when Utils.is_whitespace w -> aux t tokens
    |
      c::_ -> failwith ("Invalid character: " ^ String.make 1 c)
  in aux lexemes []