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

cn_init_watchdog() {

    cn_log_sect_header "Watchdog"

    cn_log_info_msg "Initializing watchdog ..."

    # if [[ "${CN_DEV_MSG}" = "1" ]]; then
    #     printf "watchdog:\n###########\n"
    #     declare -p | grep "CN_"
    #     printf "###########\n"
    # fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: watchdog.sh\n"
fi
