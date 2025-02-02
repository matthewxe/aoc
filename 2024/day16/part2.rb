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

class Reindeer
  @@visited = Set.new
  @@direction = Hash.new
  @@queue = Queue.new
  @@score = Hash.new
  def initialize(coords, map)
    @@visited << coords
    @@queue << coords
    @@direction[coords] = Coordinates.new(1, 0)
    @@score[coords] = 0
    @final_score = nil
    @map = map
  end

  def simulate
    while not @@queue.empty?
      self.step
    end
  end

  def step
    current = @@queue.pop
    # puts(current)
    # puts("visited", @@visited)
    # puts("queue", @@queue)
    add_unvisited(current)
    return current
  end

  def add_unvisited(current)
    direction = @@direction[current]
    directions = [
      [direction.x, direction.y, 1],
      [direction.y * -1, direction.x, 1001],
      [direction.y, direction.x * -1, 1001]
    ]

    directions.each do |d|
      space = get_relative_space(current, d[0], d[1])
      ds = Coordinates.new(d[0], d[1])
      coords = Coordinates.new(current.x + ds.x, current.y + ds.y)
      if space != "#" and
          (not @@visited.include?(coords) or
          @@score[current] +
          d[2] < @@score[coords])
        @@visited << coords
        @@queue << coords
        @@direction[coords] = ds
        @@score[coords] = @@score[current] + d[2]
      end

      if space == "E"
        new_final_score = @@score[current] + d[2]
        if @final_score == nil or
            new_final_score < @final_score
          @final_score = new_final_score
        end
      end
    end
  end

  def get_relative_space(current, x, y)
    return @map[current.y + y][current.x + x]
  end

  def final_score
    return @final_score
  end
end

map = file.lines.map do |line|
  line.split("")
end

map.each_with_index do |line, y|
  line.each_with_index do |block, x|
    if block == "S"
      honse = Reindeer.new(Coordinates.new(x, y), map)
      honse.simulate
      puts(honse.final_score)
    end
  end
end
