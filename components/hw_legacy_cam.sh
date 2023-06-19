#!/usr/bin/env bash

#### hw_legacy_cam.sh - Legacy cam stack (Raspicam) related stuff

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

cn_init_hw_legacy () {



    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "hw_uvc_dev:\n###########\n"
        declare -p | grep "CN_LEGACY"
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: hw_legacy_cam.sh\n"
fi
