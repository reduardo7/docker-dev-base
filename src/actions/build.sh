## [container-id]
## Build image

if docker images | egrep "^${DOCKDEV_IMAGE}\b" > $DEV_NULL
  then
    @e "Deleting image $(@style bold)${DOCKDEV_IMAGE}$(@style normal)..."
    docker rmi $DOCKDEV_IMAGE || @error "Error deleting image $(@style bold)${DOCKDEV_IMAGE}$(@style normal)!"
  fi

@e "Building $(@style bold)${DOCKDEV_IMAGE}$(@style normal) from $(@style bold)Dockerfile$(@style normal)..."
docker build -t $DOCKDEV_IMAGE ${RESOURCES_PATH}

@e "Finish!"
