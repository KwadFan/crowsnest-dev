#!/usr/bin/env bash

#### log_supported_res.sh - Write supported resolutions to log

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




# cn_init_hw_legacy() {
#     if [[ "${CN_LIBCAMERA_DEV_PATH}" == "null" ]]; then
#         cn_get_vcgencmd_path

#         cn_get_legacy_dev_avail

#         cn_get_legacy_dev_path
#     fi


#     if [[ "${CN_DEV_MSG}" = "1" ]]; then
#         printf "hw_legacy_cam:\n###########\n"
#         declare -p | grep "CN_LEGACY"
#         printf "###########\n"
#     fi
# }

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_supported_res.sh\n"
fi
