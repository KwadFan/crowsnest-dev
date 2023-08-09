#!/usr/bin/env bash

#### message.sh - reusable messages

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

CN_DOCS_BASE_URL="https://crowsnest.mainsail.xyz"
declare -gr CN_DOCS_BASE_URL

CN_DOCS_LOG_LEVEL="/configuration/crowsnest-section#log_level"
declare -gr CN_DOCS_LOG_LEVEL

CN_DOCS_CAM_SECTION="/configuration/cam-section"
declare -gr CN_DOCS_CAM_SECTION

cn_missing_args_msg() {
    printf "%s\n" "${CN_SELF_TITLE}"
    printf "\nERROR: Missing arguments!\n"
    printf "\n\tTry: crowsnest -h\n"
    printf "\n"
}

cn_wrong_args_msg() {
    printf "%s\n" "${CN_SELF_TITLE}"
    printf "\nERROR: Wrong Arguments!\n"
    printf "\n\tTry: crowsnest -h\n"
    printf "\n"
}

cn_help_msg() {
    printf "%s\n" "${CN_SELF_TITLE}"
    printf "\nUsage:\t crowsnest [Options]"
    printf "\n\t\t-h Prints this help."
    printf "\n\t\t-v Prints Version of crowsnest."
    printf "\n\t\t-c </path/to/configfile>\n\t\t\tPath to your webcam.conf\n"
    printf "\n"
}

cn_missing_cfg_path() {
    printf "%s\n" "${CN_SELF_TITLE}"
    printf "\nERROR: No configuration file path specified!\n"
    printf "\n\tTry: crowsnest -c /path/to/configfile\n"
    printf "\n"
}

cn_stopped_msg() {
    cn_log_err_msg "Stopping $(basename "${0}")."
    cn_log_msg "Goodbye..."
}

cn_config_file_missing() {
    cn_log_err_msg "Given configuration file '${CROWSNEST_CONFIG_FILE}' doesn't exist!"
    cn_stopped_msg
}

cn_log_level_invalid_msg(){
    cn_log_warn_msg "Set log_level: ${1} is invalid! Please see ${CN_DOCS_BASE_URL}${CN_DOCS_LOG_LEVEL}."
    cn_stopped_msg
}

cn_missing_cam_section_msg() {
    cn_log_err_msg "No cameras configured! Please see ${CN_DOCS_BASE_URL}${CN_DOCS_CAM_SECTION}."
    cn_stopped_msg
}

cn_streamer_not_found_msg() {
    cn_log_warn_msg "Backend '${1}' not found! Can't be configured as mode!"
}

# discussable ...
# cn_legacy_stack_msg() {
#     cn_log_msg "WARN: Legacy camera stack enabled! \
# Disable it by removing all occurencies of 'start_x=1' in '/boot/config.txt'"
# }

cam_auto_detect_disabled_msg() {
    cn_log_warn_msg "Found 'camera_auto_detect=0', this disables raspicam detection. \
Set to 'camera_auto_detect=1' in '/boot/config.txt' to enable it."
}

cam_auto_detect_enabled_msg() {
    cn_log_info_msg "Detected 'libcamera' stack enabled (camera_auto_detect=1) ..."
}

cn_camera_count_msg() {
    cn_log_info_msg "Found ${1} total available camera(s)"
    # put some whitespace here
    cn_log_msg " "
}

cn_no_usable_cams_found_msg() {
    cn_log_err_msg "No usable camera(s) found!"
    cn_stopped_msg
}

cn_uvc_model_twin_detection_msg() {
    true
}

cn_uvc_dev_msg() {
    cn_log_sect_header "UVC device: ${1} found!"
    # put some whitespace here
    cn_log_msg " "
}

cn_legacy_dev_msg() {
    cn_log_sect_header "Legacy Raspicam found!"
    # put some whitespace here
    cn_log_msg " "
}

cn_dev_video_path_msg() {
    cn_log_msg "Device path: ${1}"
}

cn_dev_byid_path_msg() {
    cn_log_msg "Device path (by-id): ${1}"
}

cn_dev_bypath_path_msg() {
    cn_log_msg "Device path (by-path): ${1}"
}

cn_libcamera_dev_msg() {
    cn_log_sect_header "Libcamera Raspicam found!"
    # put some whitespace here
    cn_log_msg " "
}

cn_supported_formats_msg() {
    cn_log_msg "Supported formats:"
    # put some whitespace here
    cn_log_msg " "
}

cn_supported_ctrls_msg() {
    cn_log_msg "Supported controls:"
    # put some whitespace here
    cn_log_msg " "
}

cn_init_streams_msg_header() {
    cn_log_msg "Try to start configured cams / services..."
    # put some whitespace here
    cn_log_msg " "
}

# below marked as deprecated!
# function deprecated_msg_1 {
#     cn_log_msg "Parameter 'streamer' is deprecated!"
#     cn_log_msg "Please use mode: [ mjpg | multi ]"
#     cn_log_msg "ERROR: Please update your crowsnest.conf! Stopped."
# }

# function unknown_mode_msg {
#     cn_log_msg "WARN: Unknown Mode configured!"
#     cn_log_msg "WARN: Using 'mode: mjpg' as fallback!"
# }

# ## v4l2_control lib
# function detected_broken_dev_msg {
#     cn_log_msg "WARN: Detected 'brokenfocus' device."
#     cn_log_msg "INFO: Trying to set to configured Value."
# }

# # call debug_focus_val_msg <value>
# # ex.: debug_focus_val_msg focus_absolute=30
# function debug_focus_val_msg {
#     cn_log_msg "DEBUG: Value is now: ${1}"
# }

# ## blockyfix
# function blockyfix_msg_1 {
#     cn_log_msg "INFO: Blockyfix: Setting video_bitrate_mode to constant."
# }

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: messages.sh\n"
fi
