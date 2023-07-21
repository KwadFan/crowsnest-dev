#!/usr/bin/env bash

#### log_avail_cams.sh - log available cameras

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

cn_get_dev_count() {
    local total
    total="$(($(cn_get_libcamera_dev_count)+$(cn_get_uvc_dev_count)+$(cn_get_legacy_dev_count)))"
    printf "%s" "${total}"
}

cn_print_dev_count() {
    if [[ "$(cn_get_dev_count)" != "0" ]]; then
        cn_camera_count_msg "$(cn_get_dev_count)"
    else
        cn_no_usable_cams_found_msg
        exit 1
    fi
}

cn_log_legacy_dev() {
    if [[ "${CN_LEGACY_DEV_AVAIL}" = "1" ]] \
    && [[ "${CN_LEGACY_DEV_PATH}" != "null" ]]; then
        cn_legacy_dev_msg

        cn_dev_video_path_msg "${CN_LEGACY_DEV_PATH}"

        cn_supported_formats_msg
        cn_get_supported_formats "${CN_LEGACY_DEV_PATH}" | cn_log_output_noquiet

        cn_supported_ctrls_msg
        cn_get_supported_ctrls "${CN_LEGACY_DEV_PATH}" | cn_log_output_noquiet

    fi
}

cn_log_libcamera_dev() {
    if [[ "${CN_LIBCAMERA_AVAIL}" = "1" ]] \
    && [[ "${CN_LIBCAMERA_DEV_PATH}" != "null" ]]; then
        cn_libcamera_dev_msg
        cn_dev_video_path_msg "${CN_LIBCAMERA_DEV_PATH}"
    fi
}

cn_init_print_devices() {

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "log_avail_cam:\n###########\n"
        printf "Libcamera dev count: %s\n" "$(cn_get_libcamera_dev_count)"
        printf "Legacy dev count: %s\n" "$(cn_get_legacy_dev_count)"
        printf "UVC dev count: %s\n" "$(cn_get_uvc_dev_count)"
        printf "Total dev count: %s\n" "$(cn_get_dev_count)"
        printf "###########\n"
    fi

    cn_log_sect_header "Detect available devices:"
    # put some whitespace here
    cn_log_msg " "

    cn_print_dev_count

    cn_log_legacy_dev

    cn_log_libcamera_dev

}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_avail_cams.sh\n"
fi
