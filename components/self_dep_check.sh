#!/usr/bin/env bash

#### self_dep_check.sh - check crowsnest dependencies

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


cn_check_dep() {
    local dep
    dep="$(whereis "${1}" | awk '{print $2}')"
    if [[ -z "${dep}" ]]; then
        cn_log_msg "Dependency: '${1}' not found. Exiting!"
        exit 1
    else
        cn_log_msg "Dependency: '${1}' found in ${dep}."
    fi
}

cn_init_check_deps() {
    cn_log_sect_header "Dependencies:"
    for dep in "${CN_SELF_DEPS[@]}"; do
        cn_check_dep "${dep}"
    done
    # put a little whitespace here
    cn_log_msg " "
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: self_dep_check.sh\n"
fi

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Dependencies: %s\n" "${CN_SELF_DEPS[*]}"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefore...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
