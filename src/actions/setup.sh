##
## Install required software and apply basic configuracion.

if ! type curl > $DEV_NULL
  then
    @print "Installing $(@style bold)curl$(@style normal)..."
    sudo apt-get install -f curl
  else
    @print "$(@style bold)curl$(@style normal) already installed!"
  fi

if ! type docker > $DEV_NULL
  then
    @print "Installing $(@style bold)docker$(@style normal)..."
        #wget -qO- https://get.docker.com/ | sh
    curl -sSL https://get.docker.com/ | sh
    register_user_docker
    @print
    @print "Testing..."
    if ! sudo docker run hello-world
      then
        @print "Error! You need restart the system"
        @error "$ sudo reboot"
    fi
  else
    @print "$(@style bold)docker$(@style normal) already installed!"
    register_user_docker
  fi

#install_host local.my-app.com