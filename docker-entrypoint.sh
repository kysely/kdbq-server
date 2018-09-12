#!/usr/bin/env bash

AUTH_FILE="/root/_userpass.txt"
STARTUP_FILE="/root/_startup.q"

get_userpass() {
	if [ "$1" != "" ]; then
		USERPASS="-u $AUTH_FILE"
		return 0
	else
		return 1
	fi
}

main() {
	declare PORT="$1" ON_STARTUP="$2" AUTH="$3"

	# Set up the environment
	echo "$ON_STARTUP" >> $STARTUP_FILE
	echo "$AUTH" >> $AUTH_FILE

	# Check whether we want to set up authentication
	get_userpass "$AUTH" || USERPASS=""

	# Start up the server on given port, load /server.q
	cd root/ && ./q/l32/q $STARTUP_FILE $USERPASS -p 0.0.0.0:$PORT
}

main "$@"
