#!/bin/bash
set -e

./clear-shmem.sh
LD_LIBRARY_PATH=. ./DCA1000EVM_CLI_Control fpga ../../juno-dca1000.json
LD_LIBRARY_PATH=. ./DCA1000EVM_CLI_Control record ../../juno-dca1000.json
LD_LIBRARY_PATH=. ./DCA1000EVM_CLI_Control start_record ../../juno-dca1000.json
