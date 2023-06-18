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

CN_VALID_DEVICES=()

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

cn_assign_valid_array() {
    local cam
    for cam in "${CN_UVC_BY_ID[@]}" "${CN_UVC_BY_PATH[@]}"; do
        CN_VALID_DEVICES+=( "${cam}" )
    done
    declare -gar CN_VALID_DEVICES
}


cn_init_hw_uvc() {

    get_uvc_by_id_path

    cn_assign_valid_array
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: hw_uvc_dev.sh.sh\n"
fi



# avail="$(find /dev/v4l/by-id/ -iname "*index0" 2> /dev/null)"
