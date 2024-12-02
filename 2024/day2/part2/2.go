package main

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
			fmt.Println("safe!")
		} else {
			fmt.Println("naugght safer!")
		}
	}

	return safety_level
}

func checkReport(codes []string) bool {
	previous_report := 0
	previous_previous_report := 0
	dampener_status := false

	for i := 0; i < len(codes); i++ {
		report, err := strconv.Atoi(codes[i])
		if err != nil {
			return false
		}
		if previous_report == 0 {
			previous_report = report
			continue
		} else if previous_previous_report == 0 {
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
		if abs(previous_safetiness) < 1 || abs(previous_safetiness) > 3 {
			if dampener_status == true {
				return false
			} else {
				previous_report = report
				fmt.Println("king crimson!!1")
				dampener_status = true
				continue
			}
		} else if abs(safetiness) < 1 || abs(safetiness) > 3 {
			if dampener_status == true {
				return false
			} else {
				fmt.Println("king crimson!!2")
				dampener_status = true
				continue
			}
		} else if !sameSignCheck(previous_safetiness, safetiness) {
			if dampener_status == true {
				return false
			} else {
				fmt.Println("king crimson!!3")
				dampener_status = true
				continue
			}
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
