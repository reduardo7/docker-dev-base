##
## Install required software and apply basic configuracion.

if ! type curl > $DEV_NULL
  then
    @e "Installing $(@style bold)curl$(@style normal)..."
    sudo apt-get install -f curl
  else
    @e "$(@style bold)curl$(@style normal) already installed!"
  fi

if ! type docker > $DEV_NULL
  then
    @e "Installing $(@style bold)docker$(@style normal)..."
        #wget -qO- https://get.docker.com/ | sh
    curl -sSL https://get.docker.com/ | sh
    register_user_docker
    @e
    @e "Testing..."
    if ! sudo docker run hello-world
      then
        @e "Error! You need restart the system"
        @error "$ sudo reboot"
    fi
  else
    @e "$(@style bold)docker$(@style normal) already installed!"
    register_user_docker
  fi

#install_host local.my-app.com