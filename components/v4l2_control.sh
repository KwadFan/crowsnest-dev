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

cn_truncate_spaces() {
    local fields var
    var="CN_CAM_${1}_V4L2CTL"
    fields="$(echo "${!var}" | tr -d ' ')"
    printf "%s" "${fields}"
}

cn_get_v4l2ctl_values() {
    local val var
    var="CN_CAM_${1}_V4L2CTL"
    val="${!var/ /}"
    printf "%s" "${val}"
}

cn_set_array() {
    local array_name cam #value values target
    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        array_name="$(cn_get_array_name "${cam}")"
        array_name="${array_name/\'/}"
        # while read value; do
        #     IFS="," values+=("${value}")

        # done < <(cn_truncate_spaces "${cam}")
        # unset "${IFS}"

        # declare -n target="${array_name/\'/}"
        # for x in "${values[@]}"; do
        #     target+=("${x}")
        # done

        declare -g "${array_name}=( foo )"
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



# for var in $(cn_get_config "${section}" "${prefix}"); do
#         var_name="${var}"
#         var="${var/${prefix}/}"
#         var="${var,,}"
#         config+=("${var_name}=$(cn_get_param "${section}" "${var}")")
#     done

#     for expose_var in "${config[@]}"; do
#         expose_var="$(echo "${expose_var}" | tr -d "'")"
#         declare -g -r "${expose_var}"
#     done
