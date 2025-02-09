import sys

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

    index = 0
    pointer = 0

    while pointer < instructions_len:
        opcode = instructions[pointer]
        operand = instructions[pointer + 1]
        match opcode:
            case 0:
                # adv
                combo = to_combo(operand)
                a = int(a / (2**combo))
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
                # halt_set.add((a, b, c, pointer, tuple(out)))
            case 6:
                # bdv
                combo = to_combo(operand)
                b = int(a / 2**combo)
            case 7:
                # cdv
                combo = to_combo(operand)
                c = int(a / 2**combo)
        pointer += 2
    return True


file = stream.readlines()
b = int(file[1][12:])
c = int(file[2][12:])
instructions = list(map(int, file[4][9:].split(',')))

i = 0
halt_set = set()
while not simulate(i, b, c, instructions, halt_set):
    i += 1
    # print(i)
    # print(sys.maxsize - i)

print(i)
# print(halt_set)
