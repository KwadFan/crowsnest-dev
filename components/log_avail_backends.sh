#!/usr/bin/env bash

#### log_config_backends.sh - test for avail backends and wirte infos to log

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

CN_CUR_USABLE_BACKENDS=(ustreamer camera-streamer)
declare -gar CN_CUR_USABLE_BACKENDS

cn_init_check_backends() {
    echo "${CN_CUR_USABLE_BACKENDS[@]}"
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_config_backends.sh\n"
fi
