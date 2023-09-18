#!/usr/bin/env bash

#### ustreamer.sh - exec ustreamer

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
set -e

cn_exec_ustreamer() {
    local cam custom_flags device no_proxy port res
    local -a start_param
    cam="CAM_${1}"
    custom_flags="CN_${cam}_CUSTOM_FLAGS"
    device="CN_${cam}_DEVICE"
    fps="CN_${cam}_MAX_FPS"
    no_proxy="CN_${cam}_NO_PROXY"
    port="CN_${cam}_PORT"
    res="CN_${cam}_RESOLUTION"
    start_param=( --tcp-nodelay --no-log-colors )

    if [[ "${!no_proxy}" = "true" ]]; then
        start_param+=( --host 0.0.0.0 -p "${!port}" )
    else
        start_param+=( --host 127.0.0.1 -p "${!port}" )
    fi

    ## Raspicam handling
    if [[ "${!device}" = "legacy" ]] \
    || [[ "${!device}" = "${CN_LEGACY_DEV_PATH}" ]]; then
            start_param+=( -d "${CN_LEGACY_DEV_PATH}" -m MJPEG --device-timeout=5 --buffers=3 )
    else
        start_param+=( -d "${!device}" --device-timeout=2 )
    fi

    ## Use hardware MJPG encoder if avail
    if [[ "$(cn_detect_hw_mjpg "${!device}")" != "0" ]] \
    && [[ ! "${start_param[*]}" =~ "-m MJPEG" ]]; then
        start_param+=( -m MJPEG --encoder=HW )
    fi

    start_param+=( -r "${!res}" -f "${!fps}" )

    ## webroot & allow crossdomain requests
    start_param+=( --allow-origin=\* --static "${CN_WORKDIR_PATH}/ustreamer-www" )

    if [[ -n "${!custom_flags}" ]]; then
        for flag in "${!custom_flags}"; do
            start_param+=( "${flag}" )
        done
    fi

        #start_param+=(--foo)

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "ustreamer:\n###########\n"
        printf "start_param: %s\n" "${start_param[*]}"
        printf "###########\n"
    fi


    cn_streamer_param_msg "ustreamer" "${1}" "${start_param[*]}"

    cn_ustreamer_loop "${1}" "${start_param[*]}" &
}

cn_ustreamer_loop() {
    echo "${2}" \
    | xargs "${CN_USTREAMER_BIN_PATH}" 2>&1 \
    | cn_log_output "ustreamer [cam ${1}]"
    # Should not be seen if running
    cn_streamer_failed_msg "ustreamer" "${1}" && return 1
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: ustreamer.sh\n"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefore...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
