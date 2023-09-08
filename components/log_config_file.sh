#!/usr/bin/env bash

#### log_config_file.sh - write crowsnest configuration file to log

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

cn_print_cfg() {
    local cfg
    cn_log_debug_sect_header "Configfile: '${CN_CONFIG_FILE}'"
    # put a little whitespace here
    cn_log_msg " "
    mapfile -t cfg < <(sed '/^#.*/d;/./,$!d' "${CN_CONFIG_FILE}" | cut -d'#' -f1)
    for i in "${cfg[@]}"; do
        if [[ -n "${CN_SELF_LOG_PATH}" ]]; then
            printf "DEBUG: %s\t\t%s\n" "$(cn_log_prefix)" "${i}" >> "${CN_SELF_LOG_PATH}"
        fi
        printf "DEBUG: \t%s\n" "${i}"
    done
    # put a little whitespace here
    cn_log_msg " "
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_config_file.sh\n"
fi
