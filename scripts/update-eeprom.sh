#!/bin/bash
set -e

CONFIG_FILE=$1

export LD_LIBRARY_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export PATH=$LD_LIBRARY_PATH:$PATH

DCA1000EVM_CLI_Control eeprom $CONFIG_FILE
