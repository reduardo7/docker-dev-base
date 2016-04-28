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

serviceStatus() {
	local serviceName="$1" # Service Name
	local pidFile="/tmp/proccess-${serviceName}.pid"

	if [ -f "$pidFile" ] && [ ! -z "$(cat "$pidFile")" ]; then
		local err=1
		for p in $(cat "$pidFile"); do
			if kill -0 $p &>/dev/null
				then
					e "Proccess with PID $p is running"
					err=0
				else
					e "Proccess with PID $p is not running"
				fi
		done
		return $err
	else
		e "Warning: PID file (${pidFile}) not exists or is empty"
		return 2
	fi
}

serviceStart() {
	local serviceName="$1" # Service Name
	local c="$2" # Command
	local w="$3" # Workdir
	local logFilePath="/var/log"
	local pidFile="/tmp/proccess-${serviceName}.pid"
	local logFile="${logFilePath}/${serviceName}.log"
	local logErrorFile="${logFilePath}/${serviceName}.error.log"

	if serviceStatus "$1" &>/dev/null
		then
			e "Service ${serviceName} already running with PID $(cat "$pidFile")"
			return 0
		fi

	e "Starting ${serviceName} service..."
	sudo touch "$logFile" &>/dev/null
	sudo chmod a+rw "$logFile" &>/dev/null
	sudo touch "$logErrorFile" &>/dev/null
	sudo chmod a+rw "$logErrorFile" &>/dev/null
	sudo touch "$pidFile" &>/dev/null
	sudo chmod a+rw "$pidFile" &>/dev/null

	[ ! -z "$w" ] && cd "$w"
	bash -i -c "$c >>\"$logFile\" 2>>\"$logErrorFile\" & echo \$! >>\"$pidFile\""

	serviceStatus "$1" &>/dev/null
	return $?
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
					sleep 2
					if kill -0 $p &>/dev/null
						then
							kill -9 $p
							sleep 2
							if kill -0 $p &>/dev/null
								then
									e "Exec: sudo kill -9 $p"
									sudo kill -9 $p
								fi
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

serviceRestart() {
	local serviceName="$1" # Service Name
	local c="$2" # Command
	local w="$3" # Workdir

	serviceStop "$serviceName"
	serviceStart "$serviceName" "$c" "$w"
}

serviceTail() {
	local serviceName="$1" # Service Name
	local type="$2"
	local logFilePath="$PATH_PROJECT"
	local logFile="${logFilePath}/${serviceName}.log"
	local logErrorFile="${logFilePath}/${serviceName}.error.log"

	case "$type" in
		log)
			tail -f "$logFile"
			exit 0
			;;
		error)
			tail -f "$logErrorFile"
			exit 0
			;;
		all)
			tail -f "$logFile" "$logErrorFile"
			exit 0
			;;
		*)
			e "Actions: [log|error]"
			exit 1
			;;
	esac
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
		restart)
			serviceRestart "$serviceName" "$c" "$w"
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
		tail)
			serviceTail "$serviceName" "all"
			;;
		tail-log)
			serviceTail "$serviceName" "log"
			;;
		tail-error)
			serviceTail "$serviceName" "error"
			;;
		*)
			e "Actions: [start|stop|restart|status|debug|tail(-[log|error])]"
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