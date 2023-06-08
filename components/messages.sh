#!/usr/bin/env bash

#### message.sh - reusable messages

#### crowsnest - A webcam Service for multiple Cams and Stream Services.
####
#### Written by Stephan Wendel aka KwadFan <me@stephanwe.de>
#### Copyright 2021
#### https://github.com/mainsail-crew/crowsnest
####
#### This File is distributed under GPLv3
####

# shellcheck enable=require-variable-braces

# Exit upon Errors
set -Ee

CN_DOCS_BASE_URL="https://crowsnest.mainsail.xyz"
declare -gr CN_DOCS_BASE_URL

CN_DOCS_CAM_SECTION="/configuration/cam-section"
declare -gr CN_DOCS_CAM_SECTION


cn_stopped_msg() {
    cn_log_msg "ERROR: Stopping $(basename "$0")."
    cn_log_msg "Goodbye..."
}

cn_config_file_missing() {
    cn_log_msg "ERROR: Given configuration file '${CROWSNEST_CONFIG_FILE}' doesn't exist!"
    cn_stopped_msg
}

cn_missing_cam_section_msg() {
    cn_log_msg "ERROR: No cameras configured! Please see ${CN_DOCS_BASE_URL}${CN_DOCS_CAM_SECTION}."
    cn_stopped_msg
}

function deprecated_msg_1 {
    cn_log_msg "Parameter 'streamer' is deprecated!"
    cn_log_msg "Please use mode: [ mjpg | multi ]"
    cn_log_msg "ERROR: Please update your crowsnest.conf! Stopped."
}

function unknown_mode_msg {
    cn_log_msg "WARN: Unknown Mode configured!"
    cn_log_msg "WARN: Using 'mode: mjpg' as fallback!"
}

## v4l2_control lib
function detected_broken_dev_msg {
    cn_log_msg "WARN: Detected 'brokenfocus' device."
    cn_log_msg "INFO: Trying to set to configured Value."
}

# call debug_focus_val_msg <value>
# ex.: debug_focus_val_msg focus_absolute=30
function debug_focus_val_msg {
    cn_log_msg "DEBUG: Value is now: ${1}"
}

## blockyfix
function blockyfix_msg_1 {
    cn_log_msg "INFO: Blockyfix: Setting video_bitrate_mode to constant."
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: messages.sh\n"
fi
