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
# Allow Bash scripts to determine details about the platforms they are running
# upon (such as server model, CPU type and speed, memory capacity and speed,
# PCI-Express devices, storage devices, Linux distro and version, etc.).
#
# This 'library' script should not be called directly!
# See the file: include.sh
#
################################################################################


# Library name and version (to provide unique context)
lib_name='platform'
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
mcms_check_exe dmidecode grep uname


mcms_cpufile=/proc/cpuinfo
if [[ ! -f $mcms_cpufile ]]; then
    log_error "Error - unable to read CPU info file: $mcms_cpufile"
fi


declare -A mcms_platform

# These are the 'built-in' values available from dmidecode.
# Shelling out this many times is too much, but it's a start.
# Because most interesting values aren't listed, we'll have to parse the full
# dump from dmidecode and try to intelligently pull out the good bits.
mcms_platform['bios-vendor']=$(dmidecode --string bios-vendor)
mcms_platform['bios-version']=$(dmidecode --string bios-version)
mcms_platform['bios-release-date']=$(dmidecode --string bios-release-date)
mcms_platform['system-manufacturer']=$(dmidecode --string system-manufacturer)
mcms_platform['system-product-name']=$(dmidecode --string system-product-name)
mcms_platform['system-version']=$(dmidecode --string system-version)
mcms_platform['system-serial-number']=$(dmidecode --string system-serial-number)
mcms_platform['system-uuid']=$(dmidecode --string system-uuid)
mcms_platform['baseboard-manufacturer']=$(dmidecode --string baseboard-manufacturer)
mcms_platform['baseboard-product-name']=$(dmidecode --string baseboard-product-name)
mcms_platform['baseboard-version']=$(dmidecode --string baseboard-version)
mcms_platform['baseboard-serial-number']=$(dmidecode --string baseboard-serial-number)
mcms_platform['baseboard-asset-tag']=$(dmidecode --string baseboard-asset-tag)
mcms_platform['chassis-manufacturer']=$(dmidecode --string chassis-manufacturer)
mcms_platform['chassis-type']=$(dmidecode --string chassis-type)
mcms_platform['chassis-version']=$(dmidecode --string chassis-version)
mcms_platform['chassis-serial-number']=$(dmidecode --string chassis-serial-number)
mcms_platform['chassis-asset-tag']=$(dmidecode --string chassis-asset-tag)
mcms_platform['processor-family']=$(dmidecode --string processor-family)
mcms_platform['processor-manufacturer']=$(dmidecode --string processor-manufacturer)
mcms_platform['processor-version']=$(dmidecode --string processor-version)
mcms_platform['processor-frequency']=$(dmidecode --string processor-frequency)

mcms_platform['full_dmidecode']=$(dmidecode)


################################################################################
#
# The values below are used to set reasonable defaults when compiling and
# configuring math libraries and certain applications (such as OpenBLAS).
# Some require recompiles; some can be over-ridden at runtime.
#
#
# If the cluster is heterogeneous (not all nodes match), then different compiles
# with different settings may be needed. It is possible to use an environment
# variable to override the auto-detected setting:
#
#   MCMS_CPU_ARCHITECTURE
#
################################################################################

# We'll get a generic value from uname and then attempt to fine-tune it.
#
# Returns processor type or "unknown"
mcms_platform['machine-type']=$(uname --processor)
mcms_platform['processor-architecture']=${mcms_platform['machine-type']}

mcms_detected_arch=$(/usr/libexec/mcms/mcms_detect_cpu_architecture)
if [[ -n "$mcms_detected_arch" ]]; then
    mcms_platform['processor-architecture']=$mcms_detected_arch
fi


# Check if the user desires a manual override
if [[ -n "$MCMS_CPU_ARCHITECTURE" ]]; then
    mcms_platform['processor-architecture']=$MCMS_CPU_ARCHITECTURE

    log_info "

    Manual override detected - CPU architecture has been set to:
        $MCMS_CPU_ARCHITECTURE

    Note that many tools auto-detect the processor architecture. For some builds
    this override will not be fully effective (e.g. optimizations not supported
    by the CPU in the build machine will not be enabled).

"
else
    log_info "

    Auto-detected CPU architecture:
        ${mcms_platform['processor-architecture']}
    Override by setting MCMS_CPU_ARCHITECTURE

    "
fi


wait_for_user_to_read_message

