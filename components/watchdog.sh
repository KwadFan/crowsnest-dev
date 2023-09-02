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

# shellcheck enable=require-variable-braces

# Exit upon Errors
set -Ee

CN_WATCHDOG_DEVICE_ARRAY=()

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
            cn_log_msg "\t${x}"
        done
    fi
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
