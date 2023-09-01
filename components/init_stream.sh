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

cn_get_streamer_running() {
    pgrep -fc "^/*${1}*"
}

cn_init_streams() {
    local cam mode
    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "init_stream:\n###########\n"
        declare -p | grep "CN_AVAIL_BACKENDS"
        printf "Configured cams: %s\n" "${#CN_CONFIGURED_CAMS[*]}"
        printf "###########\n"
    fi

    cn_init_streams_msg_header

    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        mode="$(cn_get_streamer "${cam}")"
        mode="${mode,,}"
        if [[ -n "${mode}" ]]; then
            cn_streamer_init_msg "${mode}" "${cam}"
            case "${mode}" in
                ustreamer|mjpg)
                    cn_exec_ustreamer "${cam}"
                    until [[ "$(cn_get_streamer_running "ustreamer")" = "1" ]]; do
                        sleep 0.5
                    done
                ;;
                camera-streamer)
                    cn_exec_cstreamer "${cam}"
                    until [[ "$(cn_get_streamer_running "camera-streamer")" = "1" ]]; do
                        sleep 0.5
                    done
                ;;
            esac
        else
            cn_log_msg "Mode for '${cam}' not configured ... Skipped!"
        fi
    done

}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: init_stream.sh\n"
fi
