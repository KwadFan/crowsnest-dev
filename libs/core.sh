#!/bin/bash

#### Core library

#### crowsnest - A webcam Service for multiple Cams and Stream Services.
####
#### Written by Stephan Wendel aka KwadFan <me@stephanwe.de>
#### Copyright 2021
#### https://github.com/mainsail-crew/crowsnest
####
#### This File is distributed under GPLv3
####

# shellcheck enable=require-variable-braces

# Exit upon Errors
set -Ee

## Version of crowsnest


# Init Traps

# Behavior of traps
# log_msg, see libs/logging.sh L#46

# Print Error Code and Line to Log
# and kill running jobs


# Print Goodbye Message
# and kill running jobs


## Sanity Checks
# Dependency Check
# call check_dep <programm>, ex.: check_dep vim
function

function check_apps {
    local cstreamer ustreamer
    ustreamer="bin/ustreamer/ustreamer"
    cstreamer="bin/camera-streamer/camera-streamer"

    if [[ -x "${BASE_CN_PATH}/${ustreamer}" ]]; then
        log_msg "Dependency: '${ustreamer##*/}' found in ${ustreamer}."
    else
        log_msg "Dependency: '${ustreamer##*/}' not found. Exiting!"
        exit 1
    fi

    ## Avoid dependency check if non rpi sbc
    if [[ "$(is_raspberry_pi)" = "1" ]] && [[ "$(is_ubuntu_arm)" = "0" ]]; then
        if [[ -x "${BASE_CN_PATH}/${cstreamer}" ]]; then
            log_msg "Dependency: '${cstreamer##*/}' found in ${cstreamer}."
        else
            log_msg "Dependency: '${cstreamer##*/}' not found. Exiting!"
            exit 1
        fi
    fi
}

# Check all needed Dependencies
# If pass print your set configfile to log.
# print_cfg, see libs/logging.sh L#75
# pint_cams, see libs/logging.sh L#84
function initial_check {
    log_msg "INFO: Checking Dependencys"
    check_dep "crudini"
    check_dep "find"
    check_dep "xargs"
    check_apps
    versioncontrol
    # print cfg if ! "${CROWSNEST_LOG_LEVEL}": quiet
    if [ -z "$(check_cfg "${CROWSNEST_CFG}")" ]; then
        if [[ "${CROWSNEST_LOG_LEVEL}" != "quiet" ]]; then
            print_cfg
        fi
    fi
    log_msg "INFO: Detect available Devices"
    print_cams
    return
}
