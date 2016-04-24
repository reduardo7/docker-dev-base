## [name]
## Import image.
## Params:
##     name: Container Name. Default: "default"

local param_name="$1"
local name="$param_name"

if [ -z "$name" ]; then
  name="$DOCKDEV_CONTAINER_NAME_DEFAULT"
fi

local name_action="${DOCKDEV_IMAGE}.${name}"
export DOCKDEV_IMPORTING="import.${name_action}"
local file_import="${DOCKDEV_PROJECTS}/${name_action}.tar"

# Run
if ! docker ps -a | egrep "\b${name_action}\b" > /dev/null
  then
    if ! docker images | egrep "^${file_import}\b" > $DEV_NULL
      then
        if [ -f "${file_import}" ]; then
          # Import
          e "Importing $(style bold)${name}$(style normal) [$(style bold)${name_action}$(style normal)]..."
          cat "${file_import}" | docker import - "${DOCKDEV_IMPORTING}"
          e "Imported"
          # Run
          ACTIONS.run "$param_name"
        else
          # Error
          error "File $(style bold)${file_import}$(style normal) not exists!"
        fi
      else
        # Error
        error "Image $(style bold)${DOCKDEV_IMPORTING}$(style normal) already exists!"
      fi
  else
    # Error
    error "Container $(style bold)${name_action}$(style normal) already exists!"
  fi
