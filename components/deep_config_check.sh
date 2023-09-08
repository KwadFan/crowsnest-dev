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

        cn_stopped_msg

        exit 1
    fi
}

cn_init_deep_config_check() {

    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        cn_log_sect_header "Configuration Check"
        cn_log_info_msg "This will check your configration file for possible errors ..."
        cn_log_msg " "
        cn_log_sect_header "Cam section: cam ${cam}"

        cn_deep_config_check_mode "${cam}"

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
