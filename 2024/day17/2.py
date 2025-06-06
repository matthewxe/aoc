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


file = stream.readlines()
b = int(file[1][12:])
c = int(file[2][12:])
instructions = list(map(int, file[4][9:].split(',')))
instructions_len = len(instructions)

rev = list(reversed(instructions))
jumps = [i for i, x in enumerate(instructions) if x == 5]


def to_combo(a, b, c, x):
    match x:
        case 4:
            return a
        case 5:
            return b
        case 6:
            return c
        case _:
            return x


def reverse_simulate(idx):
    i = 0

    a = 0
    b = 0
    c = 0

    pointer = idx

    while pointer < instructions_len:
        opcode = instructions[pointer]
        operand = instructions[pointer + 1]
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
                == (to_combo(operand) % 8)
            case 6:
                # bdv
                combo = to_combo(operand)
                b = int(a / 2**combo)
            case 7:
                # cdv
                combo = to_combo(operand)
                c = int(a / 2**combo)
        pointer += 2

    return 0


print(b)

print(max([reverse_simulate(i) for i in jumps]))

# adv 0 COMBO
# A = trunc(A / (2**combo))
# bxl 1 REVERSABLE
# B = B ^ literal
# bst 2 COMBO
# B = combo % 8
# jnz 3 JUMP
# if A != 0:
#     pointer = literal
# continue
# bxc 4 REVERSABLE
# B = B ^ C
# out 5 COMBO
# out = combo % 8
# bdv 6 COMBO
# B = trunc(A / (2**combo))
# cdv 7 COMBO
# C = trunc(A / (2**combo))
