#!/usr/bin/env bash

#### watchdog.sh - check for lost camera devices while running
####
#### crowsnest - A webcam Service for multiple Cams and Stream Services.
####
#### Written by Stephan Wendel aka KwadFan <me@stephanwe.de>
#### Copyright 2021 - till today
#### https://github.com/mainsail-crew/crowsnest
####
#### This File is distributed under GPLv3
####

#### Note: Even if DRY paradigm should be obeyed, isolate watchdog from other
####       parts of the application.

# shellcheck enable=require-variable-braces

# Exit upon Errors
set -Ee

CN_WATCHDOG_DEVICE_ARRAY=()
CN_WATCHDOG_SLEEP_TIME="120"

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    CN_WATCHDOG_SLEEP_TIME="5"
fi

declare -gr CN_WATCHDOG_SLEEP_TIME

cn_set_watchdog_device_array() {
    if [[ "${CN_SELF_LOG_LEVEL}" = "debug" ]]; then
        cn_log_debug_msg "Gathering device list ..."
    fi
    if [[ "${CN_UVC_BY_ID[0]}" != "null" ]]; then
        for x in "${CN_UVC_VALID_DEVICES[@]}"; do
            CN_WATCHDOG_DEVICE_ARRAY+=( "${x}" )
        done
    fi
    if [[ "${CN_LIBCAMERA_DEV_PATH}" != "null" ]]; then
        CN_WATCHDOG_DEVICE_ARRAY+=( "${CN_LIBCAMERA_DEV_PATH}" )
    fi
    if [[ "${CN_LEGACY_DEV_PATH}" != "null" ]]; then
        CN_WATCHDOG_DEVICE_ARRAY+=( "${CN_LEGACY_DEV_PATH}" )
    fi
}

cn_watchdog_debug_print_devices() {
    if [[ "${CN_SELF_LOG_LEVEL}" = "debug" ]]; then
        cn_log_sect_header "Watchdog: devices list"
        for x in "${CN_WATCHDOG_DEVICE_ARRAY[@]}"; do
            # for simplicity hardcode a 'tab'
            cn_log_msg "    ${x}"
        done
    fi
}

cn_watchdog_get_real_path() {
    readlink "${1}" | sed 's/^\.\.\/\.\./\/dev/'
    #printf "foo"
}

cn_watchdog_runtime() {
    local real_path
    sleep "${CN_WATCHDOG_SLEEP_TIME}"

    for x in "${CN_WATCHDOG_DEVICE_ARRAY[@]}"; do
        if [[ "${CN_DEV_MSG}" = "1" ]]; then
            printf "watchdog runtime:\n###########\n"
            printf "Checking device: %s" "${x}"
            printf "###########\n"
        fi
        real_path="$(cn_watchdog_get_real_path "${x}")"
        if [[ "${x}" =~ "/dev/v4l/by-id" ]] && [[ ! -e "${x}" ]]; then
            cn_log_warn_msg "Lost device(s) '${x}' ( ${real_path} ) !!!!"
        fi
    done
}

cn_init_watchdog() {

    cn_log_sect_header "Watchdog"

    cn_log_info_msg "Initializing watchdog ..."

    cn_set_watchdog_device_array

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "watchdog:\n###########\n"
        declare -p | grep "CN_WATCHDOG"
        printf "###########\n"
    fi

    cn_watchdog_debug_print_devices
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: watchdog.sh\n"
fi


# hw_uvc_dev:
# ###########
# declare -ar CN_UVC_BY_ID=([0]="/dev/v4l/by-id/usb-Sonix_Technology_Co.__Ltd._Trust_Webcam_Trust_Webcam-video-index0")
# declare -ar CN_UVC_BY_PATH=([0]="/dev/v4l/by-path/platform-fd500000.pcie-pci-0000:01:00.0-usb-0:1.1:1.0-video-index0")
# declare -ar CN_UVC_VALID_DEVICES=([0]="/dev/video1" [1]="/dev/v4l/by-id/usb-Sonix_Technology_Co.__Ltd._Trust_Webcam_Trust_Webcam-video-index0" [2]="/dev/v4l/by-path/platform-fd500000.pcie-pci-0000:01:00.0-usb-0:1.
# 1:1.0-video-index0")
# ###########
# hw_libcamera:
# ###########
# declare -r CN_LIBCAMERA_AVAIL="1"
# declare -r CN_LIBCAMERA_BIN_PATH="/usr/bin/libcamera-hello"
# declare -r CN_LIBCAMERA_DEV_PATH="null"
# declare -ar CN_LIBCAMERA_OUTPUT_ARRAY=([0]="No cameras available!")
# ###########
# hw_legacy_cam:
# ###########
# declare -r CN_LEGACY_DEV_AVAIL="1"
# declare -r CN_LEGACY_DEV_PATH="/dev/video0"
# declare -r CN_LEGACY_VCGENCMD_BIN="/usr/bin/vcgencmd"
# ###########
# log_avail_cam:
# ###########
# Libcamera dev count: 0
# Legacy dev count: 1
# UVC dev count: 1
# Total dev count: 2
# ###########

# cn_get_alternate_valid_path() {
#     local alternate_path
#     local -a path
#     path=()
#     if [[ "${#CN_UVC_BY_PATH[@]}" != "0" ]]; then
#         for alternate_path in $(cn_get_uvc_by_path_paths); do
#             path+=("$(readlink "${alternate_path}" | sed 's/^\.\.\/\.\./\/dev/')")
#         done
#         echo "${path[@]}"
#     fi
# }
