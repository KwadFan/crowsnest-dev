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
