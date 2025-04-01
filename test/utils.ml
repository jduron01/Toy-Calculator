let explode s = List.of_seq (String.to_seq s)

let implode ls = String.of_seq (List.to_seq ls)

let rec drop n ls =
  match n, ls with
    0, _ -> ls
  |
    _, [] -> []
  |
    n, _::t -> drop (n - 1) t

let is_digit c = '0' <= c && c <= '9'

let is_whitespace c = String.contains " \012\n\r\t" c

let read_integer n =
  let rec aux ls accum =
    match ls with
      [] -> implode (List.rev accum)
    |
      '-'::t -> aux t ('-'::accum)
    |
      h::t ->
        if is_digit h then aux t (h::accum)
        else implode (List.rev accum)
  in aux n []