#!/usr/bin/env bash

#### log_libcamera_controls.sh - wrapper for printing avail. libcamera ctrls.

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

CN_LIBCAMERA_CTRLS_ARRAY=()

cn_get_libcamera_controls() {
    python - << EOL
from picamera2 import Picamera2
picam = Picamera2()
ctrls = picam.camera_controls

for key, value in ctrls.items():
        min, max, default = value
        print(f"{key}: min={min} max={max} default={default}")

EOL
}

cn_set_libcamera_controls() {
    local get_ctrls
    if [[ "${CN_LIBCAMERA_AVAIL}" = "1" ]]; then
        get_ctrls="$(cn_get_libcamera_controls 2> /dev/null)"
        for x in ${get_ctrls}; do
            CN_LIBCAMERA_CTRLS_ARRAY+=("${x}")
        done
        # shellcheck disable=SC2034
        declare -ar CN_LIBCAMERA_CTRLS_ARRAY
    fi
}


cn_init_libcamera_controls() {
    cn_set_libcamera_controls

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "log_libcamera_controls:\n###########\n"
        declare -p | grep "CN_LIBCAMERA_CTRLS_ARRAY"
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_libcamera_controls.sh\n"
fi
