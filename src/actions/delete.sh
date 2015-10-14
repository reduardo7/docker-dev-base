## name
## Delete Container.
## Params:
##     name: Container name. To delete ALL Containers and Image, use "!ALL".

local options=( y n )

if [ -z "$1" ]; then
  error "Parameter $(style bold)name$(style normal) is required"
  exit 1
fi

if [[ "$1" == "!ALL" ]]; then
  if user_confirm "Confirm delete Image $(style bold)${DOCKDEV_IMAGE}$(style normal) and $(style bold)all related Containers$(style normal)? (${options[*]})" $options $FALSE ; then
    # Delete containers
    e "Deleting Containers for Image $(style bold)${DOCKDEV_IMAGE}$(style normal)..."
    docker rm -f `docker ps -a | egrep "^\w+\s+${DOCKDEV_IMAGE}\s+" | awk '{print $1}'`
    # Delete image
    e "Deleting Image $(style bold)${DOCKDEV_IMAGE}$(style normal)..."
    docker rmi -f ${DOCKDEV_IMAGE}
  else
    e "Operation canceled!"
    exit 1
  fi
else
  local name="${DOCKDEV_IMAGE}.$1"
  if user_confirm "Confirm delete Container $(style bold)${name}$(style normal)? (${options[*]})" $options $FALSE; then
    # Delete container
    e "Deleting Container $(style bold)${name}$(style normal)..."
    docker rm -f ${name}
  else
    e "Operation canceled!"
    exit 1
  fi
fi
