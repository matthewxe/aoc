import argv
import gleam/int
import gleam/io
import part2
import simplifile

// import part1

pub fn main() {
  // cli(part1.calculate(_, 100, 101, 103))
  cli(part2.calculate(_, 101, 103))
}

pub fn cli(calculator: fn(String) -> Int) {
  case argv.load().arguments {
    [filename] -> {
      let input = simplifile.read(filename)
      case input {
        Ok(text) -> text |> calculator |> int.to_string |> io.println
        Error(_error) ->
          io.println_error("error: wrong filename\nUsage: ./day14 <filename>")
      }
    }
    _ ->
      io.println_error("error: wrong argument count\nUsage: ./day14 <filename>")
  }
}
