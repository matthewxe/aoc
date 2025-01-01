import argv
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  case argv.load().arguments {
    [filename] -> read(filename)
    _ -> io.println("error: wrong argument count\nUsage: ./part1 <filename>")
  }
}

fn read(filename: String) -> Nil {
  let input = simplifile.read(filename)
  case input {
    Ok(text) -> io.println(int.to_string(calculate(text)))
    Error(_error) ->
      io.println_error("error: wrong filename\nUsage: ./part1 <filename>")
  }
}

fn calculate(filename: String) -> Int {
  let input = string.split(filename, "\n")
  list.length(input)
}
