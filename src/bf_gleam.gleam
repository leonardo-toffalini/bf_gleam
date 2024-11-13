import gleam/io
import lexer
import interpreter

pub fn main() {
  let filepath = "examples/output.bf"
  let tokens = lexer.lex(filepath)
  interpreter.interp(tokens)
}
