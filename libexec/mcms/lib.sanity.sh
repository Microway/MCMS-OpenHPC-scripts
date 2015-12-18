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
# Allow Bash scripts to check the sanity of their environment before running.
#
# This 'library' script should not be called directly!
# See the file: include.sh
#
################################################################################


# Library name and version (to provide unique context)
lib_name='sanity'
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


# Check for a particular Warewulf system image
function mcms_check_vnfs() {
    mcms_node_vnfs_name=$1

    # Need the '|| true' to prevent grep from erroring when there are zero matches
    mcms_vnfs_entry=$(wwsh vnfs list | grep "$mcms_node_vnfs_name" || true)
    mcms_node_vnfs_dir=$(echo $mcms_vnfs_entry | awk '{print $3}')

    if [[ -z "$mcms_node_vnfs_dir" ]]; then
        log_error "

'mcms_node_vnfs_name' $mcms_node_vnfs_name does not appear to be a valid VNFS!

Double-check the output of:

  wwsh vnfs list

"
    fi

    if [[ ! -d "$mcms_node_vnfs_dir" ]]; then
        log_error "

'mcms_node_vnfs_dir' $mcms_node_vnfs_dir does not exist!

Double-check the output of:

  wwsh vnfs list

"
    fi
}


#
# Allow scripts to check for suitable executables ahead of time. This prevents
# them from halting mid-way when one of the required tools is not present.
#
function mcms_check_exe() {
    executables=$@

    for exe in $executables; do
        which $exe 1> /dev/null

        # Check if the executable was successfully located.
        if [[ $? -gt 0 ]]; then
            # When 'which' fails, it prints some output - add padding
            log_error "

The utility '$exe' was not found! Unable to continue.

"
        fi
    done
}


