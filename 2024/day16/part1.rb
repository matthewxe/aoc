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

Coordinates = Struct.new(:x, :y)

# class Reindeer
#
#   def initialize(x, y, map)
#   end
#
#   def add_unvisited
#     move = @@move_coords
#     (1..4).each do |_|
#       space = get_relative_space(move.x, move.y)
#
#       if space != "#"
#         @@unvisited << Coordinates.new(@coords.x + move.x, @coords.y + move.y)
#       end
#
#       move.y *= -1
#       move.x, move.y = move.y, move.x
#     end
#   end
#
#   def unvisited
#     return @@unvisited
#   end
#
#   def get_relative_space(x, y)
#     return @map[@coords.y + y][@coords.x + x]
#   end
#
#   def set(x, y)
#     @coords.x = x
#     @coords.y = x
#   end
#
#   def step
#     if @map[@coords.y + @@move_coords.y][@coords.x + @@move_coords.x] != "#"
#       @coords.y += @@move_coords.y
#       @coords.x += @@move_coords.x
#       @@score += 1
#     else
#       puts("fuck you")
#     end
#   end
#
#   def clocwise
#     @@move_coords.y *= -1
#     @@move_coords.x, @@move_coords.y = @@move_coords.y, @@move_coords.x
#     @@score += 1000
#   end
#
#   def counter_clockwise
#     @@move_coords.x *= -1
#     @@move_coords.x, @@move_coords.y = @@move_coords.y, @@move_coords.x
#     @@score += 1000
#   end
# end

map = file.lines.map do |line|
  line.split("")
end

direction = Coordinates.new(1, 0)
unvisited = []
unvisited_neighbors = Hash.new
node_scores = Hash.new

current = nil
end_tile = nil

map.each_with_index do |line, y|
  line.each_with_index do |block, x|
    coords = Coordinates.new(x, y)
    if block == "S"
      current = coords
    elsif block == "E"
      end_tile = coords
      unvisited << coords
    else
      unvisited << coords
    end
  end
end

node_scores[current] = 0
