#!/usr/bin/env bash

FILE=$1

read -a arr <"$FILE"

i=0
max=$2
size=${#arr[@]}

echo ${arr[@]}

while [ $i -lt $max ]; do
        echo "Current: $((i + 1)) Stones: $size"
        j=0
        while [ $j -lt $size ]; do
                rock_len=${#arr[j]}
                if ((arr[j] == 0)); then
                        arr[j]="1"
                elif ((rock_len % 2 == 0)); then
                        ## loop
                        rock_len_half=$((rock_len / 2))
                        arr+=(${arr[-1]})
                        for ((k = size; k > j; k--)); do
                                arr[k]=${arr[((k - 1))]}
                        done
                        arr[j]=${arr[j]:0:rock_len_half}
                        val=${arr[j + 1]:rock_len_half}
                        val=${val#0}
                        arr[j + 1]=${val-0}

                        ## matching and shi
                        # ((rock_len_half = rock_len / 2))
                        # middle_right=${arr[j]:rock_len_half}
                        # middle_right=${middle_right#0}
                        # middle_right=${middle_right:-0}
                        # arr=(${arr[@]:0:j} ${arr[j]:0:rock_len_half} $middle_right ${arr[@]:((j + 1)):size})
                        ((size++))
                        ((j++))
                else
                        ((arr[j] *= 2024))
                fi

                ((j++))
        done
        # echo "$((i + 1)): ${arr[@]}"
        ((i++))
done

echo "----"
echo "len: $size"
