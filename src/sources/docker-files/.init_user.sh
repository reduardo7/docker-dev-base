#!/bin/bash
# Executed every run

# User Config

cd $PATH_HOME

if ! getent passwd ${DOCKDEV_USER_NAME} > /dev/null
  then
    echo "Creating user ${DOCKDEV_USER_NAME}:${DOCKDEV_GROUP_NAME}"

    groupadd --gid $DOCKDEV_GROUP_ID -r ${DOCKDEV_GROUP_NAME}

    useradd --system --uid=$DOCKDEV_USER_ID --gid=$DOCKDEV_GROUP_ID \
      --home-dir $PATH_HOME --password ${DOCKDEV_USER_NAME} ${DOCKDEV_USER_NAME}

    usermod -a -G sudo ${DOCKDEV_USER_NAME}

    # Sudo without password
    echo "#!/bin/bash" > /bin/visudoset
    echo "echo \"${DOCKDEV_USER_NAME} ALL=(ALL) NOPASSWD: ALL\" >> \$1" >> /bin/visudoset
    chmod a+x /bin/visudoset
    EDITOR=visudoset visudo
    rm -f /bin/visudoset

    # History
    touch $PATH_HOME/.zsh_history

    # Fixes
    for file in `ls -A | sed 's/\bprojects\b//'`; do
      [ ! -z "$file" ] && chown -vR ${DOCKDEV_USER_NAME}:${DOCKDEV_GROUP_NAME} "$file"
    done
    chown -v ${DOCKDEV_USER_NAME}:${DOCKDEV_GROUP_NAME} /root
    chown -v ${DOCKDEV_USER_NAME}:${DOCKDEV_GROUP_NAME} $PATH_HOME
  fi

if [ ! -d "$PATH_HOME/.ssh" ]; then
  if [ -d /root/home/.ssh ]; then
    cp -vr /root/home/.ssh $PATH_HOME/.ssh
    chown -R ${DOCKDEV_USER_NAME}:${DOCKDEV_GROUP_NAME} $PATH_HOME/.ssh
    chmod -R 700 $PATH_HOME/.ssh

    cat $PATH_HOME/.ssh/id_rsa.pub >> $PATH_HOME/.ssh/authorized_keys
  fi
fi

if [ ! -d "$PATH_HOME/.git" ]; then
  if [ -d "/root/home/.git" ]; then
    cp -r /root/home/.git $PATH_HOME/.git
    chown -R ${DOCKDEV_USER_NAME}:${DOCKDEV_GROUP_NAME} $PATH_HOME/.git
  fi
fi

# Fixes Mount

#for DOCKDEV_MOUNTS_PATHS_P in $(echo "${DOCKDEV_MOUNTS_PATHS}" | tr ":" "\n") ; do
#  chown -R ${DOCKDEV_USER_NAME}:${DOCKDEV_GROUP_NAME} $DOCKDEV_MOUNTS_PATHS_P
#done
chown -R ${DOCKDEV_USER_NAME}:${DOCKDEV_GROUP_NAME} /var/mail

# Run

bash $PATH_HOME/.init_console.sh "$PATH_HOME/.init.sh"
r=$?

# Finish

# Stop Services
service mysql status > /dev/null && service mysql stop
service apache2 status > /dev/null && service apache2 stop

# Exit

exit $r