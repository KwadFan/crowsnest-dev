#!/bin/bash

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
set -Ee

cn_self_version() {
    pushd "${CN_WORKDIR_PATH}" &> /dev/null
    git describe --always --tags
    popd &> /dev/null
}

cn_self_version_msg() {
    printf "%s\n" "${CN_SELF_TITLE}"
    printf "\tVersion: %s\n" "$(self_version)"
}
