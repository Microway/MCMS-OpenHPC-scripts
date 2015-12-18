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
# Provide error-handling capability for Bash scripts.
#
# This 'library' script should not be called directly!
# See the file: include.sh
#
################################################################################


# Library name and version (to provide unique context)
lib_name='trap'
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


# Turn on fairly aggressive error checking for the shell
function enable_error_checking() {
    # Watch for errors throughout pipes (not just the right-most command)
    set -o pipefail

    # Trace errors through 'time' and other functions
    set -o errtrace

    # Exit if an uninitialized variable is referenced
    set -o nounset

    # Exit if any statement returns an error
    set -o errexit
}


# Capture and process exit codes
function enable_trap_handling() {
    # Trap all exits (both with and without errors)
    trap exit_handler EXIT

    # Remap errors and interrupts to exit (to prevent two calls to the handler)
    trap exit ERR INT TERM
}


# Redirect standard out and standard error to a log file
stderr_file=""
function create_log_file() {
    # Ensure duplicate logs aren't created
    if [[ -n "$stderr_file" ]]; then
        return
    fi

    stderr_file=$(mktemp microway_log.XXXXXX --tmpdir)
    exec > >(tee -a $stderr_file)
    exec 2> >(tee -a $stderr_file >&2)
}


# Copy the log file to the specified filename.
function copy_log_file() {
    local filename="$1"

    cp -a $stderr_file $filename
}


# Provide verbose script output as scripts run
function start_verbose_output() {
    # Print commands before executing them (with variable expansion)
    #set -o xtrace

    # Print commands before executing them (without variable expansion)
    # This needs to be the last line in this function!!
    set -o verbose
}
function stop_verbose_output() {
    set +o verbose
}


# Execute the specified commands without verbose output
function quiet() {
    local commands="$*"

    set +o verbose
    eval $commands
    set -o verbose
}


function exit_handler() {
    local error_code="$?"
    stop_verbose_output

    if [[ $error_code == 0 ]]; then
        # No errors were encountered - remove the stderr log file
        [[ -f "$stderr_file" ]] && rm -f $stderr_file

        return 0;
    fi

    if [[ -n "$stderr_file" ]]; then
        echo "

########################### MCMS: Error Detected ###############################
#
# Error messages have been logged. See log file for details:
# $stderr_file
#
################################################################################

" >&2
    else
        echo "

########################### MCMS: Error Detected ###############################

" >&2
    fi

    if [[ -n "${mcms_tmp_build_dir:-}" ]]; then
        echo "

The failed build has been preserved in:
$mcms_tmp_build_dir

You will need to manually remove this directory.

" >&2
    fi

    exit $error_code
}
