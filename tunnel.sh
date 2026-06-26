#!/usr/bin/env bash

TARGET_HOST="${1:-c2.example.com}"

if [[ -z "$TARGET_HOST" ]]; then
    echo "[!] Error: Please specify a target host." >&2
    exit 1
fi

echo -e "\e[34m[*] Launching secure TCP proxy to: \e[1;36m${TARGET_HOST}\e[0m"
echo -e "\e[32m[+] Listening locally on 127.0.0.1:40056\e[0m"
echo -e "\e[33m[*] Press Ctrl+C to close the bridge when done.\e[0m"
echo "--------------------------------------------------------"

cloudflared access tcp --hostname "$TARGET_HOST" --listener 127.0.0.1:40056
