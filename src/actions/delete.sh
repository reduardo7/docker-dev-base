## name
## Delete Container.
##
## Params:
##     name: Container name. To delete ALL Containers and Image, use "!ALL".

local name="$(name-validate $1)"
local options=( y n )
local options2=( s n )

e "$(style bold)WARINING! All container data $(style underline)WILL BE LOST!"
pause

if [[ "$name" == "!ALL" ]]; then
  if user_confirm "Confirm delete Image $(style bold)${DOCKDEV_IMAGE}$(style normal) and $(style bold)all related Containers$(style normal)? (${options[*]})" $options $FALSE ; then
    if user_confirm "Please RE-CONFIRM: Confirm delete Image $(style bold)${DOCKDEV_IMAGE}$(style normal) and $(style bold)all related Containers$(style normal)? (${options2[*]})" $options2 $FALSE ; then
      # Delete containers
      if docker ps -a | egrep "\b${DOCKDEV_IMAGE}(:\w*)?\b" > $DEV_NULL
        then
          e "Deleting Containers for Image $(style bold)${DOCKDEV_IMAGE}$(style normal)..."
          docker rm -f `docker ps -a | egrep "^\w+\s+${DOCKDEV_IMAGE}(:\w*)?\s+" | awk '{print $1}'`
        fi
      # Delete image
      e "Deleting Image $(style bold)${DOCKDEV_IMAGE}$(style normal)..."
      docker rmi -f ${DOCKDEV_IMAGE}
      exit 0
    fi
  fi
else
  name="$(name-action $name)"
  if user_confirm "Confirm delete Container $(style bold)${name}$(style normal)? (${options[*]})" $options $FALSE; then
    if user_confirm "Please RE-CONFIRM: Confirm delete Container $(style bold)${name}$(style normal)? (${options2[*]})" $options2 $FALSE; then
      # Delete container
      e "Deleting Container $(style bold)${name}$(style normal)..."
      docker rm -f ${name}
      exit 0
    fi
  fi
fi

error "Operation $(style bold)canceled!"
