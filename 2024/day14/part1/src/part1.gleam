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

type Position {
  Position(x: Int, y: Int)
}

type Robot {
  Robot(position: Position, velocity: Position)
}

fn calculate(input: String) -> Int {
  parse(input) |> list.length()
}

fn parse(input: String) -> List(Robot) {
  // Drops the final \n so it doesnt create an empty list
  string.drop_end(input, 1)
  |> string.split("\n")
  |> parse_loop([])
}

fn parse_loop(input: List(String), list: List(Robot)) -> List(Robot) {
  case input {
    [first, ..rest] -> {
      let assert Ok(robot) = parse_text(first)
      parse_loop(rest, [robot, ..list])
    }
    _ -> list
  }
}

type InputError {
  InputError
}

fn parse_text(input: String) -> Result(Robot, InputError) {
  case string.split(input, " ") {
    [left, right] -> {
      let strip = fn(str) { string.split(string.drop_start(str, 2), ",") }
      let r = strip(right)
      let assert Ok(right_l) = list.first(r)
      let assert Ok(right_r) = list.last(r)
      let l = strip(left)
      let assert Ok(left_l) = list.first(l)
      let assert Ok(left_r) = list.last(l)
      io.println(left_l <> left_r <> right_l <> right_r)

      Ok(Robot(
        position: Position(x: to_int(left_l), y: to_int(left_r)),
        velocity: Position(x: to_int(right_l), y: to_int(right_r)),
      ))
    }
    _ -> Error(InputError)
  }
}

fn to_int(str: String) -> Int {
  case str {
    "-" <> num -> -1 * atoi(num)
    num -> atoi(num)
  }
}

fn atoi(str: String) -> Int {
  str |> string.length()
}
