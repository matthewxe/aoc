#!/usr/bin/env bash

str=$(cat $1)

readarray -d " " -t arr <<<$str

i=0
max=$2
size=${#arr[@]}

echo ${arr[@]}

while [ $i -lt $max ]; do
        echo "Current: $((i + 1))"
        j=0
        while [ $j -lt $size ]; do
                arr[j]=$((10#${arr[j]}))

                rock_len=${#arr[j]}
                if [ ${arr[j]} = 0 ]; then
                        arr[j]="1"
                elif ((rock_len % 2 == 0)); then
                        # echo "before: ${arr[@]}"
                        rock_len_half=$((rock_len / 2))
                        arr+=(${arr[-1]})
                        for ((k = size; k > j; k--)); do
                                arr[k]=${arr[((k - 1))]}
                        done
                        arr[j]=${arr[j]:0:rock_len_half}
                        arr[j + 1]=${arr[j + 1]:rock_len_half:rock_len}

                        ((size++))
                        ((j++))
                        # echo "after: ${arr[@]}"
                else
                        arr[j]=$((arr[j] * 2024))
                fi

                ((j++))
        done
        # echo "$i: ${arr[@]}"
        ((i++))
done

echo "----"
echo "len: $size"
