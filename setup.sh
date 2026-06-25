#!/usr/bin/env bash

set -e

CONFIG_FILE="setup.conf"
PROFILE_FILE="./profiles/default.yaotl"

# validate files
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "\e[31m[!] Error: Could not find ${CONFIG_FILE}\e[0m"
    exit 1
fi

if [ ! -f "$PROFILE_FILE" ]; then
    echo -e "\e[31m[!] Error: Could not find default profile in ${PROFILE_FILE}\e[0m"
    exit 1
fi

# load vars
source "$CONFIG_FILE"

echo -e "\e[34m[*] Appliying changes...\e[0m"

# replace useing sed
sed -i "s|{{C2_DOMAIN}}|${C2_DOMAIN}|g" "$PROFILE_FILE"
sed -i "s|{{OPERATOR_USER}}|${OPERATOR_USER}|g" "$PROFILE_FILE"
sed -i "s|{{OPERATOR_PASS}}|${OPERATOR_PASS}|g" "$PROFILE_FILE"
sed -i "s|{{DISCORD_WEBHOOK}}|${DISCORD_WEBHOOK}|g" "$PROFILE_FILE"
sed -i "s|{{DEMON_SLEEP}}|${DEMON_SLEEP}|g" "$PROFILE_FILE"
sed -i "s|{{DEMON_JITTER}}|${DEMON_JITTER}|g" "$PROFILE_FILE"

echo -e "\e[32m[+] Placeholders have been replaced successfully.\e[0m"
