#!/bin/bash

### VARS ###

src="$0"
cmd="__$1()"

### UTILS ###

e() {
	echo "# $@"
}

l() {
	e "--------------------------------------------------------------------------------"
}

r() {
	e "$@"
	l
	"$@"
	l
}

### PARAMS ###

# Dockdev

__upgrade() { # DockDev: Copy DockDev Base Scripts from docker-files to /home (.init*.sh; .zshrc; utils.sh).
	sudo chown -v ${DOCKDEV_USER_NAME}:${DOCKDEV_GROUP_NAME} /root
	cp -fv /root/files/.init*.sh /home
	cp -fv /root/files/.zshrc /home

	echo "# Error after this, no problem"
	cp -fv /root/files/utils.sh /home
}

# Others

__help() { # Show this help.
	l
	e "Utils: Help"
	l
	e
	e "Usage:"
	e "  bash $0 PARAMETER [ARGS]"
	e
	e "Parameters:"
	cat $src | egrep '__\w+\(\)\s*\{' | sed 's/^__/#   /' | sed 's/\s*(\s*)\s*{\s*#\s*/\n#     /'
	e
}

### RUN ###

if [ $# -eq 0 ] || ! grep "$cmd" $src > /dev/null
	then
		__help
		exit 1
	fi

"__$@"