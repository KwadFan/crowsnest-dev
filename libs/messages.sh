#!/bin/bash

#### message library

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
function missing_args_msg {
    echo -e "crowsnest: Missing Arguments!"
    echo -e "\n\tTry: crowsnest -h\n"
}

function wrong_args_msg {
    echo -e "crowsnest: Wrong Arguments!"
    echo -e "\n\tTry: crowsnest -h\n"
}

function help_msg {
    echo -e "crowsnest - webcam deamon\nUsage:"
    echo -e "\t crowsnest [Options]"
    echo -e "\n\t\t-h Prints this help."
    echo -e "\n\t\t-v Prints Version of crowsnest."
    echo -e "\n\t\t-c </path/to/configfile>\n\t\t\tPath to your webcam.conf\n"
}

function deprecated_msg_1 {
    log_msg "Parameter 'streamer' is deprecated! Please use mode: [ mjpg | multi ] ..."
}

function unknown_mode_msg {
    log_msg "WARN: Unknown Mode configured! Using 'mode: ustreamer' as fallback! ..."
}

## v4l2_control lib
function detected_broken_dev_msg {
    log_msg "WARN: Detected 'brokenfocus' device. Trying to set to configured Value."
}

# call debug_focus_val_msg <value>
# ex.: debug_focus_val_msg focus_absolute=30
function debug_focus_val_msg {
    log_msg "DEBUG: Value is now: ${1}"
}

## blockyfix
function blockyfix_msg_1 {
    log_msg "INFO: Blockyfix: Setting video_bitrate_mode to constant."
}

function no_usable_device_msg {
    log_msg "ERROR: No usable Devices Found. Stopping $(basename "${0}"). \
If a USB webcam connected, please see https://crowsnest.mainsail.xyz/faq/how-to-use-v4l2-ctl, \
if a Raspicam is connected, please see https://crowsnest.mainsail.xyz/faq/how-to-setup-a-raspicam"
}

function legacy_stack_msg {
    log_msg "WARN: Detected legacy camera stack, disable it by removing 'start_x=1' in '/boot/config.txt'"
}

function camautodetect_msg {
    log_msg "WARN: Detected 'camera_auto_detect=0', this disables raspicam detection. \
Change '0' to '1' in '/boot/config.txt' to enable it."
}
