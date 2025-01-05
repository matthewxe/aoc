import common
import gleam/list

pub fn calculate(input: String, tile_width: Int, tile_height: Int) -> Int {
  common.parse(input)
  |> list.length
  // |> common.simulate(2, tile_width, tile_height)
  // |> common.count_quadrants(tile_width, tile_height)
}
