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
    local prefix
    prefix="$(date +'[%D %T]')"
    cn_log_msg "-------- Configfile: '${CN_CONFIG_FILE}' --------"
    (sed '/^#.*/d;/./,$!d' | cut -d'#' -f1) < "${CN_CONFIG_FILE}" | \
    while read -r line; do
        if [[ -n "${CN_SELF_LOG_PATH}" ]]; then
            printf "%s\t%s\n" "${prefix}" "${line}" >> "${CN_SELF_LOG_PATH}"
        fi
        printf "\t%s\n" "${line}"
    done
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_config_file.sh\n"
fi
