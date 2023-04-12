#!/bin/sh
set -e

CONFIG_FILE=$1

export LD_LIBRARY_PATH=.
export PATH=.:$PATH

./clear-shmem.sh
DCA1000EVM_CLI_Control fpga $CONFIG_FILE
DCA1000EVM_CLI_Control record $CONFIG_FILE
DCA1000EVM_CLI_Control start_record $CONFIG_FILE -q
