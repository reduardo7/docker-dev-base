## [container-id]
## Build image
##
## Params
##   container-id: (OPTIONAL) Container ID (see 'docker ps -a').

local container_id="$1"

if docker images | egrep "^${DOCKDEV_IMAGE}\b" > $DEV_NULL
  then
    e "Deleting image $(style bold)${DOCKDEV_IMAGE}$(style normal)..."
    docker rmi $DOCKDEV_IMAGE || error "Error deleting image $(style bold)${DOCKDEV_IMAGE}$(style normal)!"
  fi

if [ -z "$container_id" ]; then
  e "Building $(style bold)${DOCKDEV_IMAGE}$(style normal) from $(style bold)Dockerfile$(style normal)..."
  docker build -t $DOCKDEV_IMAGE ${RESOURCES_PATH}
else
  _rmi $container_id
  e "Building $(style bold)${DOCKDEV_IMAGE}$(style normal) from Container ID $(style bold)${container_id}$(style normal)..."
  docker commit $container_id $DOCKDEV_IMAGE
fi
