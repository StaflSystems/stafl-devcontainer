#!/bin/bash

# This script should be run upon first user login

# Docker containers derived from stafl-devcontainer may append to this script to install user setup actions.

# correct line endings
find /user-setup-scripts -type f -name '*.sh' | xargs --no-run-if-empty dos2unix
find /user-setup-scripts -type f -name '*.gdbinit' | xargs --no-run-if-empty dos2unix

. /user-setup-scripts/gdb/setup-gdb.sh
. /user-setup-scripts/rtos-views/setup-rtos-views.sh
. /user-setup-scripts/peripheral-viewer/setup-peripheral-viewer.sh
