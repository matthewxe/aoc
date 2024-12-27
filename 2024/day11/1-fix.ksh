str=$(cat $1)

set -A arr $str
# set -a arr $str

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
                        # echo "before: ${arr[@]}"
                        rock_len_half=$((rock_len / 2))
                        arr+=(${arr[-1]})
                        k=$size
                        while [[ $k -gt $j ]]; do
                                arr[k]=${arr[((k - 1))]}
                                ((k--))
                        done
                        arr[j]=${arr[j]:0:rock_len_half}
                        val=${arr[j + 1]:rock_len_half}
                        val=${val#0}
                        arr[j + 1]=${val-0}

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
