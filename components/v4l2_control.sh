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

cn_get_v4l2ctl_array_name() {
    local array_name
    array_name="CN_CAM_${1}_V4L2CTL_ARRAY"
    printf "%s" "${array_name}"
}


cn_get_v4l2ctl_values() {
    local var values
    var="CN_CAM_${1}_V4L2CTL"
    values="$(echo "${!var}" | tr -d ' ')"
    values="${values/\,/ }"
    printf "%s\n" "${values}"
}

cn_set_v4l2ctl_array() {
    local array_name cam
    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        array_name="$(cn_get_v4l2ctl_array_name "${cam}")"
        array_name="${array_name/\'/}"
        declare -ag "${array_name}"
        declare -n target_array="${array_name}"
        for x in $(cn_get_v4l2ctl_values "${cam}") ; do
            target_array+=("${x}")
        done
        readonly -a "${array_name}"
    done
}

cn_set_v4l2ctl_bin_path() {
    local bin_path
    bin_path="$(command -v v4l2-ctl)"
    [[ -n "${bin_path}" ]] || bin_path="null"
    CN_V4L2CTL_BIN_PATH="${bin_path}"
    # shellcheck disable=SC2034
    declare -gr CN_V4L2CTL_BIN_PATH
}

cn_get_v4l2ctl_value() {
    local device value valueless
    device="${1,,}"
    value="${2,,}"
    valueless="$(echo "${value}" | cut -f1 -d"=")"
    is_value="$("${CN_V4L2CTL_BIN_PATH}" -d "${device}" --get-ctrl "${valueless}")"
    is_value="${is_value/\: /=}"
    printf "%s\n" "${is_value}"
}

cn_set_v4l2ctl_value() {
    local device value
    device="${1,,}"
    value="${2,,}"
    is_value="$(cn_get_v4l2ctl_value "${device}" "${value}")"
    printf "%s\n" "${is_value}"
}

cn_init_v4l2ctl() {

    cn_set_v4l2ctl_bin_path

    cn_set_v4l2ctl_array

    #test
    cn_get_v4l2ctl_value "/dev/video0" "fooo"

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "v4l2_control:\n###########\n"
        printf "Configured cams: %s\n" "${CN_CONFIGURED_CAMS[@]}"
        declare -p | grep "CN_V4L2CTL_BIN_PATH"
        declare -p | grep "CN_CAM_.*_V4L2CTL"
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: v4l2_control.sh\n"
fi
