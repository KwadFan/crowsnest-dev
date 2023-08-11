#!/usr/bin/env bash

#### config_cam_obj.sh - put configuration values into an array

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


if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: config_cam_obj.sh\n"
fi
