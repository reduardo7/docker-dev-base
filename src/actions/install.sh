##
## Install required software

if ! type curl > /dev/null
    then
        e "Installing $(style bold)curl$(style normal)..."
        sudo sudo apt-get install -f curl
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
                e "Error!"
                exit 1
            fi
    else
        e "$(style bold)docker$(style normal) already installed!"
    fi
