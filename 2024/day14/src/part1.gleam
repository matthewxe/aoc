import common
import gleam/list

/// Calculate the safety factor from a \n separated string of the input
pub fn calculate(
  input: String,
  seconds: Int,
  tile_width: Int,
  tile_height: Int,
) -> Int {
  common.parse(input)
  |> simulate(seconds, tile_width, tile_height)
  |> count_quadrants(tile_width, tile_height)
}

fn count_quadrants(
  input: List(common.Robot),
  tile_width: Int,
  tile_height: Int,
) -> Int {
  count_quadrants_loop(input, 0, 0, 0, 0, tile_width, tile_height)
}

fn count_quadrants_loop(
  input: List(common.Robot),
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
        common.Robot(pos, _)
          if pos.x < tile_width / 2 && pos.y < tile_height / 2
        -> tl + 1
        _ -> tl
      }
      let tr = case first {
        common.Robot(pos, _)
          if pos.x > tile_width / 2 && pos.y < tile_height / 2
        -> tr + 1
        _ -> tr
      }
      let bl = case first {
        common.Robot(pos, _)
          if pos.x < tile_width / 2 && pos.y > tile_height / 2
        -> bl + 1
        _ -> bl
      }
      let br = case first {
        common.Robot(pos, _)
          if pos.x > tile_width / 2 && pos.y > tile_height / 2
        -> br + 1
        _ -> br
      }
      count_quadrants_loop(rest, tl, tr, bl, br, tile_width, tile_height)
    }
    _ -> tl * tr * bl * br
  }
}

fn simulate(
  input: List(common.Robot),
  seconds: Int,
  tile_width: Int,
  tile_height: Int,
) -> List(common.Robot) {
  case seconds > 0 {
    True ->
      simulate(
        list.map(input, common.step(_, tile_width, tile_height)),
        seconds - 1,
        tile_width,
        tile_height,
      )
    False -> input
  }
}
