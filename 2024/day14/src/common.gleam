import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub type Position {
  Position(x: Int, y: Int)
}

pub type Robot {
  Robot(position: Position, velocity: Position)
}

/// Takes in a robot, tile width and height, returns a robot with an updated
/// position 
pub fn step(robot: Robot, tile_width: Int, tile_height: Int) -> Robot {
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

/// Parses an input string separated by \n, and returns a List of all the robots
pub fn parse(input: String) -> List(Robot) {
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

/// Given a list of robots, tile floor width and height, it prints it like the diagrams shown in examples
pub fn print_robots(
  input: List(Robot),
  tile_width: Int,
  tile_height: Int,
) -> List(Robot) {
  print_robots_loop(input, tile_width, tile_height, 0, 0, "")
  input
}

fn print_robots_loop(
  input: List(Robot),
  tile_width: Int,
  tile_height: Int,
  x: Int,
  y: Int,
  final: String,
) {
  let check = fn(accumulator: Int, r: Robot) -> Int {
    case r.position {
      Position(cur_x, cur_y) if cur_x == x && cur_y == y -> accumulator + 1
      _ -> accumulator
    }
  }

  case x, y {
    x, _ if x == tile_width -> {
      print_robots_loop(
        input,
        tile_width,
        tile_height,
        0,
        y + 1,
        string.append(final, "\n"),
      )
    }
    _, y if y == tile_height -> {
      // let assert Ok(esc) = string.utf_codepoint(27)
      //
      // string.from_utf_codepoints([esc])
      // |> string.append("[2J")
      // |> io.println
      io.println(final)
      // process.sleep(100)
    }

    _, _ -> {
      let num = list.fold(input, 0, check)
      case num == 0 {
        True ->
          print_robots_loop(
            input,
            tile_width,
            tile_height,
            x + 1,
            y,
            string.append(final, "."),
          )
        False ->
          print_robots_loop(
            input,
            tile_width,
            tile_height,
            x + 1,
            y,
            string.append(final, int.to_string(num)),
          )
      }
    }
  }
}

/// Turns a list of robots into a dict of robots
pub fn bots_to_dict_count(
  input: List(Robot),
) -> dict.Dict(Position, List(Position)) {
  bots_to_dict_count_loop(input, dict.new())
}

fn bots_to_dict_count_loop(
  input: List(Robot),
  final: dict.Dict(Position, List(Position)),
) -> dict.Dict(Position, List(Position)) {
  case input {
    [first, ..rest] -> {
      case dict.get(final, first.position) {
        Ok(val) ->
          bots_to_dict_count_loop(
            rest,
            final
              |> dict.insert(first.position, list.append(val, [first.velocity])),
          )
        Error(_) ->
          bots_to_dict_count_loop(
            rest,
            final |> dict.insert(first.position, [first.velocity]),
          )
      }
    }
    _ -> final
  }
}
