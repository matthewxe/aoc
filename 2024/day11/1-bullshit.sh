#!/usr/bin/env bash

FILE=$1

read -a arr <"$FILE"

i=0
max=$2
size=${#arr[@]}

echo ${arr[@]}

apply_rules() {
        j=0
        local -a new_arr
        while [ $j -lt ${#arr[@]}]; do
                item=${arr[j]}
                rock_len=${#item}
                if ((item == 0)); then
                        new_arr+="1"
                elif ((rock_len % 2 == 0)); then
                        ## loop
                        # rock_len_half=$((rock_len / 2))
                        # arr+=(${arr[-1]})
                        # for ((k = size; k > j; k--)); do
                        #         arr[k]=${arr[((k - 1))]}
                        # done
                        # arr[j]=${arr[j]:0:rock_len_half}
                        # val=${arr[j + 1]:rock_len_half}
                        # val=${val#0}
                        # arr[j + 1]=${val-0}

                        ((half = digits / 2))
                        left=${item:0:$half}
                        [[ "$left" =~ ([1-9].*) ]]
                        left=${BASH_REMATCH[1]}
                        left=${left:-0}
                        right=${item:$half}
                        [[ "$right" =~ ([1-9].*) ]]
                        right=${BASH_REMATCH[1]}
                        right=${right:-0}
                        new_arr+=("$left" "$right")

                        ## matching and shi
                        # ((rock_len_half = rock_len / 2))
                        # middle_right=${arr[j]:rock_len_half}
                        # middle_right=${middle_right#0}
                        # middle_right=${middle_right:-0}
                        # arr=(${arr[@]:0:j} ${arr[j]:0:rock_len_half} $middle_right ${arr[@]:((j + 1)):size})
                        # ((size++))
                        # ((j++))
                else
                        new_arr+=($((arr[j] * 2024)))
                fi

                ((j++))
        done
        arr=("${new_arr[@]}")
}

while [ $i -lt $max ]; do
        echo "Current: $((i + 1)) Stones: $size"
        # echo "$((i + 1)): ${arr[@]}"
        apply_rules
        ((i++))
done

echo "----"
echo "len: ${#arr[@]}"
