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

cn_get_uvc_path_by() {
    local path_type
    path_type="${1}"
    if ! find /dev/v4l/by-"${path_type}"/ -iname "*index0" 2> /dev/null; then
        printf "null"
    fi
}

cn_get_uvc_by_path_paths() {
    # strip out CSI, codecs and ISP's
    if [[ "${CN_UVC_BY_ID[0]}" != "null" ]]; then
        cn_get_uvc_path_by "path" | sed '/.*isp.*/d; /.*codec.*/d; /.*csi.*/d'
    else
        printf "null"
    fi
}

cn_set_uvc_by_id_paths() {
    local by_id avail
    avail="$(cn_get_uvc_path_by "id")"
    for by_id in ${avail}; do
        CN_UVC_BY_ID+=( "${by_id}" )
    done

    if [[ "${#CN_UVC_BY_ID[@]}" != "0" ]]; then
        declare -gar CN_UVC_BY_ID
    fi
}

cn_set_uvc_by_path_paths() {
    local by_path
    for by_path in $(cn_get_uvc_by_path_paths); do
        CN_UVC_BY_PATH+=( "${by_path}" )
    done

    if [[ "${#CN_UVC_BY_PATH[@]}" != "0" ]]; then
        declare -gar CN_UVC_BY_PATH
    fi
}

cn_get_alternate_valid_path() {
    local alternate_path
    local -a path
    path=()
    if [[ "${#CN_UVC_BY_PATH[@]}" != "0" ]]; then
        for alternate_path in $(cn_get_uvc_by_path_paths); do
            path+=("$(readlink "${alternate_path}" | sed 's/^\.\.\/\.\./\/dev/')")
        done
        echo "${path[@]}"
    fi
}

cn_set_alternate_valid_path() {
    local add_alternate
    if [[ "${#CN_UVC_BY_PATH[@]}" != "0" ]]; then
        for add_alternate in $(cn_get_alternate_valid_path); do
            CN_UVC_VALID_DEVICES+=( "${add_alternate}" )
        done
    fi
}

cn_assign_valid_array() {
    local cam
    for cam in "${CN_UVC_BY_ID[@]}" "${CN_UVC_BY_PATH[@]}"; do
        CN_UVC_VALID_DEVICES+=( "${cam}" )
    done
    declare -gar CN_UVC_VALID_DEVICES
}

cn_get_avail_formats() {
    local device
    local -a formats
    device="${1}"
    if [[ "${CN_UVC_VALID_DEVICES[*]}" =~ ${device} ]]; then
        readarray -t formats < <(v4l2-ctl -d "${device}" --list-formats-ext)
        echo "${formats[@]}"
    else
        return
    fi
}

cn_get_supported_controls() {
    local device
    local -a formats
    device="${1}"
    if [[ "${CN_UVC_VALID_DEVICES[*]}" =~ ${device} ]]; then
        readarray -t formats < <(v4l2-ctl -d "${device}" --list-ctrls-menus)
        echo "${formats[@]}"
    else
        return
    fi
}

cn_get_uvc_dev_count() {
    printf "%s" "${#CN_UVC_BY_ID[@]}"
}

cn_init_hw_uvc() {

    cn_set_uvc_by_id_paths

    cn_set_uvc_by_path_paths

    cn_set_alternate_valid_path

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
