## path [name]
## Run new console in container.
##
## Params:
##     path: Path to open on new console.
##     name: Container Name. Default: "default"

[ -z "$1" ] && @error "Invalid path!"

run-cmd "$2" "${DOCKDEV_CMD_CONSOLE} ${DOCKDEV_SHELL}" "$1"
