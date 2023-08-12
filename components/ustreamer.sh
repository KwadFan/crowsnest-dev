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
set -Ee

cn_exec_ustreamer() {
    local cam device port res
    local -a start_param
    cam="CAM_${1}"
    device=CN_${cam}_DEVICE
    fps=CN_${cam}_MAX_FPS
    port="CN_${cam}_PORT"
    res=CN_${cam}_RESOLUTION
    start_param=()

    if [[ "$CN_NO_PROXY" = "true" ]]; then
        start_param+=( --host 0.0.0.0 -p "${!port}" )
    else
        start_param+=( --host 127.0.0.1 -p "${!port}" )
    fi


    printf "start_param: %s" "${start_param[*]}\n"
}


# declare -r CN_CAM_1_MAX_FPS="15"
# declare -r CN_CAM_1_MODE="foobar"
# declare -r CN_CAM_1_PORT="8080"
# declare -r CN_CAM_1_RESOLUTION="640x480"
# declare -r CN_CAM_1_RTSP_PORT="8554"
# declare -r CN_CAM_2_DEVICE="/dev/video1"
# declare -r CN_CAM_2_MAX_FPS="25"
# declare -r CN_CAM_2_MODE="ustreamer"
# declare -r CN_CAM_2_PORT="8080"
# declare -r CN_CAM_2_RESOLUTION="640x480"
# declare -r CN_CAM_FOO_DEVICE="/meeh/foo"
# declare -r CN_CAM_FOO_MAX_FPS="nö"
# declare -r CN_CAM_FOO_MODE="foo"
# declare -r CN_CAM_FOO_PORT="abcd"
# declare -r CN_CAM_FOO_RESOLUTION="1100X500"
# declare -ar CN_CONFIGURED_CAMS=([0]="1" [1]="2" [2]="foo")


# run_ustreamer() {
#     local cam_sec ust_bin dev pt res fps cstm start_param
#     cam_sec="${1}"
#     ust_bin="${BASE_CN_PATH}/bin/ustreamer/ustreamer"
#     dev="$(get_param "cam ${cam_sec}" device)"
#     pt="$(get_param "cam ${cam_sec}" port)"
#     res="$(get_param "cam ${cam_sec}" resolution)"
#     fps="$(get_param "cam ${cam_sec}" max_fps)"
#     cstm="$(get_param "cam ${cam_sec}" custom_flags 2> /dev/null)"
#     noprx="$(get_param "crowsnest" no_proxy 2> /dev/null)"
#     # construct start parameter
#     if [[ -n "${noprx}" ]] && [[ "${noprx}" = "true" ]]; then
#         start_param=( --host 0.0.0.0 -p "${pt}" )
#         log_msg "INFO: Set to 'no_proxy' mode! Using 0.0.0.0 !"
#     else
#         start_param=( --host 127.0.0.1 -p "${pt}" )
#     fi

#     # Add device
#     start_param+=( -d "${dev}" --device-timeout=2 )

#     # Use MJPEG Hardware encoder if possible
#     if [ "$(detect_mjpeg "${cam_sec}")" = "1" ]; then
#         start_param+=( -m MJPEG --encoder=HW )
#     fi

#     # set max framerate
#     start_param+=( -r "${res}" -f "${fps}" )

#     # webroot & allow crossdomain requests
#     start_param+=( --allow-origin=\* --static "${BASE_CN_PATH}/ustreamer-www" )
#     # Custom Flag Handling (append to defaults)
#     if [[ -n "${cstm}" ]]; then
#         start_param+=( "${cstm}" )
#     fi
#     # Log start_param
#     log_msg "Starting ustreamer with Device ${dev} ..."
#     echo "Parameters: ${start_param[*]}" | \
#     log_output "ustreamer [cam ${cam_sec}]"
#     # Start ustreamer
#     echo "${start_param[*]}" | xargs "${ust_bin}" 2>&1 | \
#     log_output "ustreamer [cam ${cam_sec}]"
#     # Should not be seen else failed.
#     log_msg "ERROR: Start of ustreamer [cam ${cam_sec}] failed!"
# }



if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: ustreamer.sh\n"
fi
