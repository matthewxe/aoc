import common
import gleam/dict
import gleam/float
import gleam/int
import gleam/list

/// Solves part2 by a given input string separated by \n and tile width and height
pub fn calculate(input: String, tile_width: Int, tile_height: Int) -> Int {
  common.parse(input)
  |> simulate(tile_width, tile_height)
}

fn simulate(input: List(common.Robot), tile_width: Int, tile_height: Int) -> Int {
  // common.print_robots(input, tile_width, tile_height)
  // common.print_robots(
  //   list.map(input, common.step(_, tile_width, tile_height)),
  //   tile_width,
  //   tile_height,
  // )
  // simulate_loop(input, input, 0, tile_width, tile_height)
  simulate_loop(
    list.map(input, common.step(_, tile_width, tile_height)),
    common.bots_to_dict_count(input),
    1,
    0,
    0.0,
    tile_width,
    tile_height,
  )
}

fn simulate_loop(
  input: List(common.Robot),
  input_orig: dict.Dict(common.Position, List(common.Position)),
  seconds: Int,
  minimum_entropy_seconds: Int,
  minimum_entropy: Float,
  tile_width: Int,
  tile_height: Int,
) -> Int {
  case common.bots_to_dict_count(input) == input_orig {
    True -> {
      // common.print_robots(input, tile_width, tile_height)
      // common.print_robots(
      //   list.map(input, common.step(_, tile_width, tile_height)),
      //   tile_width,
      //   tile_height,
      // )
      // io.debug(seconds)
      minimum_entropy_seconds
    }
    False -> {
      case calculate_entropy(input, int.to_float(tile_width * tile_height)) {
        new_entropy if new_entropy >=. minimum_entropy -> {
          // common.print_robots(input, tile_width, tile_height)
          // io.debug(seconds)
          // io.debug(new_entropy)

          simulate_loop(
            list.map(input, common.step(_, tile_width, tile_height)),
            input_orig,
            seconds + 1,
            seconds,
            new_entropy,
            // minimum_entropy,
            tile_width,
            tile_height,
          )
        }
        _ ->
          simulate_loop(
            list.map(input, common.step(_, tile_width, tile_height)),
            input_orig,
            seconds + 1,
            minimum_entropy_seconds,
            minimum_entropy,
            tile_width,
            tile_height,
          )
      }
    }
  }
}

fn calculate_entropy(input: List(common.Robot), max: Float) -> Float {
  let n = int.to_float(dict.size(common.bots_to_dict_count(input)))
  let p_occupied = n /. max
  let p_unoccupied = { max -. n } /. max

  let assert Ok(p_occupied_log) = float.logarithm(p_occupied)
  let assert Ok(p_unoccupied_log) = float.logarithm(p_unoccupied)
  let assert Ok(log2) = float.logarithm(2.0)

  float.negate(
    { p_occupied *. { p_occupied_log /. log2 } }
    +. { p_unoccupied *. { p_unoccupied_log /. log2 } },
  )
}
