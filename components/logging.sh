#!/bin/bash

#### logging.sh - logging related stuff

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

## Logging

cn_delete_log() {
    if [[ "${CN_SELF_DELETE_LOG}" = "true" ]]; then
        rm -rf "${CROWSNEST_LOG_PATH}"
    fi
}

cn_log_header() {
    log_msg "${CN_SELF_TITLE}"
    cn_self_version_log_msg
    log_msg "Prepare Startup ..."
}

cn_log_msg() {
    local msg prefix
    msg="${1}"
    prefix="$(date +'[%D %T]') crowsnest:"
    printf "%s %s\n" "${prefix}" "${msg}" >> "${CROWSNEST_LOG_PATH}"
    printf "%s\n" "${msg}"
}

#call '| log_output "<prefix>"'
function log_output {
    local prefix
    prefix="DEBUG: ${1}"
    while read -r line; do
        if [[ "${CROWSNEST_LOG_LEVEL}" = "debug" ]]; then
            log_msg "${prefix}: ${line}"
        fi
    done
}


function print_cams {
    local total v4l
    v4l="$(find /dev/v4l/by-id/ -iname "*index0" 2> /dev/null | wc -l)"
    total="$((v4l+($(detect_libcamera))))"
    if [ "${total}" -eq 0 ]; then
        log_msg "ERROR: No usable Devices Found. Stopping $(basename "${0}")."
        exit 1
    else
        log_msg "INFO: Found ${total} total available Device(s)"
    fi
    if [[ "$(detect_libcamera)" -ne 0 ]]; then
        log_msg "Detected 'libcamera' device -> $(get_libcamera_path)"
    fi
    if [[ -d "/dev/v4l/by-id/" ]]; then
        detect_avail_cams
    fi
}

cn_init_logging() {
    delete_log

    print_host
}
