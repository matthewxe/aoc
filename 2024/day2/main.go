package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/matthewxe/aoc/2024/day2/part2"
)

func main() {
	dat, err := os.ReadFile(os.Args[1])
	if err != nil {
		return
	}
	fmt.Printf("%d\n", checkSafety(strings.Split(string(dat), "\n")))
}
