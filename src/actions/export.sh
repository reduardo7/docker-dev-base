## [name]
## Export container to image.
##
## Params:
##     name: Container Name. Default: "default"

local name="$(name-validate $1)"
local name_action="$(name-action ${name})"
local file_export="${DOCKDEV_PROJECTS}/${name_action}.tar"

# Run
if docker ps -a | egrep "\b${name_action}\b" > $DEV_NULL
  then
    # Export
  @e "Exporting $(@style bold)${name}$(@style normal) [$(@style bold)${name_action}$(@style normal)]..."
    docker export ${name_action} > "${file_export}"
    @e "File exported: ${file_export}"
  else
    # Error
    @error "Container $(@style bold)${name_action}$(@style normal) not exists!"
  fi
