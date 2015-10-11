##
## Run container
## Example: docker run -p <host_port1>:<container_port1> -p <host_port2>:<container_port2> -i -t DOCKDEV_IMAGE /bin/bash

# docker images
# docker ps

e "Running $(style bold)${DOCKDEV_IMAGE}"
e "Command: $(style bold)${DOCKDEV_CMD}"

local cmd="docker run"
local port

if [ ! -z "${DOCKDEV_PORTS}" ]; then
  # Without ports
  for port in ${DOCKDEV_PORTS[@]}; do
    cmd="${cmd} -p ${port}"
  done
fi

$cmd -i -t ${DOCKDEV_IMAGE} ${DOCKDEV_CMD}
