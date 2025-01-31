# frozen_string_literal: true

if ARGV.length != 1
  puts("Incorrect file argument\nUsage: ruby part1.rb <filename>")
  exit(1)
end

begin
  file = File.read(ARGV[0])
rescue
  puts("Incorrect file argument\nUsage: ruby part1.rb <filename>")
  exit(2)
end

# puts(file)

class Reindeer
  @@move_x = 1
  @@move_y = 0
  @@score = 0

  def initialize(x, y, map)
    @x = x
    @y = y
    @map = map
  end

  def step
    if @map[@y + @@move_y][@x + @@move_x] != "#"
      @y += @@move_y
      @x += @@move_x
      @@score += 1
    else
      puts("fuck you")
    end
  end

  def clockwise
    @@move_y *= -1
    @@move_x, @@move_y = @@move_y, @@move_x
    @@score += 1000
  end

  def counter_clockwise
    @@move_x *= -1
    @@move_x, @@move_y = @@move_y, @@move_x
    @@score += 1000
  end
end

map = file.lines.map do |line|
  line.split("")
end

honse = nil
map.each_with_index do |line, y|
  line.each_with_index do |block, x|
    if block == "S"
      honse = Reindeer.new(x, y, map)
    end
  end
end

honse.step
honse.step
honse.step
honse.clockwise
honse.clockwise
honse.step
honse.step
honse.step
honse.step
