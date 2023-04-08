#!/bin/sh
set -e

CONFIG_FILE=$1

export LD_LIBRARY_PATH=.
export PATH=.:$PATH

DCA1000EVM_CLI_Control eeprom $CONFIG_FILE
