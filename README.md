[![Tests](https://github.com/jduron01/Toy-Calculator/actions/workflows/tests.yml/badge.svg)](https://github.com/jduron01/Toy-Calculator/actions/workflows/tests.yml)

# OCaml Toy Calculator

A simple interpreter for arithmetic expressions.

## Features
- Lexer, parser, and AST for math expressions
- Support for `+`, `-`, `*`, `/`, and parentheses
- REPL for interactive evaluation

## Build
```bash
opam install dune alcotest
dune build
```

## Run Program
```bash
./_build/default/src/calculator.exe
```

## Run Tests
```bash
dune test
```
