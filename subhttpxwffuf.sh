#!/bin/bash

target=$(echo "$1" | sed -e 's/\(\(http\|https\):\/\/\)//g' -e 's/\///g')
wordlist=$2

mkdir -p "$target"

echo "[i] Buscando subdomínios válidos em $target..."
subfinder -d "$target" 2> /dev/null | httpx 2> /dev/null 1> "$target/$target.lst" 
found=$(wc -l < "$target/$target.lst")
echo "[+] $found subdomínios encontrados."

count=1
for subdomain in $(cat "$target/$target.lst"); do
    echo "$subdomain" > "$target/$count.txt"
    ffuf -w "$wordlist" -u "$subdomain/FUZZ" >> "$target/$count.txt"
    count=$(($count+1))
done
