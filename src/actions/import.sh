## [name]
## Import image.
##
## Params:
##     name: Destination Container Name. Default: "default"

local param_name="$1"
local name="$(name-validate $param_name)"
local name_action="$(name-action ${name})"
local file_import="${DOCKDEV_PROJECTS}/${name_action}.tar"

export DOCKDEV_IMPORTING="import.${name_action}"

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
