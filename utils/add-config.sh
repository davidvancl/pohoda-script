#!/bin/bash

CONFIGS_DIR="/home/wpj/workspace/kupshop/pohoda-configs/"
TEMPLATE_FILE="template.cfg.rdp"

# Sets up dialog params
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Pohoda util script"
TITLE="Create new config script"
MENU="Choose one of the following options:"

# Available options for dialog
OPTIONS=(
    1 "RDP"
    2 "TeamViewer"
)

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
case $CHOICE in
1)
    # RDP dialog
    dialog --backtitle "Settings dialog for new config" --title "Settings new RDP config" \
        --form "\nEnter config values" 25 60 16 \
        "Directory name: " 1 1 "" 1 25 25 30 \
        "RDP address: " 2 1 "" 2 25 25 30 >/tmp/out.tmp \
        2>&1 >/dev/tty

    # Start retrieving each line from temp file 1 by one with sed and declare variables as inputs
    DIR_NAME=$(sed -n 1p /tmp/out.tmp)
    RDP_ADDRESS=$(sed -n 2p /tmp/out.tmp)

    # Remove temporary file created
    rm -f /tmp/out.tmp

    # Clear terminal
    clear

    # If not exists, than create config
    if [ ! -f "$CONFIGS_DIR$DIR_NAME/atp.cfg.rdp" ]; then
        # Creates folder
        mkdir -p "$CONFIGS_DIR$DIR_NAME"
        # Copy template file
        cp "$TEMPLATE_FILE" "$CONFIGS_DIR$DIR_NAME/atp.cfg.rdp"

        # Replace data inside config file
        sed -i -e "s/{FULL_ADDRESS}/$RDP_ADDRESS/g" "$CONFIGS_DIR$DIR_NAME/atp.cfg.rdp"
        sed -i -e "s/{SUB_FOLDER}/$DIR_NAME/g" "$CONFIGS_DIR$DIR_NAME/atp.cfg.rdp"
    else
        echo "!!!Config [$CONFIGS_DIR$DIR_NAME/atp.cfg.rdp] already exists!!!"
    fi
    ;;
2)
    # TeamViewer dialog
    dialog --backtitle "Settings dialog for new config" --title "Settings TeamViewer link" \
        --form "\nEnter config values" 25 60 16 \
        "Directory name: " 1 1 "" 1 25 25 30 >/tmp/out.tmp \
        2>&1 >/dev/tty

    # Direcotry name
    DIR_NAME=$(sed -n 1p /tmp/out.tmp)

    # Remove temporary file created
    rm -f /tmp/out.tmp

    # Clear terminal
    clear

    # If not exists, than create config
    if [ ! -f "$CONFIGS_DIR$DIR_NAME/teamviewer.cfg" ]; then
        # Creates folder
        mkdir -p "$CONFIGS_DIR$DIR_NAME"
        # Creates teamviewer init file
        touch "$CONFIGS_DIR$DIR_NAME/teamviewer.cfg"
    else
        echo "!!!Config [$CONFIGS_DIR$DIR_NAME/teamviewer.cfg] already exists!!!"
    fi
    ;;
esac

echo "Script finished!"
