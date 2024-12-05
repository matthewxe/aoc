args <- commandArgs(trailingOnly = TRUE)

input <- read.table(args[1], sep = "\n")


horizontal_check <- function(input, y, reversed) {

        if (reversed) {
                check <- "SAMX"
        }
        else {
                check <- "XMAS"
        }
        
        if (grepl(check, input[y, ])) {
                return (1)
        } else {
                return (0)
        }
}

multi_row_check <- function(input, x, y, mode = "vertical", reversed = FALSE) {
        # print(sprintf("start! %i %i, mode: %s, reversed: %s", x, y, mode, reversed))
        range <- seq(0, 3)
        check <- "XMAS"
        if (reversed) {
                # print("reversed!")
                range <- rev(range)
        }

        # print(range)
        compare <- ""
        for (i in range) {
                if (mode == "vertical") {
                        letter <- substr(input[y+i, ], x, x)
                } else if (mode == "diagonal") {
                        letter <- substr(input[y+i, ], x+i, x+i)
                } else if (mode == "left_diagonal") {
                        letter <- substr(input[y+i, ], x-i, x-i)
                } else {
                        stop("invalid mode. valid options: [\"vertical\", \"diagonal\", \"left_diagonal\"]")
                }
                if (is.na(letter)) {
                        return (0)
                }
                compare <- paste(compare, letter, sep= "")
        }
        # print("compare:")
        # print(compare)
        # print("check:")
        # print(check)
        if (compare == check) {
                # print("correct!")
                return (1)
        } else {
                # print("wrongk!")
                return (0)
        }
}
total <- 0

i <- 1
while (i <= nrow(input)) {
        j <- 1
        row <- input[i, ]

        total <- total + horizontal_check(input, i, FALSE)
        total <- total + horizontal_check(input, i, TRUE)
        while (j <= nchar(row)) {
                        total <- total + multi_row_check(input, j, i, "vertical")
                        total <- total + multi_row_check(input, j, i, "vertical", TRUE)
                        total <- total + multi_row_check(input, j, i, "diagonal")
                        total <- total + multi_row_check(input, j, i, "diagonal", TRUE)
                        total <- total + multi_row_check(input, j, i, "left_diagonal")
                        total <- total + multi_row_check(input, j, i, "left_diagonal", TRUE)
                j <- j + 1
        }
        i <- i + 1
}

total
