## [name]
## Run container.
##
## Params:
##     name: Container Name. Default: "default"

local image

if [ -z "${DOCKDEV_IMPORTING}" ]; then
  image="${DOCKDEV_IMAGE}"
else
  image="${DOCKDEV_IMPORTING}"
fi

@print "Image: $(@style bold)${image}"

. $RESOURCES_PATH/hooks.sh

local cmd="docker run"
local name="$(name-validate $1)"
local options=( y n )
local name_action="$(name-action ${name})"

# Prepare
_prepare() {
  @set-on-exit HOOKS.after-run
  HOOKS.before-run
  @print "Command: $(@style bold)${DOCKDEV_CMD}"
}

# Run
@print "Running $(@style bold)${name}$(@style normal) [$(@style bold)${name_action}$(@style normal)]"
if docker ps -a | egrep "\b${name_action}\b" > /dev/null
  then
    if docker ps | egrep "\b${name_action}\b" > /dev/null
      then
        # Running
        # Start console
        @print "New console..."
        @ACTIONS.new-console "$1"
      else
        # Start container
        _prepare
        @print "Starting container..."
        docker start -i ${name_action}
      fi
  else
    # Pre-Checks
    if [ -z "$DOCKDEV_IMPORTING" ] && [ -d "$DOCKDEV_PROJECTS/${name_action}" ]; then
      @error "Path $(@style bold)$DOCKDEV_PROJECTS/${name_action}$(@style normal) already exists!"
    fi
    # Create container
    if [ -z "$DOCKDEV_IMPORTING" ] && @user-confirm "Create new container named $(@style bold)${name_action}$(@style normal)? (${options[*]})" $options $FALSE ; then
      if docker images | egrep "^${image}\b" > /dev/null
        then
          # Ports
          if [ ! -z "${DOCKDEV_PORTS}" ]; then
            for port in ${DOCKDEV_PORTS[@]}; do
              cmd="${cmd} -p ${port}"
            done
          fi
          # Mounts
          local DOCKDEV_MOUNTS_PATHS
          local DOCKDEV_MOUNTS_PATHS_P
          if [ ! -z "${DOCKDEV_MOUNTS}" ]; then
            for mnt in ${DOCKDEV_MOUNTS[@]}; do
              cmd="${cmd} -v ${mnt}"

              DOCKDEV_MOUNTS_PATHS_P="`echo "${mnt}" | awk -F ':' '{print $2}'`"
              if [ ! -z "${DOCKDEV_MOUNTS_PATHS_P}" ]; then
                [ ! -z "$DOCKDEV_MOUNTS_PATHS" ] && DOCKDEV_MOUNTS_PATHS="${DOCKDEV_MOUNTS_PATHS}:"
                DOCKDEV_MOUNTS_PATHS="${DOCKDEV_MOUNTS_PATHS}${DOCKDEV_MOUNTS_PATHS_P}"
              fi
            done
          fi
          # Variables
          if [ ! -z "${DOCKDEV_VARIABLES}" ]; then
            for v in ${DOCKDEV_VARIABLES[@]}; do
              cmd="${cmd} -e ${v}"
            done
          fi
          # Run
          _prepare
          cmd="$cmd ${DOCKDEV_RUN_PARAMS} --name=\"${name_action}\" --hostname=\"${name_action}\" -e DOCKDEV_SHELL=${DOCKDEV_SHELL} -e DOCKDEV_NAME=${name_action} -e DOCKDEV_MOUNTS_PATHS=${DOCKDEV_MOUNTS_PATHS} -i -t ${image} ${DOCKDEV_CMD}"
          @cmd-log "$cmd"
        else
          @error "Image $(@style bold)${image}$(@style normal) not found! (run 'bash $0 build'?)"
        fi
    else
      @error "Operation cancelled!"
    fi
  fi
