#!/usr/bin/env bash

#### hw_uvc_dev.sh - V4L2 UVC related stuff (USB Cameras)

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

CN_UVC_BY_ID=()
CN_UVC_BY_PATH=()
CN_UVC_VALID_DEVICES=()

get_uvc_by_id_path() {
    local by_id avail
    avail="$(find /dev/v4l/by-id/ -iname "*index0" 2> /dev/null)"
    for by_id in ${avail}; do
        CN_UVC_BY_ID+=( "${by_id}" )
    done

    if [[ "${#CN_UVC_BY_ID[@]}" != "0" ]]; then
        declare -gar CN_UVC_BY_ID
    fi
}

get_uvc_by_path_path() {
    local by_path avail
    avail="$(find /dev/v4l/by-path/ -iname "*index0" 2> /dev/null \
        | sed '/.*isp.*/d; /.*codec.*/d; /.*csi.*/d' )"
    for by_path in ${avail}; do
        CN_UVC_BY_PATH+=( "${by_path}" )
    done

    if [[ "${#CN_UVC_BY_PATH[@]}" != "0" ]]; then
        declare -gar CN_UVC_BY_PATH
    fi
}

cn_assign_valid_array() {
    local cam
    for cam in "${CN_UVC_BY_ID[@]}" "${CN_UVC_BY_PATH[@]}"; do
        CN_UVC_VALID_DEVICES+=( "${cam}" )
    done
    declare -gar CN_UVC_VALID_DEVICES
}


cn_init_hw_uvc() {

    get_uvc_by_id_path

    get_uvc_by_path_path

    cn_assign_valid_array

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "hw_uvc_dev:\n###########\n"
        declare -p | grep "CN_UVC"
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: hw_uvc_dev.sh\n"
fi



# avail="$(find /dev/v4l/by-id/ -iname "*index0" 2> /dev/null)"
