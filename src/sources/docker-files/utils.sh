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

### ACTIONS ###

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
	cat $src | egrep '__[a-zA-Z0-9_\-]+\(\)\s*\{' | sed 's/^__/#   /' | sed 's/\s*(\s*)\s*{\s*#\s*/\n#     /'
	e
}

### RUN ###

if [ $# -eq 0 ] || ! grep "$cmd" $src > /dev/null
	then
		__help
		exit 1
	fi

# Log command to execute
cmdLog="[`cat $src | egrep '__[a-zA-Z0-9_\-]+\(\)\s*\{' | sed 's/^__//' | sed 's/\s*(\s*)\s*{\s*#\s*/] /' | egrep "^$1"`"
e "Start > $cmdLog"
"__$@"
r=$?
e "End   > $cmdLog"
exit $r