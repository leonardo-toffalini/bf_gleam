import interpreter
import lexer

pub fn main() {
  let filepath = "examples/print_a.bf"
  let tokens = lexer.lex(filepath)
  interpreter.interp(tokens)
}
