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

_add_hosts() {
  local l="127.0.0.1 $1"
  if ! grep "$l" /etc/hosts > /dev/null
    then
      sudo bash -c "echo '$l' >> /etc/hosts"
    fi
}

# Start Services
sudo service mysql start
sudo service apache2 start

echo "Starting fakeSMTP"
sudo java -jar /opt/fakeSMTP.jar -s -p 25 -b -o /var/mail &> /var/mail/mail.log &

if ! echo "SHOW TABLES" | mysql -u root phpmyadmin &> /dev/null
  then
    e "Configure phpMyAdmin"
    sudo dpkg-reconfigure phpmyadmin
  fi

_add_hosts "$(cat /etc/hostname)"

# RUN
zsh