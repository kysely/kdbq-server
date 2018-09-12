#!/usr/bin/env bash

get_userpass() {
	if [ "$1" != "" ]; then
		USERPASS="-u /userpass.txt"
		return 0
	else
		return 1
	fi
}

main() {
	declare PORT="$1" ON_STARTUP="$2" AUTH="$3"

	# Set up the environment
	echo "$ON_STARTUP" >> /server.q
	echo "$AUTH" >> /userpass.txt

	# Check whether we want to set up authentication
	get_userpass "$AUTH" || USERPASS=""

	# Start up the server on given port, load /server.q
	/root/q/l32/q /server.q $USERPASS -p 0.0.0.0:$PORT
}

main "$@"
