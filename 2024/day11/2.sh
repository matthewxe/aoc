#!/usr/bin/env bash

read -a arr <$1

i=0
max=$2
echo ${arr[@]}

apply() {
        local -a new_arr
        for stone in "${arr[@]}"; do
                stone=$((10#${stone}))
                stone_len=${#stone}
                if (($stone == 0)); then
                        new_arr+=(1)
                elif ((stone_len % 2 == 0)); then
                        ((stone_len_half = stone_len / 2))
                        new_arr+=(${stone:0:stone_len_half})
                        new_arr+=(${stone:stone_len_half})
                else
                        ((stone *= 2024))
                        new_arr+=($stone)
                fi
        done
        arr=("${new_arr[@]}")
}

for ((i = 0; i < max; i++)); do
        echo "Current: $((i + 1)) Stones: ${#arr[@]}"
        apply
done

echo "----"
echo "len: ${#arr[@]}"
