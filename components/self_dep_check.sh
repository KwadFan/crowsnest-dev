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
set -Ee


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
    for dep in "${CN_SELF_DEPS[@]}"; do
        cn_check_dep "${dep}"
    done
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: self_dep_check.sh\n"
fi

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Dependencies: %s" "${CN_SELF_DEPS[@]}"
fi
