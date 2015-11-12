#!/bin/bash
# Executed every run

export USER_HOME="/home"

if [ ! -d "$USER_HOME/.ssh" ]; then
  if [ -d /root/home/.ssh ]; then
    cp -r /root/home/.ssh $USER_HOME/.ssh
    chown -R $USERNAME:$USERNAME $USER_HOME/.ssh
    chmod -R 400 $USER_HOME/.ssh
  fi
fi

if [ ! -d "$USER_HOME/.git" ]; then
  [ -d "/root/home/.git" ] && cp -r /root/home/.git $USER_HOME/.git
fi

service mysql start
service apache2 start

if ! getent passwd $DOCKDEV_USER_NAME > /dev/null
  then
    echo "Creating user $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME"
    groupadd --gid $DOCKDEV_GROUP_ID -r $DOCKDEV_GROUP_NAME
    useradd --system --uid=$DOCKDEV_USER_ID --gid=$DOCKDEV_GROUP_ID \
      --home-dir $USER_HOME --password $DOCKDEV_USER_NAME $DOCKDEV_USER_NAME
    usermod -a -G sudo $DOCKDEV_USER_NAME
    chown -R $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME $USER_HOME
  fi

sudo -u $DOCKDEV_USER_NAME zsh
