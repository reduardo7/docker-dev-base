#!/bin/bash
# Executed every run

service mysql start
service apache2 start

echo "Starting fakeSMTP"
java -jar /opt/fakeSMTP.jar -s -p 25 -b -o /var/mail &> /var/mail/mail.log &

# Configure User
export HOME="/home"

if [ ! -d "$HOME/.ssh" ]; then
  if [ -d /root/home/.ssh ]; then
    cp -r /root/home/.ssh $HOME/.ssh
    chown -R $USERNAME:$USERNAME $HOME/.ssh
    chmod -R 400 $HOME/.ssh
  fi
fi

if [ ! -d "$HOME/.git" ]; then
  [ -d "/root/home/.git" ] && cp -r /root/home/.git $HOME/.git
fi

if ! getent passwd $DOCKDEV_USER_NAME > /dev/null
  then
    echo "Creating user $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME"
    groupadd --gid $DOCKDEV_GROUP_ID -r $DOCKDEV_GROUP_NAME
    useradd --system --uid=$DOCKDEV_USER_ID --gid=$DOCKDEV_GROUP_ID \
      --home-dir $HOME --password $DOCKDEV_USER_NAME $DOCKDEV_USER_NAME
    usermod -a -G sudo $DOCKDEV_USER_NAME
    chown -R $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME $HOME
  fi

sudo -u $DOCKDEV_USER_NAME zsh