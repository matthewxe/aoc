import argv
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  case argv.load().arguments {
    [filename] -> {
      let input = simplifile.read(filename)
      case input {
        Ok(text) ->
          calculate(text, 100, 101, 103) |> int.to_string |> io.println
        Error(_error) ->
          io.println_error("error: wrong filename\nUsage: ./part1 <filename>")
      }
    }
    _ -> io.println("error: wrong argument count\nUsage: ./part1 <filename>")
  }
}

type Position {
  Position(x: Int, y: Int)
}

type Robot {
  Robot(position: Position, velocity: Position)
}

/// Calculate the safety factor from a \n separated string of the input
fn calculate(
  input: String,
  seconds: Int,
  tile_width: Int,
  tile_height: Int,
) -> Int {
  parse(input)
  |> simulate(seconds, tile_width, tile_height)
  |> count_quadrants(tile_width, tile_height)
}

fn count_quadrants(input: List(Robot), tile_width: Int, tile_height: Int) -> Int {
  count_quadrants_loop(input, 0, 0, 0, 0, tile_width, tile_height)
}

fn count_quadrants_loop(
  input: List(Robot),
  tl: Int,
  tr: Int,
  bl: Int,
  br: Int,
  tile_width: Int,
  tile_height: Int,
) -> Int {
  case input {
    [first, ..rest] -> {
      let tl = case first {
        Robot(pos, _) if pos.x < tile_width / 2 && pos.y < tile_height / 2 ->
          tl + 1
        _ -> tl
      }
      let tr = case first {
        Robot(pos, _) if pos.x > tile_width / 2 && pos.y < tile_height / 2 ->
          tr + 1
        _ -> tr
      }
      let bl = case first {
        Robot(pos, _) if pos.x < tile_width / 2 && pos.y > tile_height / 2 ->
          bl + 1
        _ -> bl
      }
      let br = case first {
        Robot(pos, _) if pos.x > tile_width / 2 && pos.y > tile_height / 2 ->
          br + 1
        _ -> br
      }
      count_quadrants_loop(rest, tl, tr, bl, br, tile_width, tile_height)
    }
    _ -> tl * tr * bl * br
  }
}

fn simulate(
  input: List(Robot),
  seconds: Int,
  tile_width: Int,
  tile_height: Int,
) -> List(Robot) {
  case seconds > 0 {
    True ->
      simulate(
        list.map(input, step(_, tile_width, tile_height)),
        seconds - 1,
        tile_width,
        tile_height,
      )
    False -> input
  }
}

// Advances the robot
fn step(robot: Robot, tile_width: Int, tile_height: Int) -> Robot {
  let new_x = case robot.position.x + robot.velocity.x {
    new_x if new_x >= tile_width -> new_x - tile_width
    new_x if new_x < 0 -> tile_width + new_x
    new_x -> new_x
  }
  let new_y = case robot.position.y + robot.velocity.y {
    new_y if new_y >= tile_height -> new_y - tile_height
    new_y if new_y < 0 -> tile_height + new_y
    new_y -> new_y
  }

  Robot(Position(new_x, new_y), Position(robot.velocity.x, robot.velocity.y))
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
      parse_loop(rest, [parse_line(first), ..list])
    }
    _ -> list
  }
}

fn parse_line(input: String) -> Robot {
  let assert [left, right] = string.split(input, " ")
  let strip = fn(str) { string.split(string.drop_start(str, 2), ",") }
  let assert [left_x, left_y] = strip(left)
  let assert [right_x, right_y] = strip(right)

  Robot(
    position: Position(x: string_to_int(left_x), y: string_to_int(left_y)),
    velocity: Position(x: string_to_int(right_x), y: string_to_int(right_y)),
  )
}

// Simple conversion from string to integer, doesn't know what to do with floats
pub fn string_to_int(str: String) -> Int {
  case str {
    "-" <> num -> -1 * atoi(num)
    num -> atoi(num)
  }
}

fn atoi(str: String) -> Int {
  atoi_loop(string.to_utf_codepoints(str), 0, string.length(str) - 1)
}

fn atoi_loop(points: List(UtfCodepoint), num: Int, digits: Int) -> Int {
  case points {
    [first, ..rest] ->
      atoi_loop(
        rest,
        num
          + {
          { string.utf_codepoint_to_int(first) - 48 } * { power(10, digits) }
        },
        digits - 1,
      )
    _ -> num
  }
}

/// A simple power function for integers doing natural number exponents
pub fn power(x: Int, exp: Int) -> Int {
  power_loop(x, exp, 1)
}

fn power_loop(x: Int, exp: Int, accumulator: Int) -> Int {
  case exp > 0 {
    True -> power_loop(x, exp - 1, accumulator * x)
    False -> accumulator
  }
}
