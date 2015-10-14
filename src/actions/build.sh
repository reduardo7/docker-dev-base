## [container-id]
## Build image
##
## Params
##   container-id: (OPTIONAL) Container ID (see 'docker ps -a').

local container_id="$1"

if [ -z "$container_id" ]; then
    e "Building $(style bold)${DOCKDEV_IMAGE}$(style normal) from $(style bold)Dockerfile$(style normal)..."
    docker build -t $DOCKDEV_IMAGE ${SOURCES_PATH}
else
    e "Building $(style bold)${DOCKDEV_IMAGE}$(style normal) from Container ID $(style bold)${container_id}$(style normal)..."
    echo docker commit $container_id $DOCKDEV_IMAGE
fi
