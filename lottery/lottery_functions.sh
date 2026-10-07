#!/bin/bash
# Võidunumbrite genereerimine ja kuvamine

generate_lottery_numbers() {
    local l_file="$1"
    local drawn=0
    local rand_num

    echo "Toimub võidunumbrite loosimine..."
    while [ $drawn -lt 5 ]; do
        rand_num=$(( ($RANDOM % 50) + 1 ))

        if ! grep -xq "$rand_num" "$l_file"; then
            echo "$rand_num" >> "$l_file"
            drawn=$((drawn + 1))
        fi
    done
    return 0
}

show_lottery_numbers() {
    local l_file="$1"
    echo "Võidunumbrid on loositud:"
    cat "$l_file"
    echo ""
}
