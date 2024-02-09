#!/bin/bash

# This script should be run upon first user login

# Docker containers derived from stafl-devcontainer may append to this script to install user setup actions.

# correct line endings
find -path '/user-setup-scripts/*.sh' | xargs dos2unix
find -path '/user-setup-scripts/*.gdbinit' | xargs dos2unix

. /user-setup-scripts/gdb/setup-gdb.sh
. /user-setup-scripts/rtos-views/setup-rtos-views.sh
