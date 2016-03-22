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
$PATH_HOME/utils.sh fakeSMTP start

# Setup
. $PATH_HOME/.setup.sh

# Start Services 2
sudo service apache2 restart

# RUN
if [ -z "$DOCKDEV_SHELL" ]; then
	if type zsh &>/dev/null
		then
			export DOCKDEV_SHELL="zsh"
		else
			export DOCKDEV_SHELL="bash"
		fi
fi
echo "$ $DOCKDEV_SHELL"
$DOCKDEV_SHELL