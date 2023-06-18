#!/usr/bin/env bash

#### hw_libcamera.sh - libamera related stuff

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

CN_LIBCAMERA_BIN_PATH=""
CN_LIBCAMERA_DEV_PATH=""


cn_check_libcamera_hello_bin() {
    local bin
    bin="$(command -v libcamera-hello)"
    if [[ -x "${bin}" ]]; then
        CN_LIBCAMERA_BIN_PATH="${bin}"
    else
        CN_LIBCAMERA_BIN_PATH="null"
    fi
    declare -gr CN_LIBCAMERA_BIN_PATH
}


cn_init_hw_libcamera() {
    cn_check_libcamera_hello_bin
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: hw_libcamera.sh\n"
fi
