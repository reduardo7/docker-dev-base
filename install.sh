#!/bin/bash

if [ -z "$BASH" ]; then
    bash "$0" "$@"
    exit $?
fi

# Utils

s() {
    echo
    echo
}

e() {
    echo "# $@"
}

# Install

if ! type curl > /dev/null
    then
        s ; e "Installing wget..."
        sudo sudo apt-get install -f curl
    fi

if ! type docker > /dev/null
    then
        s ; e "Installing docker..."
        #wget -qO- https://get.docker.com/ | sh
        curl -sSL https://get.docker.com/ | sh
        s ; e "Adding $USER to docker group..."
        sudo usermod -aG docker $USER
        e "Remember that you will have to log out and back in for this to take effect!"
        e
        e
        e "Testing..."
        if ! sudo docker run hello-world
            then
                e "Error!"
                exit 1
            fi
    fi
