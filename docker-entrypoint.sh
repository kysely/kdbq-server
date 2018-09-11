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
	declare PORT="$1" ON_STARTUP="$2" USER="$3"

	# Set up the environment
	echo "$ON_STARTUP" >> /server.q
	echo "$USER" >> /userpass.txt

	# Check whether we want to set up authentication
	get_userpass "$USER" || USERPASS=""

	# Start up the server on given port, load /server.q
	/root/q/l32/q /server.q $USERPASS -p $PORT
}

main "$@"
