#!/usr/bin/env bash

#### log_v4l2ctl_output.sh - Write supported resolutions to log

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


cn_get_supported_formats() {
    local device v4l2ctl
    device="${1}"
    v4l2ctl="$(command -v v4l2-ctl)"
    if [[ -n "${v4l2ctl}" ]] && [[ -n "${device}" ]]; then
        cn_supported_formats_msg
        "${v4l2ctl}" --list-formats-ext --device "${device}" \
        | sed '1,3d'
    fi
}

cn_get_supported_ctrls() {
    local device v4l2ctl
    device="${1}"
    v4l2ctl="$(command -v v4l2-ctl)"
    if [[ -n "${v4l2ctl}" ]] && [[ -n "${device}" ]]; then
        cn_supported_ctrls_msg
        "${v4l2ctl}" --list-ctrls-menu --device "${device}" \
        | sed '1,3d'
        # put some whitespace here
        printf "\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_v4l2ctl_output.sh\n"
fi
