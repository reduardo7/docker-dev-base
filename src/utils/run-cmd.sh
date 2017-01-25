local name="$(name-validate $1)"
local cmd="$2"
local working_dir="$3"
local name_action="$(name-action ${name})"

@print "Image: $(@style bold)${DOCKDEV_IMAGE}"
@print "Command: $(@style bold)${cmd}"

# Run
@print "Running $(@style bold)${name}$(@style normal) [$(@style bold)${name_action}$(@style normal)]"
if docker ps | egrep "\b${name_action}\b" > $DEV_NULL
  then
    # Start console
    if [ -z "$working_dir" ]; then
        docker exec -i -t ${name_action} ${cmd}
    else
        docker exec -i -t ${name_action} bash -c "cd $working_dir && ${cmd}"
    fi
  else
    # Error
    @error "Container $(@style bold)${name_action}$(@style normal) is not running!"
  fi
