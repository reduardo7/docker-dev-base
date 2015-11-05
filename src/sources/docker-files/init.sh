#!/bin/bash
# Executed every run

if [ ! -d "~/.ssh" ]; then
  if [ -d /root/home/.ssh ]; then
    cp -r /root/home/.ssh ~/.ssh
    chown -R $USERNAME:$USERNAME ~/.ssh
    chmod -R 400 ~/.ssh
  fi
fi

if [ ! -d "~/.git" ]; then
  [ -d "/root/home/.git" ] && cp -r /root/home/.git ~/.git
fi

service mysql start
service apache2 start

echo "Starting fakeSMTP"
java -jar /opt/fakeSMTP.jar -s -p 25 -b -o /var/mail &> /var/mail/mail.log &

zsh
