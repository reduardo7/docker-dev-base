#!/bin/bash
sudo -E -u ${DOCKDEV_USER_NAME} "$@"
r=$?

# Error?

if [[ $r -ne 0 ]]; then
  echo "#########################################"
  echo "### Error!"
  echo "### Command:   $@"
  echo "### Exit code: $r"
  echo "#########################################"
  zsh
  r=$?
fi

exit $r