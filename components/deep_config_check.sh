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
        cn_log_msg "CHECK: Mode is set to '${!mode_sect}' ... [PASSED]"
    else
        cn_log_msg "CHECK: Mode is set to ${!mode_sect} ... [FAILED]"
        cn_log_err_msg "You set '${!mode_sect}'! This is not a valid mode!"
        cn_log_info_msg "Please use one of the following modes ..."

        for x in "${CN_AVAIL_BACKENDS[@]}"; do
            cn_log_info_msg "    ${x}"
        done

        cn_log_info_msg "For details please visit https://crowsnest.mainsail.xyz/configuration/cam-section#mode"

        cn_log_msg " "

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
