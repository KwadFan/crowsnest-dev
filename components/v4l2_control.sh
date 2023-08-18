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

cn_set_array_name() {
    local array_name
    array_name="CN_CAM_${1}_V4L2CTL_ARRAY"
    printf "%s" "${array_name}"
}

cn_set_array() {
    local array_name cam values
    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        array_name="$(cn_set_array_name "${cam}")"
        IFS="," readarray -t values "$(cn_truncate_spaces "${cam}")"

        declare -ga  "${array_name/\'/}=(${values[*]})"
    done
}

cn_truncate_spaces() {
    local fields
    fields="$(echo "CN_CAM_${1}_V4L2CTL" | tr -d ' ')"
    printf "%s" "${fields}"
}

cn_init_v4l2_ctl() {

    cn_set_array

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
