################################################################################
######################## Microway Cluster Management Software (MCMS) for OpenHPC
################################################################################
#
# Copyright (c) 2015 by Microway, Inc.
#
# This file is part of Microway Cluster Management Software (MCMS) for OpenHPC.
#
#    MCMS for OpenHPC is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    MCMS for OpenHPC is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with MCMS.  If not, see <http://www.gnu.org/licenses/>
#
################################################################################


################################################################################
#
# Provide lock file capability for Bash scripts.
#
# This 'library' script should not be called directly!
# See the file: include.sh
#
################################################################################


# Library name and version (to provide unique context)
lib_name='lockfile'
lib_version='20151215'

# Ensure this library is only sourced a single time
if [[ ${microway_libs[$lib_name]+isset} = isset ]]; then
    return 0
else
    if [[ ${#microway_libs[@]} == 0 ]]; then
        declare -A microway_libs
    fi
    microway_libs[$lib_name]=${lib_name}_${lib_version}
fi


#
# Exit handler which cleans up for scripts that have received a lock.
# This ensures that the lock they received is properly cleaned up.
#
mcms_exit_handler() {
    local error_code="$?"

    # Remove the lock file
    if [[ -n "$MCMS_RECEIVED_LOCK" ]]; then
        rm -f /dev/shm/.${MCMS_LOCKFILE}.lock
    fi
    unset MCMS_RECEIVED_LOCK

    exit $error_code
}


#
# Attempt to get a lock on the specified lock file.
#
# If the lock cannot be obtained, then MCMS_LOCKFILE will be unset and the caller
# should take the appropriate action (either waiting for the lock or giving up).
#
mcms_get_lock() {
    # The calling script needs to have already defined MCMS_LOCKFILE
    if [[ -z "$MCMS_LOCKFILE" ]]; then
        echo "MCMS_LOCKFILE must be defined before attempting to create a lock"
        exit 1
    fi


    if [[ -f $MCMS_LOCKFILE ]]; then
        unset MCMS_RECEIVED_LOCK
    else
        echo > /dev/shm/.${MCMS_LOCKFILE}.lock
        MCMS_RECEIVED_LOCK=1

        # Trap all exits (both with and without errors)
        trap mcms_exit_handler EXIT

        # Remap errors and interrupts to exit (to prevent two calls to the handler)
        trap exit ERR INT TERM
    fi
}

