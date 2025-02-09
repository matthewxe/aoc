import sys
from math import trunc

if len(sys.argv) != 2:
    print('Incorrect argument\nUSAGE: python 2.py <filename>')
    exit(1)

try:
    stream = open(sys.argv[1])
except OSError:
    print('Incorrect argument\nUSAGE: python 2.py <filename>')
    exit(1)


def simulate(a, b, c, instructions, instructions_len):
    def to_combo(operand):
        match operand:
            case 4:
                return a
            case 5:
                return b
            case 6:
                return c
        return operand

    idx = 0
    pointer = 0

    while pointer < instructions_len:
        opcode = instructions[pointer]
        operand = instructions[pointer + 1]
        match opcode:
            case 0:
                a = trunc(a / (2 ** to_combo(operand)))
            case 1:
                b ^= operand
            case 2:
                b = to_combo(operand) % 8
            case 3:
                if a != 0:
                    pointer = operand
                    continue
            case 4:
                b ^= c
            case 5:
                out = to_combo(operand) % 8
                if out != instructions[idx]:
                    return False
                idx += 1
                if idx > instructions_len:
                    return False
            case 6:
                b = trunc(a / (2 ** to_combo(operand)))
            case 7:
                c = trunc(a / (2 ** to_combo(operand)))
        pointer += 2

    return idx == instructions_len


file = stream.readlines()
b = int(file[1][12:])
c = int(file[2][12:])
instructions = list(map(int, file[4][9:].split(',')))

i = 0
# i = 10629964
instructions_len = len(instructions)
while not simulate(i, b, c, instructions, instructions_len):
    # print(i)
    i += 1

print(i)
