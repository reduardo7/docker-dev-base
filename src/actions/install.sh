##
## Install required software

install_host() {
    if ! ping -c 1 $1 > /dev/null
        then
            e "Installing host $(style bold)$1"
            sudo bash -c "echo '127.0.0.1 $1' >> /etc/hosts"
        else
            e "Host $(style bold)$1$(style normal) already installed!"
        fi
}

if ! type curl > /dev/null
    then
        e "Installing $(style bold)curl$(style normal)..."
        sudo apt-get install -f curl
    else
        e "$(style bold)curl$(style normal) already installed!"
    fi

if ! type docker > /dev/null
    then
        e "Installing $(style bold)docker$(style normal)..."
        #wget -qO- https://get.docker.com/ | sh
        curl -sSL https://get.docker.com/ | sh
        e "Adding $(style bold)$USER$(style normal) to docker group..."
        sudo usermod -aG docker $USER
        e "$(style bold)Remember that you will have to log out and back in for this to take effect!"
        e
        e
        e "Testing..."
        if ! sudo docker run hello-world
            then
                e "Error! You need restart the system"
                e "$ sudo reboot"
                exit 1
            fi
    else
        e "$(style bold)docker$(style normal) already installed!"
    fi

#install_host local.my-app.com