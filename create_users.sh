#!/bin/bash

#Kontrollera om användaren är root
if [[ $EUID -ne 0 ]]; then
echo "Detta script måste köras som root!" >&2
exit 1
fi

#Kontrollera att minst ett argument finns
if [[ $# -eq 0 ]]; then
echo "Användning: $0 användarnamn1 användarnamn2 …"
echo "Exempel: $0 Anna Bjorn Charlie"
exit 1
fi

#Loop genom alla användarnamn
for username in "$@"; do
echo "skapar användare: $username"

#Skapa Användaren
useradd -m -s /bin/bash "$username"

if [[ $? -ne 0 ]]; then
echo "Fel: Kunde inte skapa $username"
continue
fi

home_dir="/home/$username"

#skapa mappar
mkdir -p "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

#Sätt rätt ägare
chown -R "$username:$username" "$home_dir"

#Sätt rättigheter (endast ägaren)
chmod 700 "$home_dir/Documents" "$home_dir/Downloads" "$home_dir/Work"

echo "Mappar skapade för $username"

welcome_file="$home_dir/welcome.txt"

#Skapa välkomstfil
echo "Välkommen $username" > "$welcome_file"
echo "Andra användare på systemet:" >> "$welcome_file"

echo "Alla användare:" >> "$welcome_file"
getent passwd | cut -d: -f1 | grep -v "^$username$" >> "$welcome_file"

done
