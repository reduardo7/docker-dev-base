## [name]
## Run new console in container.
## Params:
##     name: Container Name. Default: "default"

e "Image: $(style bold)${DOCKDEV_IMAGE}"
e "Command: $(style bold)${DOCKDEV_CMD_CONSOLE}"

local name="$1"

if [ -z "$name" ]; then
  name="$DOCKDEV_CONTAINER_NAME_DEFAULT"
fi

local name_action="${DOCKDEV_IMAGE}.${name}"

# Run
e "Running $(style bold)${name}$(style normal) [$(style bold)${name_action}$(style normal)]"
if docker ps | egrep "\s${name_action}$" > /dev/null
  then
    # Start console
    docker exec -i -t ${name_action} bash -c "set -e && ${DOCKDEV_CMD}"
  else
    # Error
    error "Container $(style bold)${name_action}$(style normal) is not running!"
  fi
