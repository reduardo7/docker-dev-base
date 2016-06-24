local hosts_label="# Avantrip: Autos Docker Hosts"

if ! grep "$hosts_label" /etc/hosts > $DEV_NULL
  then
    sudo bash -c "echo >> /etc/hosts"
    sudo bash -c "echo >> /etc/hosts"
    sudo bash -c "echo '$hosts_label' >> /etc/hosts"
  fi

if ! ping -c 1 $1 > $DEV_NULL
  then
    @e "Installing host $(@style bold)$1"
    sudo bash -c "echo '127.0.0.1 $1' >> /etc/hosts"
  else
    @e "Host $(@style bold)$1$(@style normal) already installed!"
  fi
