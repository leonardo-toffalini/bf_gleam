import argv
import gleam/io
import gleam/string
import interpreter

pub fn main() {
  case argv.load().arguments {
    ["file", file] -> {
      io.println("filepath: " <> file)
      file |> string.trim |> interpreter.run
    }
    _ -> {
      io.println("Usage: \n\t`gleam run file <filename>`")
      Error("Unexpected cli call.")
    }
  }
  // let filepath = "examples/hello_world.bf"
}
