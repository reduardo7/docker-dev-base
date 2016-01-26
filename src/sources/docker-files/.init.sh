#!/bin/bash
# Executed every run

sudo ln -svf $PATH_HOME/bash.bashrc /etc/bash.bashrc

# Start Services
sudo service mysql start
sudo service apache2 restart
#sudo service tomcat7 restart

# Setup
. /home/.setup.sh

echo "# Starting fakeSMTP"
sudo java -jar /opt/fakeSMTP.jar -s -p 25 -b -o /var/mail &> /var/mail/mail.log &

# RUN
echo "# Ready!"
zsh