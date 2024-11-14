import gleam/list

pub opaque type Tape {
  Tape(left: List(Int), right: List(Int))
}

pub fn new(size: Int) -> Tape {
  Tape(left: [], right: list.repeat(0, size))
}

pub fn get(tape: Tape) -> Int {
  case tape.right {
    [] -> panic as "Trying to get element after the end of the tape."
    [x, ..] -> x
  }
}

pub fn set(tape: Tape, val: Int) -> Tape {
  case tape.right {
    [] -> panic as "Trying to set element after the end of the tape."
    [_, ..rest] -> Tape(left: tape.left, right: [val, ..rest])
  }
}

pub fn increment(tape: Tape) -> Tape {
  case tape.right {
    [] -> panic as "Trying to increment tape out of bounds on the right."
    [x, ..rest] -> Tape(left: [x, ..tape.left], right: rest)
  }
}

pub fn decrement(tape: Tape) -> Tape {
  case tape.left {
    [] -> panic as "Trying to decrement tape out of bounds on the left."
    [x, ..rest] -> Tape(left: rest, right: [x, ..tape.right])
  }
}

pub fn plus(tape: Tape) -> Tape {
  case tape.right {
    [] -> panic as "Trying to plus too far on the right."
    [x, ..rest] -> Tape(left: tape.left, right: [x + 1, ..rest])
  }
}

pub fn minus(tape: Tape) -> Tape {
  case tape.right {
    [] -> panic as "Trying to minus too far on the right."
    [x, ..rest] -> Tape(left: tape.left, right: [x - 1, ..rest])
  }
}
