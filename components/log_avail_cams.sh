#!/usr/bin/env bash

#### log_avail_cams.sh - log available cameras

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

cn_print_cams() {
    local total v4l
    v4l="$(find /dev/v4l/by-id/ -iname "*index0" 2> /dev/null | wc -l)"
    total="$((v4l+($(detect_libcamera))))"
    if [ "${total}" -eq 0 ]; then
        cn_log_msg "ERROR: No usable Devices Found. Stopping $(basename "${0}")."
        exit 1
    else
        cn_log_msg "INFO: Found ${total} total available Device(s)"
    fi
    if [[ "$(detect_libcamera)" -ne 0 ]]; then
        cn_log_msg "Detected 'libcamera' device -> $(get_libcamera_path)"
    fi
    if [[ -d "/dev/v4l/by-id/" ]]; then
        detect_avail_cams
    fi
}

cn_get_dev_count() {
    local libcamera total uvc
    libcamera="$(cn_get_libcamera_dev_count)"
    uvc="$(cn_get_uvc_dev_count)"
    total="$((libcamera+uvc))"
    printf "%s" "${total}"
}

cn_print_dev_count() {
    if [[ "$(cn_get_dev_count)" != "0" ]]; then
        cn_camera_count_msg "$(cn_get_dev_count)"
    else
        cn_no_usable_cams_found_msg
    fi
}

cn_print_devices() {

    cn_log_sect_header "Detect available devices:"
    # put some whitespace here
    cn_log_msg " "

    cn_print_dev_count

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "hw_uvc_dev:\n###########\n"
        declare -p | grep "CN_UVC"
        printf "###########\n"
    fi
}

cn_init_print_devices() {

    cn_print_devices
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_avail_cams.sh\n"
fi
