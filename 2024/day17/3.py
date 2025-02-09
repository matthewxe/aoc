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


def simulate(a, b, c, instructions, instructions_len, halt_set):
    def to_combo(x):
        match x:
            case 4:
                return a
            case 5:
                return b
            case 6:
                return c
            case 7:
                raise 'balls'
            case _:
                return x

    halts = set()
    idx = 0
    pointer = 0

    while pointer < instructions_len:
        halts.add((a, b, c, pointer, idx))
        if idx > instructions_len or (a, b, c, pointer, idx) in halt_set:
            halt_set.update(halts)
            return False

        opcode = instructions[pointer]
        operand = instructions[pointer + 1]
        match opcode:
            case 0:
                combo = to_combo(operand)
                a = trunc(a / (2**combo))
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
                    halt_set.update(halts)
                    return False
                idx += 1
            case 6:
                b = trunc(a / (2 ** to_combo(operand)))
            case 7:
                combo = to_combo(operand)
                c = trunc(a / (2 ** to_combo(operand)))
        pointer += 2

    halt_set.update(halts)
    return idx == instructions_len


file = stream.readlines()
b = int(file[1][12:])
c = int(file[2][12:])
instructions = list(map(int, file[4][9:].split(',')))

i = 0
halt_set = set()
instructions_len = len(instructions)
while not simulate(i, b, c, instructions, instructions_len, halt_set):
    i += 1
    # print(i)

print(i)
# print(len(halt_set))
