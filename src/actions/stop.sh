## [name]
## Stop container.
## Params:
##     name: Container Name. Default: "default"

local name="$(name-validate $1)"
local options=( y n )
local name_action="$(name-action ${name})"

if user_confirm "Stop container named $(style bold)${name_action}$(style normal)? (${options[*]})" $options $FALSE ; then
  docker kill ${name_action}
else
  error "Operation cancelled!"
fi
