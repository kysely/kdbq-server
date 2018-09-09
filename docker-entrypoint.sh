#!/usr/bin/env bash

echo "$2" >> /server.q
echo "$3" >> /userpass.txt

USERPASS=""
if [ "$3" != "" ]; then
	USERPASS="-u /userpass.txt"
fi

/root/q/l32/q /server.q $USERPASS -p $1
