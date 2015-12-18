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
# Provide download capability to Bash scripts.
#
# This 'library' script should not be called directly!
# See the file: include.sh
#
################################################################################


# Library name and version (to provide unique context)
lib_name='download'
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


# Check environment health
mcms_check_exe curl git rm sed


download() {
    local url="$1"
    local filename="$(echo "$url" | sed 's+.*/++')"
    local additional_options=""

    # If a second parameter is specified, use that as the output filename
    if [[ "$#" == "2" ]]; then
        filename="$2"
        additional_options="-o $filename"
    fi

    # Ensure the file doesn't already exist.
    if [[ ! -f "$filename" ]]; then
        curl "$url" $additional_options
    else
        log_info "$filename already exists. Skipping download..."
    fi
}


mcms_git_clone_shallow() {
    local url="$1"
    local additional_options=""

    # If a second parameter is specified, use that as the local directory
    if [[ "$#" == "2" ]]; then
        additional_options=" $2"
    fi

    git clone --depth empty "$url" $additional_options &> mcms_git_error_log.tmp

    # If git experiences errors, the exit handler will kill this script.
    # Thus, if we've gotten this far we don't need the log any more.
    rm -f mcms_git_error_log.tmp
}

