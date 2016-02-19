local name="$1"
local cmd="$2"
local working_dir="$3"

e "Image: $(style bold)${DOCKDEV_IMAGE}"
e "Command: $(style bold)${cmd}"

if [ -z "$name" ]; then
  name="$DOCKDEV_CONTAINER_NAME_DEFAULT"
fi

local name_action="${DOCKDEV_IMAGE}.${name}"

# Run
e "Running $(style bold)${name}$(style normal) [$(style bold)${name_action}$(style normal)]"
if docker ps | egrep "\b${name_action}\b" > /dev/null
  then
    # Start console
    if [ -z "$working_dir" ]; then
        docker exec -i -t ${name_action} ${cmd}
    else
        docker exec -i -t ${name_action} bash -c "cd $working_dir && ${cmd}"
    fi
  else
    # Error
    error "Container $(style bold)${name_action}$(style normal) is not running!"
  fi
