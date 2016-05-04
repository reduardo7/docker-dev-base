## destination-name [origin-name]
## Clone container and copy project resources.
## Params:
##     destination-name: New Container Name.
##     origin-name: Container Name to clone. Default: "default"

[ -z "$1" ] && error "Invalid destination name!"

local options=( y n )
local destination_name="$1"
local origin_name="$2"

if [ -z "$origin_name" ]; then
  origin_name="$DOCKDEV_CONTAINER_NAME_DEFAULT"
fi

ACTIONS.export "$origin_name"
ACTIONS.import "$destination_name"

e "Copy project resources..."
sudo cp -rp "$DOCKDEV_PROJECTS/${DOCKDEV_IMAGE}.${origin_name}" "$DOCKDEV_PROJECTS/${DOCKDEV_IMAGE}.${destination_name}"
e "Finish!"

if user_confirm "Start cloned container $(style bold)${destination_name}$(style normal)? (${options[*]})" $options $FALSE ; then
  ACTIONS.run "$destination_name"
fi
