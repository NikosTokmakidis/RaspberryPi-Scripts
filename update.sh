#!/bin/bash

echo "#######################"
echo "###  Update System  ###"
echo "#######################"
echo

echo "Are you sure you want to proceed (Yy/Nn)"
read x

if [[ $x == "Y"  ||  $x == "y" ]]; then
    echo "Updating system"
    sudo apt update && sudo apt upgrade -y

    echo "Do you want to update containers (Yy/Nn)"
    read x

    if [[ $x == "Y" || $x == "y" ]]; then
        echo "Updating Pihole"
        sudo docker stop pihole
        sudo docker pull pihole/pihole
        sudo docker start pihole

        echo "Updating Syncthing"
        sudo docker stop syncthing
        sudo docker pull linuxserver/syncthing
        sudo docker start syncthing

        echo "Updating OpenSpeedTest"
        sudo docker stop openspeedtest
        sudo docker pull openspeedtest/latest
        sudo docker start openspeedtest
    else
        echo "Not updating containers" 

    fi

    echo "Do you want to reboot now (Yy/Nn)"
    read x

    if [[ $x == "Y" || $x == "y" ]]; then
        sudo reboot now
    else
        echo "It is recomended to reboot please do it at a later time"
        exit 0
    fi
else
    echo "Cancelling update process"
fi