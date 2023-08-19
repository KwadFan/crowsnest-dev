#!/usr/bin/env bash

#### v4l2_control.sh - determine crowsnest local version

#### crowsnest - A webcam Service for multiple Cams and Stream Services.
####
#### Written by Stephan Wendel aka KwadFan <me@stephanwe.de>
#### Copyright 2021 - till today
#### https://github.com/mainsail-crew/crowsnest
####
#### This File is distributed under GPLv3
####

# shellcheck enable=require-variable-braces

# Exit upon Errors
set -Ee

cn_get_array_name() {
    local array_name
    array_name="CN_CAM_${1}_V4L2CTL_ARRAY"
    printf "%s" "${array_name}"
}


cn_get_v4l2ctl_values() {
    local var
    local -a values
    var="CN_CAM_${1}_V4L2CTL"
    while IFS=',' read value; do
        values+="${value}"
    done < <(echo "${!var}" | tr -d ' ')
    printf "%s\n" "${values}"
    unset "${IFS}"
}

cn_set_array() {
    local array_name cam
    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        array_name="$(cn_get_array_name "${cam}")"
        array_name="${array_name/\'/}"
        declare -ag "${array_name}"
        declare -n target_array="${array_name}"
        for x in $(cn_get_v4l2ctl_values "${cam}") ; do
            target_array+=("${x}")
        done
    done
}

cn_init_v4l2_ctl() {

    cn_set_array

    cn_get_v4l2ctl_values "1"

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "v4l2_control:\n###########\n"
        printf "Configured cams: %s\n" "${CN_CONFIGURED_CAMS[@]}"
        declare -p | grep "CN_CAM_.*_V4L2CTL"
        declare -p | grep "CN_CAM_.*_V4L2CTL_ARRAY"
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: v4l2_control.sh\n"
fi
