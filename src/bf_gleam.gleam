import gleam/erlang
import gleam/io
import gleam/string
import interpreter
import lexer
import tape

pub fn main() {
  // let filepath = case erlang.get_line("Enter the filepath: ") {
  //   Ok(text) -> text |> string.trim
  //   Error(_) -> panic
  // }
  let filepath = "examples/print_a.bf"
  io.println("filepath: " <> filepath)
  let tokens = lexer.lex(filepath)
  let tape = tape.new(128)
  interpreter.interp(tokens, tape, [])
}
