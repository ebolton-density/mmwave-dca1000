#!/bin/bash

# Get the command string
COMMAND_STRING=DCA1000EVM_CLI_Record

# Fetching PIDs associated with the command string
PIDS=$(ps aux | grep "$COMMAND_STRING" | grep -v grep | awk '{print $2}')

# Checking if there are any PIDs associated with the command string
if [ -z "$PIDS" ]; then
    echo "No processes found with the command string: $COMMAND_STRING"
    exit 1
fi

# Killing the processes
for pid in $PIDS
do
    echo "Killing process: $pid"
    kill -9 $pid
done

echo "All processes associated with the command string: $COMMAND_STRING are killed."
clear-shmem.sh
