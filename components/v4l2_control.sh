#!/usr/bin/env bash

#### v4l2_control.sh - determine crowsnest local version

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

cn_init_v4l2_ctl() {
    local array_name cam
    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        array_name="CN_CAM_${cam^^}_V4L2CTL_ARRAY"
        declare -g "${!array_name}"
    done

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "v4l2_control:\n###########\n"
        printf "Configured cams: %s\n" "${#CN_CONFIGURED_CAMS[*]}"
        declare -p | grep "CN_*_V4L2CTL"
        # declare -p | grep "CN_*_V4L2CTL_ARRAY"
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: v4l2_control.sh\n"
fi
