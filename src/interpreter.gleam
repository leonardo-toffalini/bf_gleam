import ascii
import gleam/io
import gleam/result
import tape.{type Tape}
import token.{type Token}

type Program =
  List(Token)

type Stack =
  List(Program)

pub fn interp(program: Program, tape: Tape, stack: Stack) {
  case program {
    [] -> Nil
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
        _ -> panic as "Unexpected token type while interpreting."
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
  tape.get(tape) |> ascii.int_to_ascii |> result.unwrap("") |> io.print
  interp(program, tape, stack)
}

fn comma(program: Program, tape: Tape, stack: Stack) {
  todo
}

fn lbracket(program: Program, tape: Tape, stack: Stack) {
  todo
}

fn rbracket(program: Program, tape: Tape, stack: Stack) {
  todo
}

fn skip_forward(program: Program, num_seen: Int) {
  case program, num_seen {
    [], _ -> panic
    [t, ..rest], num_seen ->
      case t.token_type, num_seen {
        token.Rbracket, 0 -> rest
        token.Lbracket, _ -> skip_forward(rest, num_seen + 1)
        token.Rbracket, _ -> skip_forward(rest, num_seen - 1)
        _, _ -> skip_forward(rest, num_seen)
      }
  }
}
