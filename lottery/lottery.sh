#!/bin/bash
# Lotomängu peamine käivitusskript

# Määrame skripti asukohakataloogi, et moodulite laadimine töötaks igalt poolt
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Laadime funktsioonid teistest failidest
source "$SCRIPT_DIR/files.sh"
source "$SCRIPT_DIR/input.sh"
source "$SCRIPT_DIR/lottery_functions.sh"
source "$SCRIPT_DIR/result.sh"

show_header() {
    echo "========================================"
    echo "            LOTOMÄNG 1-50               "
    echo "========================================"
    echo ""
}

main() {
    local player_file="player_numbers.txt"
    local lottery_file="lottery_numbers.txt"
    local results_file="results.txt"

    show_header
    clear_files "$player_file" "$lottery_file"

    local player_name
    player_name=$(read_player)
    echo "Tere, $player_name! Valime 5 erinevat numbrit vahemikust 1–50."
    echo ""

    read_player_numbers "$player_file"
    show_player_numbers "$player_file"

    generate_lottery_numbers "$lottery_file"
    show_lottery_numbers "$lottery_file"

    local matches
    matches=$(check_matches "$player_file" "$lottery_file")

    local eval_text
    eval_text=$(get_evaluation "$matches")

    show_result "$player_name" "$matches" "$eval_text"
    save_result "$player_name" "$player_file" "$lottery_file" "$matches" "$eval_text" "$results_file"
}

main
