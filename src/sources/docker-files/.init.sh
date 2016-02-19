#!/bin/bash
# Executed every run

if [ -f $PATH_HOME/bash.bashrc ]; then
	sudo ln -vfs /root/files/bash.bashrc /etc/bash.bashrc
	rm -vf $PATH_HOME/bash.bashrc
	ln -vfs /root/files/.setup.sh $PATH_HOME/.setup.sh
fi

# Start Services 1
sudo service mysql start
sudo service apache2 restart
#sudo service tomcat7 restart

echo "# Starting fakeSMTP"
sudo java -jar /opt/fakeSMTP.jar -s -p 25 -b -o /var/mail &> /var/mail/mail.log &

# Setup
. $PATH_HOME/.setup.sh

# Start Services 2
sudo service apache2 restart

# RUN
if [ -z "$DOCKDEV_SHELL" ]; then
	echo "# WARNING: 'DOCKDEV_SHELL' environment variable is not defined! Default: 'bash'"
	export DOCKDEV_SHELL="bash"
fi
echo "$ $DOCKDEV_SHELL"
$DOCKDEV_SHELL