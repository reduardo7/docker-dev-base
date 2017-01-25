local hosts_label="# Avantrip: Autos Docker Hosts"

if ! grep "$hosts_label" /etc/hosts > /dev/null
  then
    sudo bash -c "echo >> /etc/hosts"
    sudo bash -c "echo >> /etc/hosts"
    sudo bash -c "echo '$hosts_label' >> /etc/hosts"
  fi

if ! ping -c 1 $1 > /dev/null
  then
    @print "Installing host $(@style bold)$1"
    sudo bash -c "echo '127.0.0.1 $1' >> /etc/hosts"
  else
    @print "Host $(@style bold)$1$(@style normal) already installed!"
  fi
