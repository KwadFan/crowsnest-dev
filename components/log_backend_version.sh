#!/usr/bin/env bash

#### log_backend_version.sh - get and log current version of backends

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


[[ -n "${CN_CUR_USABLE_BACKENDS[*]}" ]] || \
    CN_CUR_USABLE_BACKENDS=(ustreamer camera-streamer)


cn_log_streamer_version() {
    local bin
    for i in "${CN_CUR_USABLE_BACKENDS[@]}"; do
        bin="CN_${i^^}_BIN_PATH"
        if [[ -v "${bin}" ]] && [[ -n "${!bin}" ]]; then
            cn_log_msg "Backend '${i}' found in '${!bin}' ..."
        fi
    done
}

cn_init_backend_version() {
    cn_log_sect_header "Backend versions:"

    cn_log_streamer_info

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        true
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_backend_version.sh\n"
fi
