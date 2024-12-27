#!/usr/bin/env bash

# extra
if (($# != 2)); then
        echo "./2.sh [filename] [blinks]"
        echo "Error: incorrect amount of arguments"
        exit 1
fi

if ! test -f $1; then
        echo "./2.sh [filename] [blinks]"
        echo "Error: filename not found"
        exit 2
fi

if ! [[ $2 =~ ^[0-9]+$ ]]; then
        echo "./2.sh [filename] [blinks]"
        echo "Error: blinks is not a number"
        exit 3
fi

read -a arr <$1

max=$2
echo ${arr[@]}
declare -A map

# Initialize
for stone in ${arr[@]}; do
        ((map[${stone}] += 1))
done

apply() {
        declare -A new_map=$map

        for stone in ${!map[@]}; do
                stone_len=${#stone}
                n=${map[$stone]}
                if ((stone == 0)); then
                        ((new_map[1] += n))
                        unset new_map[$stone]
                elif ((stone_len % 2 == 0)); then
                        ((stone_len_half = stone_len / 2))
                        ((new_map[$((10#${stone:0:stone_len_half}))] += n))
                        ((new_map[$((10#${stone:stone_len_half}))] += n))
                else
                        ((new_map[$((stone * 2024))] += n))
                fi
        done

        local i
        unset map
        for i in "${!new_map[@]}"; do
                map[$i]="${new_map[$i]}"
        done
        unset i
}

print_stones() {
        local i
        for i in "${!map[@]}"; do
                echo "${i}: ${map[$i]}"
        done
}

len() {
        local count=0
        for val in ${map[@]}; do
                ((count += val))
        done
        echo $count
}

for ((i = 0; i < max; i++)); do
        echo "Current: $((i + 1)) Stones: $(len)"
        # print_stones
        apply
done

echo "----"
# print_stones
echo "len: $(len)"
