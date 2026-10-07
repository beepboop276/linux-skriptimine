#!/bin/bash
# Mängija nime ja numbrite sisestamine ning valideerimine

read_player() {
    local p_name
    read -p "Sisesta oma nimi: " p_name
    if [ -z "$p_name" ]; then
        p_name="Unknown"
    fi
    echo "$p_name"
}

read_player_numbers() {
    local p_file="$1"
    local i=1
    local num

    while [ $i -le 5 ]; do
        read -p "Sisesta $i. number (1-50): " num

        # Kontroll 1: tühjus
        if [ -z "$num" ]; then
            echo "Viga: Sisend ei tohi olla tühi!" >&2
            continue
        fi

        # Kontroll 2: täisarv
        if ! [[ "$num" =~ ^-?[0-9]+$ ]]; then
            echo "Viga: Sisestatud väärtus peab olema täisarv!" >&2
            continue
        fi

        # Kontroll 3: vahemik 1-50
        if [ "$num" -lt 1 ] || [ "$num" -gt 50 ]; then
            echo "Viga: Number peab olema vahemikus 1–50!" >&2
            continue
        fi

        # Kontroll 4: duplikaat
        if grep -xq "$num" "$p_file"; then
            echo "Viga: Oled selle numbri juba valinud!" >&2
            continue
        fi

        echo "$num" >> "$p_file"
        i=$((i + 1))
    done
    return 0
}

show_player_numbers() {
    local p_file="$1"
    echo ""
    echo "Sinu valitud numbrid:"
    cat "$p_file"
    echo ""
}
