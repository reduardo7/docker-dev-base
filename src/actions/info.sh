## [name]
## Get container information.
##
## Params:
##     name: Container Name. Default: "default"

local name="$(name-validate $1)"

docker inspect $(name-action ${name}) | less
