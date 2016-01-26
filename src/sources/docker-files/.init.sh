#!/bin/bash
# Executed every run

# SSH Config

if [ ! -f ~/.ssh/.dockdev_ssh ]; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  touch ~/.ssh/.dockdev_ssh
fi

# Utils

e() {
  echo
  echo "# $@"
  echo
}

_error() {
  e "Error! Code: $1. $2"
  zsh
  exit $1
}

# Set /etc/hosts

_add_hosts() {
  local l="127.0.0.1 $1"
  e "Installing host $l"
  if ! grep "$l" /etc/hosts > /dev/null
    then
      sudo bash -c "echo '$l' >> /etc/hosts"
    fi
}

_add_hosts "$(cat /etc/hostname)"

# Start Services
sudo service mysql start
sudo service apache2 restart

echo "# Starting fakeSMTP"
sudo java -jar /opt/fakeSMTP.jar -s -p 25 -b -o /var/mail &> /var/mail/mail.log &

# RUN
echo "# Ready!"
zsh