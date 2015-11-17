#!/bin/bash
# Executed every run

# SSH Config

if [ ! -f ~/.ssh/.dockdev_ssh ]; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  touch ~/.ssh/.dockdev_ssh
fi

# Start Services
sudo service mysql start
sudo service apache2 start

echo "Starting fakeSMTP"
sudo java -jar /opt/fakeSMTP.jar -s -p 25 -b -o /var/mail &> /var/mail/mail.log &

# RUN
zsh