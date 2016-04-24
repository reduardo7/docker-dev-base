#!/bin/bash
sudo -E -u ${DOCKDEV_USER_NAME} "$@"
r=$?

# Error?
if [[ $r -ne 0 ]]; then
  echo "#########################################"
  echo "### Exit Code <> 0"
  echo "### Command:   $@"
  echo "### Exit code: $r"
  echo "#########################################"
  bash
  r=$?
fi

exit $r