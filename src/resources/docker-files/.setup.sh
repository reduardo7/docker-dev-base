#!/bin/bash

# ### #
# Env #
# ### #

export PATH_PROJECTS_CONT="$PATH_PROJECTS/$DOCKDEV_NAME"

# ##################### #
# Create Project Path's #
# ##################### #

[ ! -d "$PATH_PROJECTS_CONT" ] && mkdir $PATH_PROJECTS_CONT
[ ! -d "$PATH_PROJECT" ] && (
  git config --global push.default matching
  ln -s $PATH_PROJECTS_CONT $PATH_PROJECT
)

# ##### #
# Check #
# ##### #

SETUP_CHK_PATH="$HOME/.setup_check"
[ ! -d $SETUP_CHK_PATH ] && mkdir $SETUP_CHK_PATH

# ########## #
# SSH Config #
# ########## #

SETUP_CHK_PATH_SSH="$SETUP_CHK_PATH/dockdev_ssh"
if [ ! -f $SETUP_CHK_PATH_SSH ]; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  touch $SETUP_CHK_PATH_SSH
fi

# ##### #
# Utils #
# ##### #

e() {
  echo
  echo "# $@"
  echo
}

_error() {
  e "Error! Code: $1. $2"
  bash
  exit $1
}

_gitClone() {
  git clone $1 $2 || _error 61 "Error cloning '$1'"
}

_setVars() {
  if grep '{PATH_PROJECT}' $1 &>/dev/null
    then
      sudo sed -i "s/{PATH_PROJECT}/$(echo "$PATH_PROJECT" | sed 's/\//\\\//g')/g" $1
    fi
  if grep '{PATH_PROJECTS}' $1 &>/dev/null
    then
      sudo sed -i "s/{PATH_PROJECTS}/$(echo "$PATH_PROJECTS" | sed 's/\//\\\//g')/g" $1
    fi
}

_setConfig() {
  rm -vf $HOME/$1
  rm -vf $2
  cp -vf /root/files/$1 $2
  _setVars $2
}

# ######### #
# Init Path #
# ######### #

SETUP_CHK_PATH_HOST_BIND="$SETUP_CHK_PATH/host-bind"
if [ ! -f $SETUP_CHK_PATH_HOST_BIND ]; then
  ln -fs /root/files/.* $HOME/
  ln -fs /root/files/* $HOME/
  chmod a+x $HOME/*.sh $HOME/.*.sh

  _setSite() {
    sudo mv -vf apache2.$1 /etc/apache2/sites-available/$1
    _setVars /etc/apache2/sites-available/$1
    sudo a2ensite $1
  }

  #_setSite site.conf

  touch $SETUP_CHK_PATH_HOST_BIND
fi

# ### #
# GIT #
# ### #

SETUP_CHK_PATH_GIT="$SETUP_CHK_PATH/git"
if [ ! -f $SETUP_CHK_PATH_GIT ]; then
  git config --global push.default matching
  touch $SETUP_CHK_PATH_GIT
fi

# ##### #
# hosts #
# ##### #

_add_hosts() {
  local u="$2"
  [ -z "$u" ] && u="127.0.0.1"
  local l="$u $1"
  e "Installing host $l"
  if ! grep "$l" /etc/hosts > /dev/null
    then
      sudo bash -c "echo '$l' >> /etc/hosts"
    fi
}

_add_hosts "$(cat /etc/hostname)"
#_add_hosts $SITE_URL

# ####### #
# Init DB #
# ####### #

#SETUP_CHK_PATH_DB="$SETUP_CHK_PATH/db-init"
#if [ ! -f $SETUP_CHK_PATH_DB ]; then
#  sudo dpkg-reconfigure phpmyadmin
#  zcat $PATH_PROJECTS/db.sql.zip | mysql -uroot -p${MYSQL_ROOT_PASS} $MYSQL_DB_NAME
#  touch $SETUP_CHK_PATH_DB
#fi

# ############ #
# Init Project #
# ############ #

cd $PATH_PROJECT

#if [ ! -d my-project ]; then
#  _gitClone git@github.com:/test/my-project.git my-project
#  (
#    cd my-project/includes/config
#    ln -vfs env.php.sample env.php
#    ln -vfs local.ini.sample local.ini
#  )
#  (
#    cd my-project
#    composer install
#    composer update
#  )
#fi
