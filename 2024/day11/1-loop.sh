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
                        echo "before: ${arr[@]}"
                        # left=${arr[@]:0:$j}
                        # right=${arr[@]:((j + 1)):size}
                        # middle_left=${arr[j]:0:((${#arr[j]} / 2))}
                        # middle_right=${arr[j]:((${#arr[j]} / 2)):${#arr[j]}}
                        # arr=($left $middle_left $middle_right $right)
                        # echo "left: ${left[@]}"
                        # echo "middle_left: $middle_left"
                        # echo "middle_right: $middle_right"
                        # echo "right: ${right[@]}"

                        # inline version of this

                        tmp=()

                        k=0
                        while [ $k -lt $j ]; do
                                tmp+=(${arr[k]})
                                ((k++))
                        done
                        echo "uno: $tmp"

                        rock_len_half=$((${#arr[j]} / 2))
                        tmp+=(${arr[j]:0:rock_len_half})
                        echo "dos: $tmp"
                        tmp+=(${arr[j]:rock_len_half:rock_len})
                        echo "tres: $tmp"

                        k=$((j + 1))
                        while [ $k -lt $size ]; do
                                tmp+="${arr[k]}"
                                ((k++))
                        done
                        echo "quatro: $tmp"
                        arr=$tmp
                        # arr+=(${arr[@]:0:$j} ${arr[@]:((j + 1)):size})

                        ((size++))
                        ((j++))
                        echo "after: ${arr[@]}"
                else
                        arr[j]=$((arr[j] * 2024))
                fi

                ((j++))
        done
        # echo "$i: ${arr[@]}"
        ((i++))
done

echo "----"
# echo ${arr[@]}
echo "len: $size"
