################################################################################
######################## Microway Cluster Management Software (MCMS) for OpenHPC
################################################################################
#
# Copyright (c) 2015-2016 by Microway, Inc.
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
# Provide additional capabilities to Bash scripts.
#
# This 'library' script should not be called directly.
# Include it in your scripts with:
#
#    source "/usr/libexec/mcms/include.sh" || (echo "
#
#    Unable to read MCMS script library - does /usr/libexec/mcms/include.sh exist?
#
#    "; exit 1)
#
################################################################################


################################################################################
#
# Bash scripts should include 'tags' describing which library features they wish
# to use. Tags are passed in just as function arguments would be. For example:
#
#    source "/usr/libexec/mcms/include.sh" log verbose
#
#
# The available features are:
#
#  'log'        -- write a log file to /tmp
#                  This log can be copied by calling 'copy_log_file <filename>'
#
#  'verbose'    -- causes Bash to print each line as it runs scripts
#
#  'compilers'  -- utilities for checking compiler versions and setting up
#                  the Bash environment for the requested compiler
#
#  'download'   -- utilities for pulling data down from the Internet
#
#  'no_errors'  -- disable the usual error checking
#                  This is often necessary when calling outside scripts,
#                  as they may not be written for clean/error-free execution.
#
#  'no_exit'    -- disable the trapping of exit codes
#                  This is necessary when MCMS will be called by a login script,
#                  as you don't want your shell to exit when one command fails.
#
#  'numa'       -- probe the local hardware's NUMA abilities/configuration
#
#  'platform'   -- probe the local system for hardware/software details
#
################################################################################

mcms_verbose_logging=""
mcms_disable_error_checks=""
mcms_disable_exit_trap=""
declare -A mcms_tags

for tag in $@; do
    if [[ $tag == "verbose" ]]; then
        mcms_verbose_logging="true"
    elif [[ $tag == "no_errors" ]]; then
        mcms_disable_error_checks="true"
    elif [[ $tag == "no_exit" ]]; then
        mcms_disable_exit_trap="true"
    else
        mcms_tags[${#mcms_tags[@]}]=$tag
    fi
done
if [[ ${#mcms_tags[@]} -eq 0 ]]; then
    mcms_tags[0]="none"
fi


# For the base libraries, ordering matters!
# Later scripts and script libraries will depend on functions defined here:
source "/usr/libexec/mcms/lib.trap.sh"
source "/usr/libexec/mcms/lib.echo.sh"
source "/usr/libexec/mcms/lib.sanity.sh"
source "/usr/libexec/mcms/lib.config.sh"


# Enable the requested library features
for tag in ${mcms_tags[@]}; do
    if [[ $tag == "log" ]]; then
        create_log_file
    elif [[ $tag == "compilers" ]]; then
        source "/usr/libexec/mcms/lib.compilers.sh"
    elif [[ $tag == "download" ]]; then
        source "/usr/libexec/mcms/lib.download.sh"
    elif [[ $tag == "numa" ]]; then
        source "/usr/libexec/mcms/lib.numa.sh"
    elif [[ $tag == "platform" ]]; then
        source "/usr/libexec/mcms/lib.platform.sh"
    fi
done


# Enable aggressive error checking unless it has been explicitly disabled
if [[ -z "$mcms_disable_error_checks" ]]; then
    enable_error_checking
fi


# Enable the trapping of exit codes unless it has been explicitly disabled
if [[ -z "$mcms_disable_exit_trap" ]]; then
    enable_trap_handling
fi


# Enable verbose logging if it has been requested
# This needs to be the last line in this file!!
if [[ -n "$mcms_verbose_logging" ]]; then
    start_verbose_output
fi
