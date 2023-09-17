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
set -e

cn_get_streamer() {
    local cam mode
    cam="${1}"
    mode="CN_CAM_${cam}_MODE"
    printf "%s" "${!mode}"
}

cn_get_streamer_running() {
    sleep 1
    pgrep -fc "^/*${1}*"
}

cn_init_streams() {
    local cam mode instance_count
    instance_count="0"
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
                    if [[ "$(cn_get_streamer_running "${mode}")" = "1" ]]; then
                        instance_count="$((instance_count+1))"
                    fi
                ;;
                camera-streamer)
                    cn_exec_camera_streamer "${cam}"
                    if [[ "$(cn_get_streamer_running "${mode}")" = "1" ]]; then
                        instance_count="$((instance_count+1))"
                    fi
                ;;
            esac
        else
            cn_log_msg "Mode for '${cam}' not configured ... Skipped!"
        fi
    done
    if [[ "${#CONFIGURED_CAMS[@]}" = "${instance_count}" ]]; then
        cn_log_info_msg "Configured streams initiated ..."
        # put some whitespace here
        cn_log_msg " "
        # give some head room for watchdog
        sleep 0.5
    fi

}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: init_stream.sh\n"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefore...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
