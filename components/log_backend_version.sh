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

cn_log_streamer_version() {
    local bin version
    for i in "${CN_CUR_USABLE_BACKENDS[@]}"; do
        if [[ "${i}" =~ "camera-streamer" ]]; then
            bin="CN_${i^^}_BIN_PATH"
            bin="${bin/\-/\_}"
        else
            bin="CN_${i^^}_BIN_PATH"
        fi
        if [[ -v "${bin}" ]] && [[ -n "${!bin}" ]]; then
            if [[ "${!bin}" =~ "ustreamer" ]]; then
                version="$("${!bin}" -v)"
            fi
            if [[ "${!bin}" =~ "camera-streamer" ]]; then
                version="$("${!bin}" --version)"
            fi
            if [[ "${CN_DEV_MSG}" = "1" ]]; then
                printf "Bin: %s\n" "${bin}"
            fi
            cn_log_msg "Version of '${i}': ${version}"
        fi
    done
}

cn_init_backend_version() {
    cn_log_sect_header "Backend versions:"

    cn_log_streamer_version

    # put a little whitespace here
    cn_log_msg " "
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_backend_version.sh\n"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefor...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
