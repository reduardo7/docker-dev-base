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

serviceStart() {
	local serviceName="$1" # Service Name
	local c="$2" # Command
	local w="$3" # Workdir
	local logFilePath="/var/log"
	local pidFile="/tmp/proccess-${serviceName}.pid"
	local logFile="${logFilePath}/${serviceName}.log"
	local logErrorFile="${logFilePath}/${serviceName}.error.log"

	e "Starting ${serviceName} service..."
	sudo touch "$logFile" &>/dev/null
	sudo chmod a+rw "$logFile" &>/dev/null
	sudo touch "$logErrorFile" &>/dev/null
	sudo chmod a+rw "$logErrorFile" &>/dev/null
	sudo touch "$pidFile" &>/dev/null
	sudo chmod a+rw "$pidFile" &>/dev/null
	[ ! -z "$w" ] && cd "$w"
	bash -i -c "($c) & #$w" >>"$logFile" 2>>"$logErrorFile" & echo $! >>"$pidFile"
}

serviceStop() {
	local serviceName="$1" # Service Name
	local pidFile="/tmp/proccess-${serviceName}.pid"

	if [ -f "$pidFile" ] && [ ! -z "$(cat "$pidFile")" ]; then
		e "Stopping ${serviceName}..."
		for p in $(cat "$pidFile"); do
			if kill -0 $p &>/dev/null
				then
					kill $p
					if kill -0 $p &>/dev/null
						then
							sudo kill -9 $p
						fi
				fi
		done
		sudo rm -f "$pidFile"
		sudo touch "$pidFile" &>/dev/null
		sudo chmod a+rw "$pidFile" &>/dev/null
	else
		e "Warning: PID file (${pidFile}) not exists or is empty"
	fi
}

serviceStatus() {
	local serviceName="$1" # Service Name
	local pidFile="/tmp/proccess-${serviceName}.pid"

	if [ -f "$pidFile" ] && [ ! -z "$(cat "$pidFile")" ]; then
		for p in $(cat "$pidFile"); do
			if kill -0 $p &>/dev/null
				then
					e "Proccess with PID $p is running"
				else
					e "Proccess with PID $p is not running"
				fi
		done
	else
		e "Warning: PID file (${pidFile}) not exists or is empty"
	fi
}

serviceMenu() {
	local action="$1"
	local serviceName="$2"
	local c="$3"
	local w="$4"

	case "$action" in
		start)
			serviceStart "$serviceName" "$c" "$w"
			;;
		stop)
			serviceStop "$serviceName"
			;;
		status)
			serviceStatus "$serviceName"
			;;
		debug)
			serviceStop "$serviceName"
			e "Debugging ${serviceName}..."
			[ ! -z "$w" ] && cd "$w"
			bash -i -c "$c"
			;;
		*)
			e "Actions: [start|stop|status|debug]"
			exit 1
			;;
	esac
}

### ACTIONS ###


__fakeSMTP() { # FakeSMTP Service
	serviceMenu "$1" "fakeSMTP" "sudo java -jar /opt/fakeSMTP.jar -s -p 25 -b -o /var/mail"
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
#e "Start > $cmdLog"
"__$@"
r=$?
#e "End   > $cmdLog"
exit $r