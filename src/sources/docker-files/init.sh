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

if ! getent passwd $DOCKDEV_USER_NAME > /dev/null
  then
    echo "Creating user $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME"
    groupadd --gid $DOCKDEV_GROUP_ID -r $DOCKDEV_GROUP_NAME
    useradd --system --uid=$DOCKDEV_USER_ID --gid=$DOCKDEV_GROUP_ID \
    	--home-dir /home --password $DOCKDEV_USER_NAME $DOCKDEV_USER_NAME
    usermod -a -G sudo $DOCKDEV_USER_NAME
    chown -R $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME /home
  fi

sudo -u $DOCKDEV_USER_NAME zsh
