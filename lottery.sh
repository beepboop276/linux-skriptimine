#!/bin/bash
# Lotomängu simulatsiooni skript - lottery.sh

# 1. Loome või tühjendame ajutised failid
player_file="player_numbers.txt"
lottery_file="lottery_numbers.txt"
results_file="results.txt"

> "$player_file"
> "$lottery_file"

# 2. Küsime mängija nime
read -p "Sisesta oma nimi: " player_name
if [ -z "$player_name" ]; then
    player_name="Unknown"
fi

echo "Tere, $player_name! Valime 5 erinevat numbrit vahemikust 1–50."

# 3. Küsime mängijalt 5 reeglitele vastavat numbrit
i=1
while [ $i -le 5 ]; do
    read -p "Sisesta $i. number (1-50): " num

    # Kontroll 1: kas midagi sisestati?
    if [ -z "$num" ]; then
        echo "Viga: Sisend ei tohi olla tühi!"
        continue
    fi

    # Kontroll 2: kas on täisarv?
    if ! [[ "$num" =~ ^-?[0-9]+$ ]]; then
        echo "Viga: Sisestatud väärtus peab olema täisarv!"
        continue
    fi

    # Kontroll 3: kas on vahemikus 1–50?
    if [ "$num" -lt 1 ] || [ "$num" -gt 50 ]; then
        echo "Viga: Number peab olema vahemikus 1–50!"
        continue
    fi

    # Kontroll 4: kas sama numbrit on juba valitud?
    if grep -xq "$num" "$player_file"; then
        echo "Viga: Oled selle numbri juba valinud!"
        continue
    fi

    # Salvestame korrektse numbri
    echo "$num" >> "$player_file"
    i=$((i + 1))
done

echo ""
echo "Sinu valitud numbrid:"
cat "$player_file"
echo ""

# 4. Loosime 5 erinevat võidunumbrit
echo "Toimub võidunumbrite loosimine..."
drawn=0
while [ $drawn -lt 5 ]; do
    rand_num=$(( ($RANDOM % 50) + 1 ))

    # Kontrollime kordusi
    if ! grep -xq "$rand_num" "$lottery_file"; then
        echo "$rand_num" >> "$lottery_file"
        drawn=$((drawn + 1))
    fi
done

echo "Võidunumbrid on loositud:"
cat "$lottery_file"
echo ""

# 5. Tulemuse kontrollimine
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

# Mängija kokkuvõte
echo "Mängija: $player_name"
echo "Tabamusi: $matches / 5"

# Hinnang vastavalt tabamuste arvule
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

# 6. Tulemuste salvestamine faili results.txt
curr_date=$(date)

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
