#!/bin/bash

# Check

SETUP_CHK_PATH="$HOME/.setup_check"
[ ! -d $SETUP_CHK_PATH ] && mkdir $SETUP_CHK_PATH

# SSH Config

if [ ! -f $SETUP_CHK_PATH/dockdev_ssh ]; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  touch $SETUP_CHK_PATH/dockdev_ssh
fi

# Utils

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

# Init Path

if [ ! -f $SETUP_CHK_PATH/host-bind ]; then
  ln -fs /root/files/.* $HOME/
  ln -fs /root/files/* $HOME/
  chmod a+x $HOME/*.sh $HOME/.*.sh
  touch $SETUP_CHK_PATH/host-bind
fi

# Set /etc/hosts

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
_add_hosts tardis.local 10.80.50.49
_add_hosts frankie.sv 10.80.30.29
_add_hosts garofalo.avantrip.frankie.sv 10.80.30.29
_add_hosts iata.api.frankie.sv 10.80.30.29

# Init Project

# CD $PROJECT_PATH