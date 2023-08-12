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
set -Ee

cn_exec_cstreamer() {
    local cam device port res
    local -a start_param
    cam="CAM_${1}"
    device="CN_${cam}_DEVICE"
    fps="CN_${cam}_MAX_FPS"
    port="CN_${cam}_PORT"
    res="CN_${cam}_RESOLUTION"
    start_param=( --camera-auto_reconnect=1 )

    # Split resolution
    get_height_val() {
        (sed 's/#.*//' | cut -d'x' -f2) <<< "${!res}"
    }
    get_width_val() {
        (sed 's/#.*//' | cut -d'x' -f1) <<< "${!res}"
    }

    start_param=( --http-port="${!port}" )

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
    echo "${2}" \
    | xargs "${CN_CAMERA_STREAMER_BIN_PATH}" 2>&1 \
    | cn_log_output "camera-streamer [cam ${1}]"
    # Should not be seen if running
    cn_streamer_failed_msg "camera-streamer" "${1}"
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: camera-streamer.sh\n"
fi




# function run_ayucamstream() {
#     local cam_sec ust_bin dev pt res rtsp rtsp_pt fps cstm start_param
#     local v4l2ctl
#     cam_sec="${1}"
#     ust_bin="${BASE_CN_PATH}/bin/camera-streamer/camera-streamer"
#     dev="$(get_param "cam ${cam_sec}" device)"
#     pt=$(get_param "cam ${cam_sec}" port)
#     res=$(get_param "cam ${cam_sec}" resolution)
#     fps=$(get_param "cam ${cam_sec}" max_fps)
#     rtsp=$(get_param "cam ${cam_sec}" enable_rtsp)
#     rtsp_pt=$(get_param "cam ${cam_sec}" rtsp_port)
#     cstm="$(get_param "cam ${cam_sec}" custom_flags 2> /dev/null)"
#     ## construct start parameter
#     # set http port
#     #

#     # Set device



#     if [[ "${dev}" =~ "/dev/video" ]] ||
#     [[ "${dev}" =~ "/dev/v4l/" ]]; then
#         start_param+=( --camera-type=v4l2 )
#     fi

#     # Use MJPEG Hardware encoder if possible
#     if [ "$(detect_mjpeg "${cam_sec}")" = "1" ] &&
#     [[ ! "${dev}" =~ "/base/soc" ]]; then
#         start_param+=( --camera-format=MJPG )
#     fi

#     # Set resolution
#     get_height_val() {
#         (sed 's/#.*//' | cut -d'x' -f2) <<< "${res}"
#     }
#     get_width_val() {
#         (sed 's/#.*//' | cut -d'x' -f1) <<< "${res}"
#     }

#     # Set snapshot heigth to 1080p by default
#     start_param+=( --camera-snapshot.height=1080 )

#     start_param+=( --camera-width="$(get_width_val)" )
#     start_param+=( --camera-height="$(get_height_val)" )

#     # Set FPS
#

#     # Enable rtsp, if set true
#     if [[ -n "${rtsp}" ]] && [[ "${rtsp}" == "true" ]]; then
#         # ensure a port is set
#         start_param+=( --rtsp-port="${rtsp_pt:-8554}" )
#     fi

#     # Enable camera-auto_reconnect by default
#     start_param+=( --camera-auto_reconnect=1 )

#     # Custom Flag Handling (append to defaults)
#     if [[ -n "${cstm}" ]]; then
#         start_param+=( "${cstm}" )
#     fi

#     # v4l2 option handling
#     v4l2ctl="$(get_param "cam ${cam_sec}" v4l2ctl)"
#     if [ -n "${v4l2ctl}" ]; then
#         IFS="," read -ra opt < <(echo "${v4l2ctl}" | tr -d " "); unset IFS
#         log_msg "V4L2 Control: Handling done by camera-streamer ..."
#         log_msg "V4L2 Control: Trying to set: ${v4l2ctl}"
#         # loop through options
#         for param in "${opt[@]}"; do
#             start_param+=( --camera-options="${param}" )
#         done
#     fi


#     # Log start_param
#     log_msg "Starting camera-streamer with Device ${dev} ..."
#     echo "Parameters: ${start_param[*]}" | \
#     log_output "camera-streamer [cam ${cam_sec}]"
#     # Start camera-streamer
#     echo "${start_param[*]}" | xargs "${ust_bin}" 2>&1 | \
#     log_output "camera-streamer [cam ${cam_sec}]"
#     # Should not be seen else failed.
#     log_msg "ERROR: Start of camera-streamer [cam ${cam_sec}] failed!"
# }
