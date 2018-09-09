#!/usr/bin/env bash

echo "$2" >> /server.q

/root/q/l32/q /server.q -p "$1"
