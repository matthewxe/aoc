package main

import "core:fmt"
import "core:os"
import "core:strings"

Coordinates :: struct {
	x: int,
	y: int,
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
				out, ok := antennas[chr]
				if !ok {
					antennas[chr] = make([dynamic]Coordinates, 1)
					antennas[chr][0].y = i
					antennas[chr][0].x = j
				}

				for cords in out {
					vertical_difference := i - cords.y
					horizontal_difference := j - cords.x
					y1 := i + vertical_difference
					x1 := j + horizontal_difference

					y2 := cords.y - vertical_difference
					x2 := cords.x - horizontal_difference

					if !(y1 < 0 || y1 >= grid_size) &&
					   !(x1 < 0 || x1 >= grid_size) &&
					   placed[y1][x1] != true {
						final += 1
						placed[y1][x1] = true
					}
					if !(y2 < 0 || y2 >= grid_size) &&
					   !(x2 < 0 || x2 >= grid_size) &&
					   placed[y2][x2] != true {
						final += 1
						placed[y2][x2] = true
					}

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
