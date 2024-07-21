#!/bin/bash

# Check if dialog is installed otherwise installs package
bash ./utils/check-tools.sh -d true

while getopts "e:" option; do
    case "$option" in
    e) Edit=${OPTARG} ;;
    *) ;;
    esac
done

if [ "$Edit" = true ]; then
    # Sets up dialog params
    HEIGHT=15
    WIDTH=40
    CHOICE_HEIGHT=4
    BACKTITLE="Pohoda util script"
    TITLE="Pohoda helper"
    MENU="Choose one of the following options:"

    # Available options for dialog
    OPTIONS=(
        1 "Check or install required tools"
        2 "Add new client config"
        3 "Available connections"
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
        bash ./utils/check-tools.sh
        ;;
    2)
        bash ./utils/add-config.sh
        ;;
    3)
        bash ./utils/connection.sh
        ;;
    esac
else
    bash ./utils/connection.sh
fi
