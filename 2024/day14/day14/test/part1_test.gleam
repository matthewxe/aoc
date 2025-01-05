import gleeunit
import gleeunit/should
import part1

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn power_test() {
  part1.power(10, 0)
  |> should.equal(1)
  part1.power(10, 1)
  |> should.equal(10)
  part1.power(10, 2)
  |> should.equal(100)
  part1.power(10, 3)
  |> should.equal(1000)
  part1.power(10, 4)
  |> should.equal(10_000)
}

pub fn string_to_int_test() {
  part1.string_to_int("6")
  |> should.equal(6)
}
