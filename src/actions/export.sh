## [name]
## Export container to image.
## Params:
##     name: Container Name. Default: "default"

local name="$1"
local file_export="${DOCKDEV_PROJECTS}/${name_action}.tar"

if [ -z "$name" ]; then
  name="$DOCKDEV_CONTAINER_NAME_DEFAULT"
fi

local name_action="${DOCKDEV_IMAGE}.${name}"

# Run
if docker ps -a | egrep "\b${name_action}\b" > /dev/null
  then
    # Export
	e "Exporting $(style bold)${name}$(style normal) [$(style bold)${name_action}$(style normal)]..."
    docker export ${name_action} > "${file_export}"
    e "File exported: ${file_export}"
  else
    # Error
    error "Container $(style bold)${name_action}$(style normal) not exists!"
  fi
