if ARGV.size != 1
        STDERR.puts "crystal 1.cr [filename]"
        STDERR.puts "Incorrect argument count"
        exit(1)
end
puts ARGV[0]

begin
        file = File.new(ARGV[0])
        input = file.gets_to_end
        gartanofbanban = Garden.new input
        puts gartanofbanban.price()
        file.close
rescue ex
        STDERR.puts "crystal 1.cr [filename]"
        STDERR.puts ex.message
end

class Garden
        def initialize(str : String)
                @input = str.split
                @@x_max = @input.size
                @@y_max = @input[0].size
                @plotted = Array(Array(Bool)).new(@@y_max) { Array(Bool).new(@@x_max, false) }
        end
        #@@input : Array(String) = [""]
        @@y_max : Int32 = 0
        @@x_max : Int32 = 0
        @plotted : Array(Array(Bool)) = [[false]]

        def price() : Int
                total = 0
                @@y_max.times do |i|
                        @@x_max.times do |j|
                                if @plotted[i][j] == true
                                        next
                                end
                                out = self.plot(j, i, j, i)
                                total += out[0] * out[1]
                                puts "type: #{@input[i][j]} perimeter: #{out[0]} area: #{out[1]}"
                        end
                end

                return total
        end

        def plot(x : Int, y : Int, prev_x : Int, prev_y : Int) : {Int32, Int32}
                perimeter = 0
                area = 0

                if x < 0 || x >= @@x_max || y < 0 || y >= @@y_max
                        return {1, 0}
                elsif @input[prev_y][prev_x] != @input[y][x]
                        return {1, 0}
                elsif @plotted[y][x] == true
                        return {0, 0}
                else
                        area += 1
                end
                @plotted[y][x] = true

                shit = [[0, 1], [0, -1], [1, 0], [-1, 0]]
                i = 0
                while i < shit.size
                        shit2 = shit[i]
                        x_next = x + shit2[0]
                        y_next = y + shit2[1]

                        if x_next == prev_x && y_next == prev_y
                                i += 1
                                next
                        end
                                shit3 = plot(x + shit2[0], y + shit2[1], x, y)
                                perimeter += shit3[0]
                                area += shit3[1]

                        i += 1
                end
                puts "x: #{x}, y: #{y}, perimeter: #{perimeter}, area: #{area}"
                return {perimeter, area}
        end
end

# vim:commentstring=#%s:
