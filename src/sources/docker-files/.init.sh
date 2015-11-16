#!/bin/bash
# Executed every run

# Start Services
sudo service mysql start
sudo service apache2 start

echo "Starting fakeSMTP"
sudo java -jar /opt/fakeSMTP.jar -s -p 25 -b -o /var/mail &> /var/mail/mail.log &

# RUN
zsh