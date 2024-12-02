package part1

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	dat, err := os.ReadFile(os.Args[1])
	if err != nil {
		return
	}
	fmt.Printf("%d\n", checkSafety(strings.Split(string(dat), "\n")))
}

func checkSafety(reports []string) int {
	safety_level := 0

	for _, v := range reports {
		if checkReport(strings.Split(v, " ")) == true {
			safety_level++
		}
	}

	return safety_level
}

func checkReport(codes []string) bool {
	previous_report := 0
	previous_previous_report := 0

	for _, v := range codes {
		report, err := strconv.Atoi(v)
		if err != nil {
			return false
		}
		if previous_report == 0 {
			previous_report = report
			continue
		}
		if previous_previous_report == 0 {
			previous_previous_report = previous_report
			previous_report = report
			continue
		}
		fmt.Printf(
			"previous_previous %d previous %d current %d\n",
			previous_previous_report,
			previous_report,
			report,
		)

		previous_safetiness := previous_previous_report - previous_report
		safetiness := previous_report - report
		if abs(previous_safetiness) < 1 || abs(previous_safetiness) > 3 || abs(safetiness) < 1 ||
			abs(safetiness) > 3 ||
			!sameSignCheck(previous_safetiness, safetiness) {
			// fmt.Println("became notsafe!")
			return false
		}

		previous_previous_report = previous_report
		previous_report = report
	}
	return true
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func sameSignCheck(x int, y int) bool {
	if (x < 0 && y < 0) || (x > 0 && y > 0) {
		return true
	}
	return false
}
