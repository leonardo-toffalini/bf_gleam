import gleam/io
import gleam/result
import gleam/string
import gleam/list
import gleam/erlang
import lexer
import tape.{type Tape}
import token.{type Token}

type Program =
  List(Token)

type Stack =
  List(Program)

type ProgramResult =
  Result(Nil, String)

pub fn run(filepath) -> ProgramResult {
  let tape = tape.new(1024)
  let tokens = lexer.lex(filepath)
  interp(tokens, tape, [])
}

fn interp(program: Program, tape: Tape, stack: Stack) -> ProgramResult {
  case program {
    [] -> Ok(Nil)
    [token, ..rest] ->
      case token.token_type {
        token.Increment -> increment(rest, tape, stack)
        token.Decrement -> decrement(rest, tape, stack)
        token.Plus -> plus(rest, tape, stack)
        token.Minus -> minus(rest, tape, stack)
        token.Dot -> dot(rest, tape, stack)
        token.Comma -> comma(rest, tape, stack)
        token.Lbracket -> lbracket(rest, tape, stack)
        token.Rbracket -> rbracket(rest, tape, stack)
      }
  }
}

fn increment(program: Program, tape: Tape, stack: Stack) {
  tape.increment(tape)
  |> interp(program, _, stack)
}

fn decrement(program: Program, tape: Tape, stack: Stack) {
  tape.decrement(tape)
  |> interp(program, _, stack)
}

fn plus(program: Program, tape: Tape, stack: Stack) {
  tape.plus(tape)
  |> interp(program, _, stack)
}

fn minus(program: Program, tape: Tape, stack: Stack) {
  tape.minus(tape)
  |> interp(program, _, stack)
}

fn dot(program: Program, tape: Tape, stack: Stack) {
  tape
  |> tape.get
  |> string.utf_codepoint
  |> result.map(fn(x) { [x] })
  |> result.unwrap(string.to_utf_codepoints("�"))
  |> string.from_utf_codepoints
  |> io.print

  interp(program, tape, stack)
}

fn comma(program: Program, tape: Tape, stack: Stack) {
  let input = case erlang.get_line("") {
    Ok(val) -> val
    Error(_) -> panic
}
  let tape =
    input
    |> string.to_graphemes
    |> list.first
    |> result.map(fn(grapheme) {
      grapheme
      |> string.to_utf_codepoints
      |> list.first
      |> result.map(fn(codepoint) { string.utf_codepoint_to_int(codepoint) })
      |> result.unwrap(0)
    })
    |> result.unwrap(0)
    |> tape.set(tape, _)

  interp(program, tape, stack)
}

fn lbracket(program: Program, tape: Tape, stack: Stack) -> ProgramResult {
  case program, tape.get(tape) {
    [], _ -> Error("Unmatched left bracket.")
    _, 0 ->
      case skip_forward(program, 0) {
        Ok(program_after) -> interp(program_after, tape, stack)
        Error(text) -> Error(text)
      }
    _, _ -> interp(program, tape, [program, ..stack])
  }
}

fn rbracket(program: Program, tape: Tape, stack: Stack) -> ProgramResult {
  case stack, tape.get(tape) {
    [], _ -> Error("Unmatched left bracket.")
    [_, ..rest], 0 -> interp(program, tape, rest)
    [loop_body, ..], _ -> interp(loop_body, tape, stack)
  }
}

fn skip_forward(program: Program, num_seen: Int) -> Result(Program, String) {
  case program, num_seen {
    [], _ -> Error("Unmatched brackets.")
    [t, ..rest], num_seen ->
      case t.token_type, num_seen {
        token.Rbracket, 0 -> Ok(rest)
        token.Lbracket, _ -> skip_forward(rest, num_seen + 1)
        token.Rbracket, _ -> skip_forward(rest, num_seen - 1)
        _, _ -> skip_forward(rest, num_seen)
      }
  }
}
