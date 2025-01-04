#! /bin/bash

echo "##################################"
echo "### Raspberry Pi Zero 2W Setup ###"
echo "##################################"
echo

username=$(whoami)

echo "Are you sure you want to start the setup process? (Yy/Nn)"
read x

if [[ $x == "Y" || $x == "y" ]]; then
    echo "Updating system"
    sudo apt update && sudo apt upgrade -y

    echo "Do you want to install docker? (Yy/Nn)"
    read x

    if [[ $x == "Y" || $x == "y" ]]; then
        echo "Installing Docker"

        sudo apt-get install ca-certificates curl -y
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
            $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update

        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

        clear

        echo "Containers"
        echo "Do you want to install any of the pre-configured containers? (Yy/Nn)"
        read x

        if [[ $x == "Y" || $x == "y" ]]; then
            echo "Enter your choices separated by spaces (e.g., 1 2 3):"
            echo "Leave blank to not install any"
            echo "1) PiHole"
            echo "2) Syncthing"
            echo "3) Openspeedtest"

            read -p "Your choices: " choices

            if [[ -z $choices ]]; then
                echo "Not installing any containers"
            else
                sudo apt install git -y
                echo "Cloning setup files"
                mkdir -p ~/temp
                cd ~/temp
                git clone https://github.com/NikosTokmakidis/docker-configs.git
                cd docker-configs/

                if [ ! -d "/DATA/" ]; then
                    sudo mkdir -p /DATA/applications
                fi

                chown -R $username /DATA/

                for choice in $choices; do
                    case $choice in
                        1)
                            echo "Installing PiHole"
                            cp PiHole.yml docker-compose.yml
                            docker compose up -d
                            ;;
                        2)
                            echo "Installing SyncThing"
                            cp syncthing.yml docker-compose.yml
                            docker compose up -d
                            ;;
                        3)
                            echo "Installing OpenSpeedTest"
                            cp openspeedtest.yml docker-compose.yml
                            docker compose up -d
                            ;;
                        *)
                            echo "Invalid option: $choice"
                            ;;
                    esac
                done
            fi
        fi
    fi
else
    echo "Cancelling setup process"
    sleep 2
fi
