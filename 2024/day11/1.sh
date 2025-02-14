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

i=0
max=$2
size=${#arr[@]}

echo ${arr[@]}

while [ $i -lt $max ]; do
        echo "Current: $((i + 1)) Stones: $size"
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
                        k=$size
                        while [[ $k -gt $j ]]; do
                                arr[k]=${arr[((k - 1))]}
                                ((k--))
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
