#!/bin/bash
CONFIGS_DIR="/home/wpj/workspace/kupshop/pohoda-configs/"

# Sets up dialog params
HEIGHT=25
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Pohoda util script"
TITLE="Pohoda helper"
MENU="Choose one of the following options:"
OPTIONS=()

# Read folders with config
while IFS= read -r directory; do
    folder_name=${directory##*/}
    index=$((index + 1))
    OPTIONS+=("$index" "$folder_name")
done < <(find "$CONFIGS_DIR" -maxdepth 1 -type d -not -name ".*" -not -name "configs")

if [ ${#OPTIONS[@]} -eq 0 ]; then
    echo "No valid options found!"
else
    # Creates dialog and process saves response
    CHOICE=$(dialog --clear \
        --backtitle "$BACKTITLE" \
        --title "$TITLE" \
        --menu "$MENU" \
        $HEIGHT $WIDTH $CHOICE_HEIGHT \
        "${OPTIONS[@]}" \
        2>&1 >/dev/tty)

    # Clears terminal
    clear

    # Process response from dialog
    echo "You chose $CHOICE: $CONFIGS_DIR${OPTIONS[$((CHOICE * 2 - 1))]} -> connecting ..."

    # Process connection
    if [ -f "$CONFIGS_DIR${OPTIONS[$((CHOICE * 2 - 1))]}/atp.cfg.rdp" ]; then
        echo "$CONFIGS_DIR${OPTIONS[$((CHOICE * 2 - 1))]}/atp.cfg.rdp"
        xfreerdp "$CONFIGS_DIR${OPTIONS[$((CHOICE * 2 - 1))]}/atp.cfg.rdp" "/p:PASSWD"
    elif [ -f "$CONFIGS_DIR${OPTIONS[$((CHOICE * 2 - 1))]}/teamviewer.cfg" ]; then
        teamviewer
    else
        echo "No settings found inside direstory."
    fi
fi
