package main

import "core:fmt"
import "core:os"
import "core:strings"

Coordinates :: struct {
	x: int,
	y: int,
}

// checks if a point is inside the bounds of a grid
check_inside :: proc(grid_size: int, x: int, y: int) -> bool {
	return (0 <= x && x < grid_size) && (0 <= y && y < grid_size)
}

check_continue :: proc(
	x: int,
	y: int,
	x_diff: int,
	y_diff: int,
	grid_size: int,
	placed: [][]bool,
) -> int {
	x_updated := x + x_diff
	y_updated := y + y_diff
	if !check_inside(grid_size, x_updated, y_updated) {
		return 0
	}
	if placed[y_updated][x_updated] != true {
		placed[y_updated][x_updated] = true
		return check_continue(x_updated, y_updated, x_diff, y_diff, grid_size, placed) + 1
	}

	return check_continue(x_updated, y_updated, x_diff, y_diff, grid_size, placed)
}

main :: proc() {
	// Check if it there is a single file argument
	if len(os.args) != 2 {
		return
	}
	// Read file
	data, ok := os.read_entire_file(os.args[1], context.allocator)
	if !ok {
		return
	}
	defer delete(data, context.allocator)
	res, _ := strings.split_lines(string(data))
	input := res[:len(res) - 1]

	// Initialize the 2 dimensional boolean array
	grid_size := len(input)
	// fmt.println(len(input), len(input[0]))
	placed := make([][]bool, grid_size)
	defer delete(placed)
	for i := 0; i < grid_size; i += 1 {
		placed[i] = make([]bool, grid_size)
	}

	antennas := make(map[rune][dynamic]Coordinates)
	defer delete(antennas)

	final := 0
	// Main loop
	for str, i in input {
		for chr, j in str {
			if chr != '.' {
				if placed[i][j] != true {
					final += 1
					placed[i][j] = true
				}

				out, ok := antennas[chr]
				if !ok {
					antennas[chr] = make([dynamic]Coordinates, 1)
					antennas[chr][0].y = i
					antennas[chr][0].x = j
					continue
				}

				for coords in out {
					x_diff := j - coords.x
					y_diff := i - coords.y

					final += check_continue(j, i, x_diff, y_diff, grid_size, placed)
					final += check_continue(
						coords.x,
						coords.y,
						-x_diff,
						-y_diff,
						grid_size,
						placed,
					)
				}
				append(&(antennas[chr]), Coordinates{j, i})
			}
		}
	}
	// fmt.println(antennas)
	fmt.println(final)

	// free memory
	for i := 0; i < grid_size; i += 1 {
		delete(placed[i])
	}
	for key in antennas {
		delete(antennas[key])
	}
}
