if ARGV.size != 1
        STDERR.puts "crystal 1.cr [filename]"
        STDERR.puts "Incorrect argument count"
        exit(1)
end

begin
        file = File.new(ARGV[0])
        input = file.gets_to_end
        puts input
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
                                puts "type: #{@input[i][j]} sides: #{out[0]} area: #{out[1]}"
                        end
                end

                return total
        end

        def outside(x : Int, y : Int) : Bool
                return x < 0 || x >= @@x_max || y < 0 || y >= @@y_max 
        end

        def plot(x : Int, y : Int, prev_x : Int, prev_y : Int) : {Int32, Int32}
                sides = 0
                area = 0

                if outside(x, y) || @input[prev_y][prev_x] != @input[y][x] || @plotted[y][x] == true
                        return {0, 0}
                        return {0, 0}
                else
                        area += 1
                end
                
                sides += corner_check(x, y)

                @plotted[y][x] = true

                shit = [[0, 1], [0, -1], [1, 0], [-1, 0]]
                shit.each do |shit2|
                        x_next = x + shit2[0]
                        y_next = y + shit2[1]

                        next if x_next == prev_x && y_next == prev_y

                        shit3 = plot(x + shit2[0], y + shit2[1], x, y)
                        sides += shit3[0]
                        area += shit3[1]

                end
                # puts "x: #{x}, y: #{y}, sides: #{sides}, area: #{area}"
                return {sides, area}
        end

        def corner_check(x : Int, y : Int) : Int
                corners = 0
                base = @input[y][x]
                corner_pos = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
                corner_pos.each do |corner|
                        x_next = x + corner[0]
                        y_next = y + corner[1]

                        # A represents equality of x_next_input with base
                        # B represents equality of y_next_input with base
                        # C represents if x_next is outside
                        # D represents if y_next is outside
                        # E represents equality of x_y_next_input with base
                        # outie = (C | ~A) & (D | ~B)
                        # innie = ! (C || D) (A & B & !E)
                        # AA
                        # BA
                        out_x = outside(x_next, y)
                        out_y = outside(x, y_next)
                        outie = (out_x || base != @input[y][x_next]) && (out_y || base != @input[y_next][x])
                        innie = !(out_x || out_y) && (base == @input[y][x_next] && base == @input[y_next][x] && base != @input[y_next][x_next])

                        if outie || innie
                                puts "x: #{x} y: #{y}, x_next: #{x_next} y_next: #{y_next}"
                                corners += 1
                        end
                end
                return corners
        end
end
# vim:commentstring=#%s:
