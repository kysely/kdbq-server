#!/usr/bin/env bash

main() {
	declare PORT="$1" ON_STARTUP="$2" USER="$3"

	# Set up the environment
	echo "$ON_STARTUP" >> /server.q
	echo "$USER" >> /userpass.txt

	# Check whether we want to set up authentication
	if [ "$USER" != "" ]; then
		USERPASS="-u /userpass.txt"
	else
		USERPASS=""
	fi

	# Start up the server on given port, load /server.q
	/root/q/l32/q /server.q $USERPASS -p $PORT
}

main "$@"
