#!/usr/bin/env bash

#### init_stream.sh - Initialize stream service

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

cn_get_streamer() {
    local cam mode
    cam="${1}"
    mode="CN_CAM_${cam}_MODE"
    printf "%s" "${!mode}"
}

cn_init_streams() {
    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "init_stream:\n###########\n"
        declare -p | grep "CN_AVAIL_BACKENDS"
        printf "###########\n"
    fi


    cn_init_streams_msg_header

    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        mode="$(cn_get_streamer "${cam}")"
        if [[ -n "${mode}" ]]; then
            cn_log_msg "Launch ${mode} for ${cam} ...."
        else
            cn_log_msg "Mode for '${cam}' not configured ... Skipped!"
        fi
    done

}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: init_stream.sh\n"
fi


# function construct_streamer {
#     local cams sleep_pid
#     # See configparser.sh L#53
#     log_msg "Try to start configured Cams / Services..."
#     for cams in $(configured_cams); do
#         mode="$(get_param "cam ${cams}" mode)"
#         check_section "${cams}"
#         case ${mode} in
#             [mM]ulti | camera-streamer)
#                 if [[ "$(is_raspberry_pi)" = "1" ]] && [[ "$(is_ubuntu_arm)" = "0" ]]; then
#                     MULTI_INSTANCES+=( "${cams}" )
#                 else
#                     log_msg "WARN: Mode 'multi' is not supported on your device!"
#                     log_msg "WARN: Falling back to Mode 'mjpg'"
#                     MJPG_INSTANCES+=( "${cams}" )
#                 fi
#             ;;
#             mjpg | mjpeg | ustreamer)
#                 MJPG_INSTANCES+=( "${cams}" )
#             ;;
#             ?|*)
#                 unknown_mode_msg
#                 MJPG_INSTANCES+=( "${cams}" )

#             ;;
#         esac
#     done
#     if [ "${#MULTI_INSTANCES[@]}" != "0" ]; then
#         run_multi "${MULTI_INSTANCES[*]}"
#     fi
#     if [ "${#MJPG_INSTANCES[@]}" != "0" ]; then
#         run_mjpg "${MJPG_INSTANCES[*]}"
#     fi
#     sleep 2 & sleep_pid="$!" ; wait "${sleep_pid}"
#     log_msg " ... Done!"
# }
