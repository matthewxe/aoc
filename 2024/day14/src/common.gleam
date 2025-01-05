import gleam/string

pub type Position {
  Position(x: Int, y: Int)
}

pub type Robot {
  Robot(position: Position, velocity: Position)
}

// Advances the robot
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
