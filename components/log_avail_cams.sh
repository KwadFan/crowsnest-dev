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

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_avail_cams.sh\n"
fi
