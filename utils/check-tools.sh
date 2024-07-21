#!/bin/bash

while getopts "d:" option; do
    case "$option" in
    d) Dialog=${OPTARG} ;;
    *) ;;
    esac
done

if [ "$Dialog" = true ]; then
    echo "Check if Dialog is installed:"
    dialog=$(pacman -Qi dialog)
    if [ -n "$dialog" ]; then
        echo "- Installed"
    else
        echo "Dialog not found - installing ..."
        sudo pacman -S dialog
    fi
    exit 1
fi

echo "Check if TeamViewer is installed:"
teamviewer=$(pacman -Qi teamviewer)
if [ -n "$teamviewer" ]; then
    echo "- Installed"
else
    echo "TeamViewer not found - installing ..."
    sudo yay -S teamviewer
    sudo systemctl enable teamviewerd
    sudo systemctl start teamviewerd
fi

echo "Check if FreeRDP (xfreerdp) is installed:"
freerdp=$(pacman -Qi freerdp)
if [ -n "$freerdp" ]; then
    echo "- Installed"
else
    echo "FreeRDP (xfreerdp) not found - installing ..."
    sudo yay -S freerdp-git
fi
