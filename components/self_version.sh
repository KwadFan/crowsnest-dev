#!/usr/bin/env bash

#### self_version.sh - determine crowsnest local version

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

cn_self_version() {
    pushd "${CN_WORKDIR_PATH}" &> /dev/null
    git describe --always --tags
    popd &> /dev/null
}

cn_self_version_msg() {
    printf "%s\n" "${CN_SELF_TITLE}"
    printf "\n\tVersion: %s\n" "$(cn_self_version)"
    printf "\n"
}

cn_version_log_msg() {
    cn_log_msg "Version: $(cn_self_version)"
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: self_version.sh\n"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefore...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
