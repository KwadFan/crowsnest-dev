#!/usr/bin/env bash

#### deep_config_check.sh - Check config file for configuration issues

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

cn_deep_config_check_mode() {
    local mode_sect
    mode_sect="CN_CAM_${1}_MODE"
    if [[ "${CN_AVAIL_BACKENDS[*]}" =~ ${!mode_sect} ]]; then
        cn_log_check_state_msg "mode" "${!mode_sect}" "0"
        cn_log_msg " "
    else
        cn_log_check_state_msg "mode" "${!mode_sect}" "1"
        cn_log_check_mode_failed_msg "${!mode_sect}"
        cn_deep_config_check_failed
    fi
}

cn_deep_config_check_port() {
    local port
    port="CN_CAM_${1}_PORT"
    if [[ "${!port}" =~ [0-9] ]] \
    && [[ "${!port}" -gt "0" ]] \
    && [[ "${!port}" -le "65535" ]]; then
        cn_log_check_state_msg "port" "${!port}" "0"
        cn_log_msg " "
    else
        cn_log_check_state_msg "port" "${!port}" "1"
        cn_log_check_port_failed_msg "${!port}"
        cn_deep_config_check_failed
    fi
}

cn_deep_config_check_device() {
    local device
    device="CN_CAM_${1}_DEVICE"
    if [[ "${!device}" =~ /dev/video[0-9] ]] \
    && [[ "${CN_LEGACY_DEV_PATH}" = "${!device}" ]]; then

        cn_log_msg "legacy cam ..."

    elif [[ "${!device}" =~ /dev/video[0-9] ]] \
    && [[ "${CN_UVC_VALID_DEVICES[*]}" =~ ${!device} ]]; then
        cn_log_check_dev_path_msg "${!device}"
    elif [[ "${CN_UVC_VALID_DEVICES[*]}" =~ ${!device} ]]; then
        cn_log_check_state_msg "device" "${!device}" "0"
        cn_log_msg " "
    elif [[ "${!device}" =~ "/base/soc" ]]; then
        if [[ "${!device}" = "${CN_LIBCAMERA_DEV_PATH}" ]]; then
            cn_log_check_state_msg "device" "${!device}" "0"
            cn_log_msg " "
        else
            cn_log_check_state_msg "device" "${!device}" "1"
            cn_check_raspicam_faq_msg "${!device}"
            cn_deep_config_check_failed
        fi
    else
        cn_log_check_state_msg "device" "${!device}" "1"
        cn_deep_config_check_failed
    fi
}

cn_deep_config_check_resolution() {
    local resolution
    resolution="CN_CAM_${1}_RESOLUTION"
    if [[ "${!resolution}" =~ ^[0-9]*[0-9]+x+[0-9]*[0-9]$ ]]; then
        cn_log_check_state_msg "resolution" "${!resolution}" "0"
        cn_log_msg " "
    else
        cn_log_check_state_msg "resolution" "${!resolution}" "1"
        cn_log_check_resolution_msg
        cn_deep_config_check_failed
    fi
}

cn_deep_config_check_max_fps() {
    local max_fps
    max_fps="CN_CAM_${1}_MAX_FPS"
    if [[ "${!max_fps}" =~ ^[0-9]+$ ]]; then
        cn_log_check_state_msg "max_fps" "${!max_fps}" "0"
        cn_log_msg " "
    else
        cn_log_check_state_msg "max_fps" "${!max_fps}" "1"
        cn_log_check_max_fps_msg
        cn_deep_config_check_failed
    fi
}

cn_deep_config_check_rtsp() {
    true
}

cn_deep_config_check_self_no_proxy() {
    if [[ -n "${CN_SELF_NO_PROXY}" ]]; then
        cn_self_no_proxy_deprecated_msg
    fi
}

# Going this way, because maybe it will be extended at some point
# gaining some more control, but dont overlength init func
cn_deep_config_check_deprecated_params() {
    cn_deep_config_check_self_no_proxy
}

cn_deep_config_check_failed() {
    cn_stopped_msg
    exit 1
}

cn_init_deep_config_check() {
    cn_log_sect_header "Configuration Check"
    cn_log_info_msg "Checking configured cam section(s) for possible errors ..."
    cn_log_msg " "

    cn_deep_config_check_deprecated_params

    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        cn_log_sect_header "Cam section: cam ${cam}"
        cn_log_msg " "

        cn_deep_config_check_mode "${cam}"

        cn_deep_config_check_port "${cam}"

        cn_deep_config_check_device "${cam}"

        cn_deep_config_check_resolution "${cam}"

        cn_deep_config_check_max_fps "${cam}"
    done
    # if [[ "${CN_DEV_MSG}" = "1" ]]; then
    #     printf "deep_config_check:\n###########\n"
    #     declare -p | grep "CN_"
    #     printf "###########\n"
    # fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: deep_config_check.sh\n"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefore...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
