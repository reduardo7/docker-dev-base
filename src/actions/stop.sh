## [name]
## Stop container.
## Params:
##     name: Container Name. Default: "default"

local name="$1"
local options=( y n )

if [ -z "$name" ]; then
  name="$DOCKDEV_CONTAINER_NAME_DEFAULT"
fi

local name_action="${DOCKDEV_IMAGE}.${name}"

if user_confirm "Stop container named $(style bold)${name_action}$(style normal)? (${options[*]})" $options $FALSE ; then
  docker kill ${name_action}
else
  error "Operation cancelled!"
fi