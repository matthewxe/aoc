import common
import gleam/dict
import gleam/io
import gleam/list

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
    tile_width,
    tile_height,
  )
}

fn simulate_loop(
  input: List(common.Robot),
  input_orig: dict.Dict(common.Position, List(common.Position)),
  seconds: Int,
  tile_width: Int,
  tile_height: Int,
) -> Int {
  case common.bots_to_dict_count(input) == input_orig {
    True -> {
      common.print_robots(input, tile_width, tile_height)
      common.print_robots(
        list.map(input, common.step(_, tile_width, tile_height)),
        tile_width,
        tile_height,
      )
      io.debug(seconds)
      seconds
    }
    False -> {
      common.print_robots(input, tile_width, tile_height)
      io.debug(seconds)
      // io.debug(common.bots_to_list2(input, tile_width, tile_height))
      simulate_loop(
        list.map(input, common.step(_, tile_width, tile_height)),
        input_orig,
        seconds + 1,
        tile_width,
        tile_height,
      )
    }
  }
}
