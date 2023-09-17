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
set -e

cn_get_dev_count() {
    local total
    total="$(( \
        $(cn_get_libcamera_dev_count) \
        +$(cn_get_uvc_dev_count) \
        +$(cn_get_legacy_dev_count) \
        ))"
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
        cn_get_supported_formats "${CN_LEGACY_DEV_PATH}" | cn_log_v4l2ctl_output

        cn_supported_ctrls_msg
        cn_get_supported_ctrls "${CN_LEGACY_DEV_PATH}" | cn_log_v4l2ctl_output
    fi
}

cn_log_libcamera_dev() {
    if [[ "${CN_LIBCAMERA_AVAIL}" = "1" ]] \
    && [[ "${CN_LIBCAMERA_DEV_PATH}" != "null" ]]; then
        cn_libcamera_dev_msg

        cn_dev_video_path_msg "${CN_LIBCAMERA_DEV_PATH}"

        cn_libcamera_dev_info_msg

        cn_libcamera_dev_ctrls_msg
    fi
}

cn_get_uvc_header_name() {
    local name
    name="$(basename "${1}")"
    name="${name/usb\-/}"
    name="${name/-video-index[0-9]/}"
    printf "%s" "${name}"
}

cn_get_uvc_device_by_path() {
    find /dev/v4l/by-path -exec ls -dl {} \; \
    | grep "${1}$" \
    | cut -f2- -d '/' \
    | cut -f1 -d ' ' \
    | sed 's|dev|/dev|'
}

cn_get_uvc_device_paths() {
    local by_path enum_path device
    device="${1}"
    enum_path="$(readlink "${device}" | sed 's/^\.\.\/\.\./\/dev/')"
    by_path="$(cn_get_uvc_device_by_path "$(basename "${enum_path}")")"

    cn_dev_video_path_msg "${enum_path}"
    cn_dev_byid_path_msg "${device}"
    cn_dev_bypath_path_msg "${by_path}"
    # add some whitespace
    cn_log_msg " "
}

cn_log_uvc_dev() {
    local device
    if [[ "${CN_UVC_BY_ID[0]}" != "null" ]]; then
        for device in "${CN_UVC_BY_ID[@]}"; do

            cn_uvc_dev_msg "$(cn_get_uvc_header_name "${device}")"

            cn_get_uvc_device_paths "${device}"

            cn_note_by-id_msg

            cn_supported_formats_msg
            cn_get_supported_formats "${device}" | cn_log_v4l2ctl_output

            cn_supported_ctrls_msg
            cn_get_supported_ctrls "${device}" | cn_log_v4l2ctl_output

        done
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

    cn_print_dev_count

    if [[ "${CN_SELF_LOG_LEVEL}" != "quiet" ]]; then

        cn_log_legacy_dev

        cn_log_libcamera_dev

        cn_log_uvc_dev
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_avail_cams.sh\n"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefore...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
