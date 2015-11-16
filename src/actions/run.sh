## [name] [--no-mobile] [--no-solr]
## Run container.
## Params:
##     name:        Container Name. Default: "default"
##     --no-mobile: No install Mobile project
##     --no-solr:   No install Solr project

# docker images
# docker ps

e "Image: $(style bold)${DOCKDEV_IMAGE}"
e "Command: $(style bold)${DOCKDEV_CMD}"

. $SOURCES_PATH/hooks.sh

local cmd="docker run"
local name="$1"
local options=( y n )

if [ -z "$name" ]; then
  name="$DOCKDEV_CONTAINER_NAME_DEFAULT"
fi

local name_action="${DOCKDEV_IMAGE}.${name}"

# Prepare
_prepare() {
  set_on_exit after_run
  before_run
}

# Run
e "Running $(style bold)${name}$(style normal) [$(style bold)${name_action}$(style normal)]"
if docker ps -a | egrep "\s${name_action}$" > /dev/null
  then
    # Start container
    _prepare
    docker start -i ${name_action}
  else
    # Pre-Checks
    if [ -d "$DOCKDEV_PROJECTS/${name_action}" ]; then
      error "Path $(style bold)$DOCKDEV_PROJECTS/${name_action}$(style normal) already exists!"
    fi
    # Create container
    if user_confirm "Create new container named $(style bold)${name_action}$(style normal)? (${options[*]})" $options $FALSE ; then
      if docker images | egrep "^${DOCKDEV_IMAGE}\s" > /dev/null
        then
          # Ports
          if [ ! -z "${DOCKDEV_PORTS}" ]; then
            for port in ${DOCKDEV_PORTS[@]}; do
              cmd="${cmd} -p ${port}"
            done
          fi
          # Mounts
          local DOCKDEV_MOUNTS_PATHS
          if [ ! -z "${DOCKDEV_MOUNTS}" ]; then
            for mnt in ${DOCKDEV_MOUNTS[@]}; do
              cmd="${cmd} -v ${mnt}"

              str_explode ":" "${mnt}"
              if [ -z "${RESULT[2]}" ]; then
                [ ! -z "$DOCKDEV_MOUNTS_PATHS" ] && DOCKDEV_MOUNTS_PATHS="${DOCKDEV_MOUNTS_PATHS} "
                DOCKDEV_MOUNTS_PATHS="${DOCKDEV_MOUNTS_PATHS}${RESULT[2]}"
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
          cmd="$cmd $DOCKDEV_RUN_PARAMS"
          $cmd --name="${name_action}" --hostname="${name_action}" -e "DOCKDEV_NAME=${name_action}" -e "DOCKDEV_MOUNTS_PATHS=${DOCKDEV_MOUNTS_PATHS}" -i -t ${DOCKDEV_IMAGE} ${DOCKDEV_CMD}
        else
          error "Image $(style bold)${DOCKDEV_IMAGE}$(style normal) not found! (run 'bash $0 build'?)"
        fi
    else
      error "Operation cancelled!"
    fi
  fi
