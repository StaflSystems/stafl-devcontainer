#!/bin/bash

# This script should be run upon first user login

# Docker containers derived from stafl-devcontainer may append to this script to install user setup actions.

# correct line endings
find -path '/user-setup-scripts/*' | xargs dos2unix

# begin stafl-devcontainer
. /user-setup-scripts/gdb/setup-gdb.sh
# end stafl-devcontainer
