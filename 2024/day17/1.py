import sys

if len(sys.argv) != 2:
    print('Incorrect argument\nUSAGE: python 1.py <filename>')
    exit(1)

try:
    stream = open(sys.argv[1])
except OSError:
    print('Incorrect argument\nUSAGE: python 1.py <filename>')
    exit(1)

file = stream.readlines()
a = int(file[0][12:])
b = int(file[1][12:])
c = int(file[2][12:])
instructions = file[4][9:].split(',')


pointer = 0


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


out = []

while pointer < len(instructions):
    opcode = int(instructions[pointer])
    operand = int(instructions[pointer + 1])
    match opcode:
        case 0:
            # adv
            combo = to_combo(operand)
            a = int(a / 2**combo)
        case 1:
            # bxl
            b ^= operand
        case 2:
            # bst
            b = to_combo(operand) % 8
        case 3:
            # jnz
            if a != 0:
                pointer = operand
                continue
        case 4:
            # bxc
            b ^= c
        case 5:
            # out
            out.append(to_combo(operand) % 8)
        case 6:
            # bdv
            combo = to_combo(operand)
            b = int(a / 2**combo)
        case 7:
            # cdv
            combo = to_combo(operand)
            c = int(a / 2**combo)
    pointer += 2

print(*out, sep=',')
