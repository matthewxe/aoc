import common
import gleeunit
import gleeunit/should
import part1
import simplifile

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn power_test() {
  common.power(10, 0)
  |> should.equal(1)
  common.power(10, 1)
  |> should.equal(10)
  common.power(10, 2)
  |> should.equal(100)
  common.power(10, 3)
  |> should.equal(1000)
  common.power(10, 4)
  |> should.equal(10_000)
}

pub fn string_to_int_test() {
  common.string_to_int("6")
  |> should.equal(6)
}

pub fn part1_test() {
  let input = simplifile.read("test/example.txt")
  case input {
    Ok(text) -> part1.calculate(text, 100, 11, 7) |> should.equal(12)
    Error(_error) -> Nil
  }
}
