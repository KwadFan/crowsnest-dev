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
        cn_log_check_state_msg "Mode" "${!mode_sect}" "0"
    else
        cn_log_check_state_msg "Mode" "${!mode_sect}" "1"

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
        cn_log_warn_msg "Use better option"
    elif [[ "${CN_UVC_VALID_DEVICES[*]}" =~ ${!device} ]]; then
        cn_log_msg "passed ..."
    else
        cn_log_msg "not valid entry..."

        cn_deep_config_check_failed
    fi
}

cn_deep_config_check_resolution() {
    true
}

cn_deep_config_check_max_fps() {
    true
}

cn_deep_config_check_rtsp() {
    true
}

cn_deep_config_check_failed() {
    cn_stopped_msg

    exit 1
}

cn_init_deep_config_check() {
    cn_log_sect_header "Configuration Check"
    cn_log_info_msg "This will check your cam sections for possible errors ..."
    cn_log_msg " "

    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        cn_log_sect_header "Cam section: cam ${cam}"

        cn_deep_config_check_mode "${cam}"

        cn_deep_config_check_port "${cam}"

        cn_deep_config_check_device "${cam}"

        # cn_deep_config_check_max_fps "${cam}"

        # cn_deep_config_check_resolution "${cam}"

        cn_log_msg " "

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
