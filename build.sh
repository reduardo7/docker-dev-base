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
            fi
    fi

# Build

image_name="$1"
image_id="$2"
if [ -z "$image_name" ]; then
    e "Usage:"
    e "    $0 IMAGE_NAME [IMAGE_ID]"
    e
    e "    IMAGE_NAME: Image Name"
    e "    IMAGE_ID: (OPTIONAL) Image ID (see 'docker ps')"
    exit 1
fi

s ; s

e "Resources..."
mkdir resources
ln -fs /home/ecuomo resources/home

if [ -z "$image_id" ]; then
    e "Building ${image_name}..."
    docker build -t $image_name .
else
    e "Building ${image_name} from ${image_id}..."
    docker commit $image_id $image_name
fi
