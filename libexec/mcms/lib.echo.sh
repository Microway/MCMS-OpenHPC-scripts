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
# Provide user-friendly output capability for Bash scripts.
#
# This 'library' script should not be called directly!
# See the file: include.sh
#
################################################################################


# Library name and version (to provide unique context)
lib_name='echo'
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


function log_info() {
    local message="$*"
    local orig_IFS=$IFS
    IFS=$'\n'

    while read -r line; do
        echo -e "# MCMS: $line"
    done <<< "$message"

    IFS=$orig_IFS
}

function log_warning() {
    local message="$*"

    echo
    echo
    echo "############################# MCMS Warning Message #############################"
    echo -e "$message"
    echo "################################################################################"
    echo
}

function log_error() {
    local message="$*"

    echo
    echo
    echo "############################# MCMS Error Message ###############################"
    echo -e "$message"
    echo "################################################################################"
    echo

    exit 1
}


function wait_for_user_to_read_message() {
    sleep 3s
}

# Convert a number of seconds into a 'pretty' time estimate
function get_pretty_time() {
    seconds=$1

    if [[ $seconds -gt $(( 365 * 24 * 60 * 60 )) ]]; then
        echo "more than a year"
    elif [[ $seconds -gt $(( 350 * 24 * 60 * 60 )) ]]; then
        echo "about a year"
    elif [[ $seconds -gt $(( 11 * 30 * 24 * 60 * 60 )) ]]; then
        echo "about 11 months"
    elif [[ $seconds -gt $(( 10 * 30 * 24 * 60 * 60 )) ]]; then
        echo "about 10 months"
    elif [[ $seconds -gt $(( 9 * 30 * 24 * 60 * 60 )) ]]; then
        echo "about 9 months"
    elif [[ $seconds -gt $(( 8 * 30 * 24 * 60 * 60 )) ]]; then
        echo "about 8 months"
    elif [[ $seconds -gt $(( 7 * 30 * 24 * 60 * 60 )) ]]; then
        echo "about 7 months"
    elif [[ $seconds -gt $(( 6 * 30 * 24 * 60 * 60 )) ]]; then
        echo "about 6 months"
    elif [[ $seconds -gt $(( 5 * 30 * 24 * 60 * 60 )) ]]; then
        echo "about 5 months"
    elif [[ $seconds -gt $(( 4 * 30 * 24 * 60 * 60 )) ]]; then
        echo "about 4 months"
    elif [[ $seconds -gt $(( 3 * 30 * 24 * 60 * 60 )) ]]; then
        echo "about 3 months"
    elif [[ $seconds -gt $(( 2 * 30 * 24 * 60 * 60 )) ]]; then
        echo "about 2 months"
    elif [[ $seconds -gt $(( 45 * 24 * 60 * 60 )) ]]; then
        echo "a month and a half"
    elif [[ $seconds -gt $(( 31 * 24 * 60 * 60 )) ]]; then
        echo "about a month"
    # Break down any time less than 31 days
    else
        if [[ $seconds -gt $(( 27 * 24 * 60 * 60 )) ]]; then
            echo "less than a month"
        elif [[ $seconds -gt $(( 21 * 24 * 60 * 60 )) ]]; then
            echo "about three weeks"
        elif [[ $seconds -gt $(( 14 * 24 * 60 * 60 )) ]]; then
            echo "about two weeks"
        elif [[ $seconds -gt $(( 7 * 24 * 60 * 60 )) ]]; then
            echo "just over a week"
        # Break down any time less than 7 days
        else
            if [[ $seconds -gt $(( 6 * 24 * 60 * 60 )) ]]; then
                echo "less than a week"
            elif [[ $seconds -gt $(( 5 * 24 * 60 * 60 )) ]]; then
                echo "about 5 days"
            elif [[ $seconds -gt $(( 4 * 24 * 60 * 60 )) ]]; then
                echo "about 4 days"
            elif [[ $seconds -gt $(( 3 * 24 * 60 * 60 )) ]]; then
                echo "about 3 days"
            elif [[ $seconds -gt $(( 2 * 24 * 60 * 60 )) ]]; then
                echo "about 2 days"
            elif [[ $seconds -gt $(( 1 * 24 * 60 * 60 )) ]]; then
                echo "about a day"
            # Break down any time less than one day
            else
                if [[ $seconds -gt $(( 23 * 60 * 60 )) ]]; then
                    echo "less than a day"
                elif [[ $seconds -gt $(( 22 * 60 * 60 )) ]]; then
                    echo "about 22 hours"
                elif [[ $seconds -gt $(( 21 * 60 * 60 )) ]]; then
                    echo "about 21 hours"
                elif [[ $seconds -gt $(( 20 * 60 * 60 )) ]]; then
                    echo "about 20 hours"
                elif [[ $seconds -gt $(( 19 * 60 * 60 )) ]]; then
                    echo "about 19 hours"
                elif [[ $seconds -gt $(( 18 * 60 * 60 )) ]]; then
                    echo "about 18 hours"
                elif [[ $seconds -gt $(( 17 * 60 * 60 )) ]]; then
                    echo "about 17 hours"
                elif [[ $seconds -gt $(( 16 * 60 * 60 )) ]]; then
                    echo "about 16 hours"
                elif [[ $seconds -gt $(( 15 * 60 * 60 )) ]]; then
                    echo "about 15 hours"
                elif [[ $seconds -gt $(( 14 * 60 * 60 )) ]]; then
                    echo "about 14 hours"
                elif [[ $seconds -gt $(( 13 * 60 * 60 )) ]]; then
                    echo "about 13 hours"
                elif [[ $seconds -gt $(( 12 * 60 * 60 )) ]]; then
                    echo "about 12 hours"
                elif [[ $seconds -gt $(( 11 * 60 * 60 )) ]]; then
                    echo "about 11 hours"
                elif [[ $seconds -gt $(( 10 * 60 * 60 )) ]]; then
                    echo "about 10 hours"
                elif [[ $seconds -gt $(( 9 * 60 * 60 )) ]]; then
                    echo "about 9 hours"
                elif [[ $seconds -gt $(( 8 * 60 * 60 )) ]]; then
                    echo "about 8 hours"
                elif [[ $seconds -gt $(( 7 * 60 * 60 )) ]]; then
                    echo "about 7 hours"
                elif [[ $seconds -gt $(( 6 * 60 * 60 )) ]]; then
                    echo "about 6 hours"
                elif [[ $seconds -gt $(( 5 * 60 * 60 )) ]]; then
                    echo "about 5 hours"
                elif [[ $seconds -gt $(( 4 * 60 * 60 )) ]]; then
                    echo "about 4 hours"
                elif [[ $seconds -gt $(( 3 * 60 * 60 )) ]]; then
                    echo "about 3 hours"
                elif [[ $seconds -gt $(( 2 * 60 * 60 )) ]]; then
                    echo "about 2 hours"
                elif [[ $seconds -gt $(( 1 * 60 * 60 )) ]]; then
                    echo "about 1 hour"
                # Break down any time less than an hour
                else
                    if [[ $seconds -gt $(( 45 * 60 )) ]]; then
                        echo "less than an hour"
                    elif [[ $seconds -gt $(( 30 * 60 )) ]]; then
                        echo "about half an hour"
                    elif [[ $seconds -gt $(( 20 * 60 )) ]]; then
                        echo "less than half an hour"
                    elif [[ $seconds -gt $(( 19 * 60 )) ]]; then
                        echo "19 minutes"
                    elif [[ $seconds -gt $(( 18 * 60 )) ]]; then
                        echo "18 minutes"
                    elif [[ $seconds -gt $(( 17 * 60 )) ]]; then
                        echo "17 minutes"
                    elif [[ $seconds -gt $(( 16 * 60 )) ]]; then
                        echo "16 minutes"
                    elif [[ $seconds -gt $(( 15 * 60 )) ]]; then
                        echo "15 minutes"
                    elif [[ $seconds -gt $(( 14 * 60 )) ]]; then
                        echo "14 minutes"
                    elif [[ $seconds -gt $(( 13 * 60 )) ]]; then
                        echo "13 minutes"
                    elif [[ $seconds -gt $(( 12 * 60 )) ]]; then
                        echo "12 minutes"
                    elif [[ $seconds -gt $(( 11 * 60 )) ]]; then
                        echo "11 minutes"
                    elif [[ $seconds -gt $(( 10 * 60 )) ]]; then
                        echo "10 minutes"
                    elif [[ $seconds -gt $(( 9 * 60 )) ]]; then
                        echo "9 minutes"
                    elif [[ $seconds -gt $(( 8 * 60 )) ]]; then
                        echo "8 minutes"
                    elif [[ $seconds -gt $(( 7 * 60 )) ]]; then
                        echo "7 minutes"
                    elif [[ $seconds -gt $(( 6 * 60 )) ]]; then
                        echo "6 minutes"
                    elif [[ $seconds -gt $(( 5 * 60 )) ]]; then
                        echo "5 minutes"
                    elif [[ $seconds -gt $(( 4 * 60 )) ]]; then
                        echo "4 minutes"
                    elif [[ $seconds -gt $(( 3 * 60 )) ]]; then
                        echo "3 minutes"
                    elif [[ $seconds -gt $(( 2 * 60 )) ]]; then
                        echo "2 minutes"
                    elif [[ $seconds -gt $(( 1 * 60 )) ]]; then
                        echo "1 minute"
                    else
                        echo "less than a minute"
                    fi
                fi
            fi
        fi
    fi
}

