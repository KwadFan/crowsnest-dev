#!/usr/bin/env bash

#### camera-streamer.sh - exec camera-streamer

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

cn_exec_camera_streamer() {
    local cam custom_flags device port res
    local -a start_param
    cam="CAM_${1}"
    custom_flags="CN_${cam}_CUSTOM_FLAGS"
    device="CN_${cam}_DEVICE"
    fps="CN_${cam}_MAX_FPS"
    port="CN_${cam}_PORT"
    res="CN_${cam}_RESOLUTION"
    rtsp_enabled="CN_${cam}_ENABLE_RTSP"
    rtsp_port="CN_${cam}_RTSP_PORT"
    v4l2ctl="CN_${cam}_V4L2CTL_ARRAY[@]"
    start_param=( --camera-auto_reconnect=1 )

    # Split resolution
    get_height_val() {
        (sed 's/#.*//' | cut -d'x' -f2) <<< "${!res}"
    }
    get_width_val() {
        (sed 's/#.*//' | cut -d'x' -f1) <<< "${!res}"
    }

    start_param+=( --http-port="${!port}" )

    ## camera type handling
    if [[ "${!device}" = "libcamera" ]] \
    || [[ "${!device}" =~ ${CN_LIBCAMERA_DEV_PATH} ]]; then
        start_param+=( --camera-path="${CN_LIBCAMERA_DEV_PATH}" )
        start_param+=( --camera-type=libcamera )
        start_param+=( --camera-format=YUYV )
    else
        start_param+=( --camera-path="${!device}" )
        start_param+=( --camera-type=v4l2 )
    fi

    if [[ ! "${start_param[*]}" =~ "--camera-type=libcamera" ]] \
    && [[ "$(cn_detect_hw_mjpg "${!device}")" != "0" ]]; then
        start_param+=( --camera-format=MJPG )
    fi

    start_param+=( --camera-width="$(get_width_val)" )
    start_param+=( --camera-height="$(get_height_val)" )
    start_param+=( --camera-fps="${!fps}" )

    if [[ "${!rtsp_enabled}" = "true" ]]; then
        start_param+=( --rtsp-port="${!rtsp_port}" )
    fi
    #v4l2ctl handling
    if [[ -n "${!v4l2ctl}" ]]; then
        for ctrl in "${!v4l2ctl}"; do
            start_param+=( --camera-option="${ctrl}" )
        done
    fi

    if [[ -n "${!custom_flags}" ]]; then
        for fl in "${!custom_flags}"; do
            start_param+=( "${fl}" )
        done
    fi

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "camera-streamer:\n###########\n"
        printf "start_param: %s\n" "${start_param[*]}"
        printf "###########\n"
    fi

    if [[ "${CN_SELF_LOG_LEVEL}" = "debug" ]]; then
        cn_streamer_param_msg "camera-streamer" "${1}" "${start_param[*]}"
    fi

    cn_cstreamer_loop "${1}" "${start_param[*]}" &
}

cn_cstreamer_loop() {
    while echo "${2}" | xargs "${CN_CAMERA_STREAMER_BIN_PATH}" 2>&1 \
    | cn_log_output "camera-streamer [cam ${1}]"; do
        cn_streamer_failed_msg "camera-streamer" "${1}"
        cn_log_info_msg "Trying to restart in 5 seconds ..."
        cn_log_msg " "
        sleep 60
    done
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: camera-streamer.sh\n"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefore...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
