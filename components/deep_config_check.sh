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



cn_init_deep_config_check() {

    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        cn_log_msg "Hello ${cam}"
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
