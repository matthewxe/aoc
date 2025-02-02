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

Coordinates = Struct.new(:x, :y)

map = file.lines.map do |line|
  line.split("")
end

start_coords = nil
end_coords = nil

map.each_with_index do |line, y|
  line.each_with_index do |block, x|
    if block == "S"
      start_coords = Coordinates.new(x, y)
    elsif block == "E"
      end_coords = Coordinates.new(x, y)
    end
  end
end

Path = Struct.new(:score, :visited)
Vector = Struct.new(:position, :direction)

def simulate(map, exit, current, direction, visited, score)
  possible = []
  lowest_score = nil
  total_visited = Set.new
  visited_score = Hash.new

  stack = []
  stack.push(current, direction, visited, score)

  while not stack.empty?
    current, direction, visited, score = stack.pop(4)

    directions = [
      [direction.x, direction.y, 1],
      [direction.y * -1, direction.x, 1001],
      [direction.y, direction.x * -1, 1001]
    ]

    directions.each do |d|
      new_direction = Coordinates.new(d[0], d[1])
      space = map[current.y + new_direction.y][current.x + new_direction.x]
      coords = Coordinates.new(current.x + new_direction.x, current.y + new_direction.y)

      if space == "E"
        if lowest_score == nil or
            score +
            d[2] <= lowest_score
          possible += [Path.new(score + d[2], visited)]
          lowest_score = score + d[2]
          puts(lowest_score)
        end
      elsif space != "#" and
          (lowest_score == nil or
            score +
            d[2] <= lowest_score) and
          not visited.include?(coords) and
          (not total_visited.include?(Vector.new(coords, new_direction)) or
            visited_score[Vector.new(coords, new_direction)] >= score +
              d[2])
        stack.push(coords, new_direction, visited | [coords], score + d[2])
        vector = Vector.new(coords, new_direction)
        total_visited << vector
        visited_score[vector] = score + d[2]
      end
    end
  end

  return possible
end

possible = simulate(map, end_coords, start_coords, Coordinates.new(1, 0), Set[start_coords, end_coords], 0)

min = possible.min { |a, b| a.score <=> b.score }.score
final = Set.new
possible = possible
  .select { |path| min == path.score }
  .map { |path| final += path.visited }

puts(min)
puts(final.length)
