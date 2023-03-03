#!/bin/bash
# https://stackoverflow.com/questions/2143404/delete-all-system-v-shared-memory-and-semaphores-on-unix-like-systems
set -e

USER=`whoami`

IPCS_M=`ipcs -m | egrep "0x[0-9a-f]+ [0-9]+" | grep $USER | cut -f2 -d" "`

for id in $IPCS_M; do
  ipcrm -v -m $id
done
