args <- commandArgs(trailingOnly = TRUE)

input <- read.table(args[1], sep = "\n")

x_check <- function(input, x, y) {
        if ((multi_row_check(input, x, y, mode = "diagonal", FALSE, 'MAS')
        || multi_row_check(input, x, y, mode = "diagonal", TRUE, 'MAS'))
        &&
        (multi_row_check(input, x+2, y, mode = "left_diagonal", FALSE, 'MAS')
        || multi_row_check(input, x+2, y, mode = "left_diagonal", TRUE, 'MAS'))) {
                return (1)
                plot(x+1, y+1)
        } else {
                return (0)
        }
}


multi_row_check <- function(input, x, y, mode = "vertical", reversed = FALSE, check = "XMAS") {
        # print(sprintf("start! %i %i, mode: %s, reversed: %s", x, y, mode, reversed))
        range <- seq(0, nchar(check) - 1)
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
                        return (FALSE)
                }
                compare <- paste(compare, letter, sep= "")
        }
        # print("compare:")
        # print(compare)
        # print("check:")
        # print(check)
        if (compare == check) {
                # print("correct!")
                return (TRUE)
        } else {
                # print("wrongk!")
                return (FALSE)
        }
}
total <- 0

i <- 1
while (i <= nrow(input)) {
        j <- 1
        row <- input[i, ]
        while (j <= nchar(row)) {
                        total <- total + x_check(input, j, i)
                j <- j + 1
        }
        i <- i + 1
}

total
