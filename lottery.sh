#!/bin/bash
# Modulaarne lotomängu skript - lottery.sh

# Globaalsed muutujad
player_file="player_numbers.txt"
lottery_file="lottery_numbers.txt"
results_file="results.txt"
player_name="Unknown"
matches=0
eval_text=""

show_header() {
    echo "========================================"
    echo "            LOTOMÄNG 1-50               "
    echo "========================================"
    echo ""
}

clear_files() {
    > "$player_file"
    > "$lottery_file"
}

read_player() {
    read -p "Sisesta oma nimi: " input_name
    if [ -n "$input_name" ]; then
        player_name="$input_name"
    fi
    echo "Tere, $player_name! Valime 5 erinevat numbrit vahemikust 1–50."
    echo ""
}

read_player_numbers() {
    local i=1
    while [ $i -le 5 ]; do
        read -p "Sisesta $i. number (1-50): " num

        if [ -z "$num" ]; then
            echo "Viga: Sisend ei tohi olla tühi!"
            continue
        fi

        if ! [[ "$num" =~ ^-?[0-9]+$ ]]; then
            echo "Viga: Sisestatud väärtus peab olema täisarv!"
            continue
        fi

        if [ "$num" -lt 1 ] || [ "$num" -gt 50 ]; then
            echo "Viga: Number peab olema vahemikus 1–50!"
            continue
        fi

        if grep -xq "$num" "$player_file"; then
            echo "Viga: Oled selle numbri juba valinud!"
            continue
        fi

        echo "$num" >> "$player_file"
        i=$((i + 1))
    done
}

show_player_numbers() {
    echo ""
    echo "Sinu valitud numbrid:"
    cat "$player_file"
    echo ""
}

generate_lottery_numbers() {
    echo "Toimub võidunumbrite loosimine..."
    local drawn=0
    while [ $drawn -lt 5 ]; do
        local rand_num=$(( ($RANDOM % 50) + 1 ))

        if ! grep -xq "$rand_num" "$lottery_file"; then
            echo "$rand_num" >> "$lottery_file"
            drawn=$((drawn + 1))
        fi
    done
}

show_lottery_numbers() {
    echo "Võidunumbrid on loositud:"
    cat "$lottery_file"
    echo ""
}

check_matches() {
    echo "--- TULEMUSTE KONTROLL ---"
    matches=0

    while read -r p_num; do
        echo "Kontrollin numbrit $p_num..."
        if grep -xq "$p_num" "$lottery_file"; then
            echo "TABAMUS!"
            matches=$((matches + 1))
        else
            echo "Ei tabanud."
        fi
        echo ""
    done < "$player_file"
}

show_result() {
    echo "Mängija: $player_name"
    echo "Tabamusi: $matches / 5"

    case $matches in
        5) eval_text="JACKPOT!" ;;
        4) eval_text="Väga hea tulemus!" ;;
        3) eval_text="Hea tulemus." ;;
        2) eval_text="Kaks tabamust." ;;
        1) eval_text="Üks tabamus." ;;
        0) eval_text="Seekord tabamusi ei olnud." ;;
    esac

    echo "Tulemus: $eval_text"
    echo ""
}

save_result() {
    local curr_date=$(date)

    {
        echo "========================================"
        echo "Date: $curr_date"
        echo "Player: $player_name"
        echo "Player numbers:"
        cat "$player_file"
        echo "Lottery numbers:"
        cat "$lottery_file"
        echo "Matches: $matches"
        echo "Result: $eval_text"
    } >> "$results_file"

    echo "Mängu tulemused on salvestatud faili $results_file."
}

# Programmi põhiosa execution
main() {
    show_header
    clear_files
    read_player
    read_player_numbers
    show_player_numbers
    generate_lottery_numbers
    show_lottery_numbers
    check_matches
    show_result
    save_result
}

# Käivitame programmi põhiosa
main
