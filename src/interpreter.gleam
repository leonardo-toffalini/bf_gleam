import gleam/io
import gleam/int
import glearray.{type Array}
import token

pub fn interp(tokens: List(token.Token)) -> Nil {
  let arr = new_zero_array(1024)
  do_interp(tokens, 0, arr)
}

fn do_interp(tokens: List(token.Token), index: Int, arr: Array(Int)) -> Nil {
  case tokens {
    [first, ..rest] ->
      case first.token_type {
        token.Increment -> do_interp(rest, index + 1, arr)
        token.Decrement -> do_interp(rest, index - 1, arr)
        token.Plus -> {
          let new_val = case glearray.get(arr, index) {
            Ok(val) -> val + 1
            Error(_) -> panic
          }
          let new_arr = case glearray.copy_set(arr, index, new_val) {
            Ok(arr) -> arr
            Error(_) -> panic
          }
          do_interp(rest, index, new_arr)
        }
        token.Minus -> {
          let new_val = case glearray.get(arr, index) {
            Ok(val) -> val - 1
            Error(_) -> panic
          }
          let new_arr = case glearray.copy_set(arr, index, new_val) {
            Ok(arr) -> arr
            Error(_) -> panic
          }
          do_interp(rest, index, new_arr)
        }
        token.Dot -> {
          let val = case glearray.get(arr, index) {
            Ok(val) -> val
            Error(_) -> panic
          }
          io.print(int.to_string(val))
        }
        token.Comma -> todo
        token.Lbracket -> todo
        token.Rbracket -> todo
      }
    _ -> Nil
  }
}

pub fn new_zero_array(n: Int) -> Array(Int) {
  new_zero_list(n) |> glearray.from_list
}

fn new_zero_list(n: Int) -> List(Int) {
  do_new_zero_list(n, [])
}

fn do_new_zero_list(n: Int, acc: List(Int)) -> List(Int) {
  case n {
    0 -> acc
    m -> do_new_zero_list(m - 1, [0, ..acc])
  }
}
