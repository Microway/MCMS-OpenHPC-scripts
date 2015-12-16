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
# Allow Bash scripts to check and configure multi-CPU (NUMA) parameters. When
# testing HPC performance, it is quite common to require information about the
# underlying platform (such as number of CPU cores). It can also be necessary to
# lock processes to particular CPU cores.
#
# This 'library' script should not be called directly!
# See the file: include.sh
#
################################################################################


# Library name and version (to provide unique context)
lib_name='numa'
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
mcms_check_exe grep sort wc


mcms_cpufile=/proc/cpuinfo
if [[ ! -f $mcms_cpufile ]]; then
    log_error "Error - unable to read CPU info file: $mcms_cpufile"
fi


################################################################################
#
# The values below are used to set reasonable defaults when compiling and
# configuring math libraries and certain applications (such as OpenBLAS and
# TeraChem). Some require recompiles; some can be over-ridden at runtime.
#
# If the cluster is heterogeneous (not all nodes match), then different compiles
# with different settings may be needed. It is possible to use an environment
# variable to override the auto-detected setting:
#
#   MCMS_CPU_SOCKET_COUNT
#   MCMS_CPU_CORE_COUNT
#
################################################################################

declare -A mcms_numa
mcms_numa['cpu_sockets']=$(grep "physical id" $mcms_cpufile | sort -u | wc -l)
mcms_numa['logical_cores']=$(grep -c "processor" $mcms_cpufile)
mcms_numa['cores_per_socket']=$(grep "core id" $mcms_cpufile | sort -u | wc -l)


# Check if the user desires any manual overrides
if [[ -n "$MCMS_CPU_SOCKET_COUNT" ]]; then
    mcms_numa['cpu_sockets']=$MCMS_CPU_SOCKET_COUNT

    log_info "

    Manual override detected - CPU socket count has been set to:
        $MCMS_CPU_SOCKET_COUNT

    "
else
    log_info "

    Auto-detected CPU socket count:
        ${mcms_numa['cpu_sockets']}
    Override by setting MCMS_CPU_SOCKET_COUNT

    "
fi

if [[ -n "$MCMS_CPU_CORE_COUNT" ]]; then
    mcms_numa['cores_per_socket']=$MCMS_CPU_CORE_COUNT

    log_info "

    Manual override detected - CPU core count has been set to:
        $MCMS_CPU_CORE_COUNT

    "
else
    log_info "

    Auto-detected CPU core count:
        ${mcms_numa['cores_per_socket']}
    Override by setting MCMS_CPU_CORE_COUNT

    "
fi


# Set the total system CPU core count using the values that were given above
mcms_numa['usable_cores']=$(( ${mcms_numa['cores_per_socket']} * ${mcms_numa['cpu_sockets']} ))

log_info "

    Total CPU core count: ${mcms_numa['usable_cores']}

"

