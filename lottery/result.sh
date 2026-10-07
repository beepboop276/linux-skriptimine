#!/bin/bash
# Kontroll, hinnangu andmine ja ajaloo salvestamine

check_matches() {
    local p_file="$1"
    local l_file="$2"
    local matches=0
    local p_num

    echo "--- TULEMUSTE KONTROLL ---"
    while read -r p_num; do
        echo "Kontrollin numbrit $p_num..."
        if grep -xq "$p_num" "$l_file"; then
            echo "TABAMUS!"
            matches=$((matches + 1))
        else
            echo "Ei tabanud."
        fi
        echo ""
    done < "$p_file"

    echo "$matches"
}

get_evaluation() {
    local matches="$1"
    case $matches in
        5) echo "JACKPOT!" ;;
        4) echo "Väga hea tulemus!" ;;
        3) echo "Hea tulemus." ;;
        2) echo "Kaks tabamust." ;;
        1) echo "Üks tabamus." ;;
        0) echo "Seekord tabamusi ei olnud." ;;
    esac
}

show_result() {
    local p_name="$1"
    local matches="$2"
    local eval_text="$3"

    echo "Mängija: $p_name"
    echo "Tabamusi: $matches / 5"
    echo "Tulemus: $eval_text"
    echo ""
}

save_result() {
    local p_name="$1"
    local p_file="$2"
    local l_file="$3"
    local matches="$4"
    local eval_text="$5"
    local res_file="$6"
    local curr_date
    curr_date=$(date)

    {
        echo "========================================"
        echo "Date: $curr_date"
        echo "Player: $p_name"
        echo "Player numbers:"
        cat "$p_file"
        echo "Lottery numbers:"
        cat "$l_file"
        echo "Matches: $matches"
        echo "Result: $eval_text"
    } >> "$res_file"

    echo "Mängu tulemused on salvestatud faili $res_file."
}
