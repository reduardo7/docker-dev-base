#!/bin/bash
# Executed every run

# User Config

export HOME="$PATH_HOME"

if ! getent passwd $DOCKDEV_USER_NAME > /dev/null
  then
    echo "Creating user $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME"

    groupadd --gid $DOCKDEV_GROUP_ID -r $DOCKDEV_GROUP_NAME

    useradd --system --uid=$DOCKDEV_USER_ID --gid=$DOCKDEV_GROUP_ID \
      --home-dir $PATH_HOME --password $DOCKDEV_USER_NAME $DOCKDEV_USER_NAME

    usermod -a -G sudo $DOCKDEV_USER_NAME

    chown -R $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME $PATH_HOME

    # Sudo without password
    echo "#!/bin/bash" > /bin/visudoset
    echo "echo \"$DOCKDEV_USER_NAME ALL=(ALL) NOPASSWD: ALL\" >> \$1" >> /bin/visudoset
    chmod a+x /bin/visudoset
    EDITOR=visudoset visudo
    rm -f /bin/visudoset

    # Fixes
    chown $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME $PATH_HOME/.zshrc
    chown -R $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME $PATH_HOME/.oh-my-zsh
  fi

if [ ! -d "$PATH_HOME/.ssh" ]; then
  if [ -d /root/home/.ssh ]; then
    cp -r /root/home/.ssh $PATH_HOME/.ssh
    chown -R $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME $PATH_HOME/.ssh
    chmod -R 400 $PATH_HOME/.ssh
  fi
fi

if [ ! -d "$PATH_HOME/.git" ]; then
  if [ -d "/root/home/.git" ]; then
  	cp -r /root/home/.git $PATH_HOME/.git
  	chown -R $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME $PATH_HOME/.git
  fi
fi

# Fixes Mount
for DOCKDEV_MOUNTS_PATHS_P in ${DOCKDEV_MOUNTS_PATHS[@]} ; do
  chown -R $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME $DOCKDEV_MOUNTS_PATHS_P
done

# Run
sudo -E -u $DOCKDEV_USER_NAME $@