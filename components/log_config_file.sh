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
set -e

cn_print_cfg() {
    local cfg
    cn_log_sect_header "Configfile: '${CN_CONFIG_FILE}'"
    cn_log_msg "This section is only shown, if 'log_level: debug' is set!"
    # put a little whitespace here
    cn_log_msg " "
    # mapfile -t cfg < <(sed '/^#.*/d;/./,$!d' "${CN_CONFIG_FILE}" | cut -d'#' -f1)
    mapfile -t cfg < <(cut -d'#' -f1 < "${CN_CONFIG_FILE}")
    for i in "${cfg[@]}"; do
        if [[ -n "${CN_SELF_LOG_PATH}" ]]; then
            printf "%s\t\t%s\n" "$(cn_log_prefix)" "${i}" >> "${CN_SELF_LOG_PATH}"
        fi
        printf "\t%s\n" "${i}"
    done
    # put a little whitespace here
    cn_log_msg " "

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "log_config_file.sh:\n###########\n"
        for x in "${cfg[@]}"; do
            printf "cfg array: %s\n" "${x}"
        done
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_config_file.sh\n"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefore...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
