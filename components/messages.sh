#!/usr/bin/env bash

#### message.sh -

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

## Message Helpers

## core lib


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
