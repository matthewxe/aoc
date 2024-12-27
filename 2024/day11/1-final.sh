#!/usr/bin/env bash

read -a arr <$1

i=0
max=$2
size=${#arr[@]}

echo ${arr[@]}

while [ $i -lt $max ]; do
        echo "Current: $((i + 1)) Stones: $size"
        j=0
        new_arr=()
        while [ $j -lt $size ]; do
                rock=${arr[j]}
                rock_len=${#rock}
                if ((rock == 0)); then
                        new_arr+=(1)
                elif ((rock_len % 2 == 0)); then
                        rock_len_half=$((rock_len / 2))
                        new_arr=(${rock:0:rock_len_half})
                        val=${arr[j + 1]:rock_len_half}
                        val=${val#0}
                        new_arr+=(${val-0})
                        ((j++))
                        ((size++))
                else
                        ((rock *= 2024))
                        new_arr+=($rock)
                fi
                ((j++))
        done
        arr=("${new_arr[@]}")
        echo "$i: ${arr[@]}"
        ((i++))
done

echo "----"
echo "len: $size"
