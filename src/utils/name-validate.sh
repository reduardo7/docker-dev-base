local name="$@"

if [ -z "$name" ]; then
  name="$DOCKDEV_CONTAINER_NAME_DEFAULT"
fi

echo "${name}"
