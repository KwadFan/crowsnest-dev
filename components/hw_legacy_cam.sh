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


cn_check_vcgencmd () {
    local vcgencmd_bin_path
    vcgencmd_bin_path="$(command -v vcgencmd)"
    if [[ -n "${vcgencmd_bin_path}" ]]; then
        CN_LEGACY_VCGENCMD_BIN="${vcgencmd_bin_path}"
    else
        CN_LEGACY_VCGENCMD_BIN="null"
    fi
    # shellcheck disable=SC2034
    declare -gr CN_LEGACY_VCGENCMD_BIN

}

cn_init_hw_legacy () {


    if [[ "${CN_LIBCAMERA_DEV_PATH}" == "null" ]]; then

        cn_check_vcgencmd

    fi


    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "hw_legacy_cam:\n###########\n"
        declare -p | grep "CN_LEGACY"
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: hw_legacy_cam.sh\n"
fi
