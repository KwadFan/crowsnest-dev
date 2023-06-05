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
    prefix="$(date +'[%D %T]') crowsnest:"
    log_msg "INFO: Print Configfile: '${CROWSNEST_CFG}'"
    (sed '/^#.*/d;/./,$!d' | cut -d'#' -f1) < "${CROWSNEST_CFG}" | \
    while read -r line; do
        printf "%s\t\t%s\n" "${prefix}" "${line}" >> "${CROWSNEST_LOG_PATH}"
        printf "\t\t%s\n" "${line}"
    done
}
