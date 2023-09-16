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

CN_DOCS_MODE_CFG="/configuration/cam-section#mode"
declare -gr CN_DOCS_MODE_CFG

CN_DOCS_PORT_CFG="/configuration/cam-section#port"
declare -gr CN_DOCS_PORT_CFG

CN_DOCS_DEV_CFG="/configuration/cam-section#device"
declare -gr CN_DOCS_DEV_CFG

CN_DOCS_RESOLUTION_CFG="/configuration/cam-section#resolution"
declare -gr CN_DOCS_RESOLUTION_CFG

CN_DOCS_MAX_FPS_CFG="/configuration/cam-section#max_fps"
declare -gr CN_DOCS_MAX_FPS_CFG

CN_DOCS_FAQ_RASPICAM="/faq/how-to-setup-a-raspicam"
declare -gr CN_DOCS_FAQ_RASPICAM

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

cn_no_usable_backends_msg() {
    cn_log_err_msg "No usable backends found!"
    cn_stopped_msg
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

cn_note_by-id_msg() {
    cn_log_info_msg "ATTENTION: It is not recommended to use /dev/video[0-9] path! \
Use 'by-id' instead!"
    # put some whitespace here
    cn_log_msg " "
}

cn_libcamera_dev_msg() {
    cn_log_sect_header "Libcamera Raspicam found!"
    # put some whitespace here
    cn_log_msg " "
}

cn_libcamera_dev_info_msg() {
    cn_log_msg " "
    cn_log_msg "Libcamera device information:"
    for x in "${CN_LIBCAMERA_OUTPUT_ARRAY[@]:2}"; do
        cn_log_msg "${x}"
    done
    cn_log_msg " "
}

cn_libcamera_dev_ctrls_msg() {
    cn_log_msg "Supported Controls:"
    cn_log_msg " "
    for x in "${CN_LIBCAMERA_CTRLS_ARRAY[@]}"; do
        cn_log_msg "    ${x}"
    done
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
    cn_log_sect_header "Stream initialisation"
    cn_log_msg " "
    cn_log_msg "Try to start configured cams / services..."
    # put some whitespace here
    cn_log_msg " "
}

cn_streamer_init_msg() {
    cn_log_info_msg "Trying to launch ${1} for [cam ${2}] ..."
    # put some whitespace here
    cn_log_msg " "
}

cn_streamer_failed_msg() {
    cn_log_err_msg "Start of ${1} [cam ${2}] failed or application crashed ..."
}

cn_streamer_param_msg() {
    cn_log_debug_msg "${1} parameters of [cam ${2}]: ${3}"
}

cn_v4l2ctl_cam_sect_header_msg() {
    cn_log_sect_header "V4L2 Control: [cam ${1}]"
    # put some whitespace here
    cn_log_msg " "
}

cn_v4l2ctl_cam_config_msg() {
    cn_log_msg "Configuration: ${1}"
    # put some whitespace here
    cn_log_msg " "
}

cn_v4l2ctl_cs_skip_msg() {
    cn_log_info_msg "You configured 'mode: camera-streamer!"
    cn_log_info_msg "In this case, v4l2ctl will be done by camera-streamer"
    cn_log_info_msg "Configuration due 'v4l2-ctl' skipped ..."
    # put some whitespace here
    cn_log_msg " "
}

cn_v4l2ctl_set_header_msg() {
    local ctrl value
    ctrl="$(cut -f1 -d'=' <<< "${1}")"
    value="$(cut -f2 -d'=' <<< "${1}")"
    cn_log_msg "Trying to set '${ctrl}' to '${value}' ..."
}

cn_v4l2ctl_set_success_msg() {
    local ctrl value
    ctrl="$(cut -f1 -d'=' <<< "${1}")"
    value="$(cut -f2 -d'=' <<< "${1}")"
    cn_log_msg "Success setting '${ctrl}' to '${value}'."
    # put some whitespace here
    cn_log_msg " "
}

cn_v4l2ctl_set_failed_msg() {
    local ctrl value
    ctrl="$(cut -f1 -d'=' <<< "${1}")"
    value="$(cut -f2 -d'=' <<< "${1}")"
    cn_log_warn_msg "Failed to set '${ctrl}' to '${value}' (tried ${2} times)."
}

cn_v4l2ctl_set_giveup_msg() {
    local ctrl value
    ctrl="$(cut -f1 -d'=' <<< "${1}")"
    value="$(cut -f2 -d'=' <<< "${1}")"
    cn_log_err_msg "Given up to set '${ctrl}' to '${value}'."
    cn_v4l2ctl_allowed_range_msg
    # put some whitespace here
    cn_log_msg " "
}

cn_v4l2ctl_allowed_range_msg() {
    cn_log_info_msg "Value might be out of allowed range."
    cn_log_info_msg "Please see 'Supported Controls:' block of this cam for details!"
}

cn_v4l2ctl_ctrl_not_supported_msg() {
    cn_log_err_msg "V4L2 Control '${1}' is not supported! Setup skipped ..."
    # put some whitespace here
    cn_log_msg " "
}

cn_log_check_state_msg() {
    if [[ "${3}" = "0" ]]; then
        cn_log_msg "CHECK: Parameter '${1}' is set to '${2}' ... [PASSED]"
    fi
    if [[ "${3}" = "1" ]]; then
        cn_log_msg "CHECK: Parameter '${1}' is set to '${2}' ... [FAILED]"
    fi
    if [[ "${3}" = "2" ]]; then
        cn_log_msg "CHECK: Parameter '${1}' is set to '${2}' ... [WARN]"
    fi
}

cn_log_check_mode_failed_msg() {
    cn_log_err_msg "You set 'mode: ${1}', invalid entry!"
    cn_log_info_msg "Please use one of the following modes ..."

    for x in "${CN_AVAIL_BACKENDS[@]}"; do
        cn_log_info_msg "    mode: ${x}"
    done

    cn_log_info_msg "For details please see ${CN_DOCS_BASE_URL}${CN_DOCS_MODE_CFG}."

    cn_log_msg " "
}

cn_log_check_port_failed_msg() {
    cn_log_err_msg "You set 'port: ${1}', invalid entry!"

    cn_log_info_msg "Please use only integers in range of 1 - 65535 !"

    cn_log_info_msg "For details please see ${CN_DOCS_BASE_URL}${CN_DOCS_PORT_CFG}."

    cn_log_msg " "
}

cn_log_check_dev_path_msg() {
    cn_log_check_state_msg "device" "${1}" "2"

    cn_log_msg "CHECK (WARN): Using '${1}' may lead to unexpected behaviour(s)!"

    cn_log_msg "CHECK (WARN): Please use '/dev/v4l/by-id' or '/dev/v4l/by-path' instead!"

    cn_log_msg "CHECK (WARN): Valid device path(s):"

    for x in "${CN_UVC_VALID_DEVICES[@]}"; do
        if [[ "${x}" =~ "/dev/v4l" ]]; then
            cn_log_msg "CHECK (WARN):     ${x}"
        fi
    done

    cn_log_info_msg "For details please see ${CN_DOCS_BASE_URL}${CN_DOCS_DEV_CFG}."

    cn_log_msg " "
}

cn_check_raspicam_faq_msg() {
    cn_log_err_msg "Path '${1}' is not a valid device path!"

    cn_log_info_msg "For details please see ${CN_DOCS_BASE_URL}${CN_DOCS_FAQ_RASPICAM}."

    cn_log_msg " "
}

cn_log_check_resolution_msg() {
    cn_log_err_msg "Formatting of parameter 'resolution' does not match!"

    cn_log_err_msg "Allowed format is (INT)x(INT) (e.g. 1920x1080)"

    cn_log_info_msg "Please ensure to use a lowercase 'x' as divider!"

    cn_log_info_msg "For details please see ${CN_DOCS_BASE_URL}${CN_DOCS_RESOLUTION_CFG}."

    cn_log_msg " "
}

cn_log_check_max_fps_msg() {
    cn_log_err_msg "For parameter 'max_fps' only integers are allowed!"

    cn_log_info_msg "For details please see ${CN_DOCS_BASE_URL}${CN_DOCS_MAX_FPS_CFG}."

    cn_log_msg " "
}

cn_self_no_proxy_deprecated_msg() {
    cn_log_warn_msg "Parameter 'no_proxy' in section '[crowsnest]' is deprecated!"
    cn_log_warn_msg "Please move 'no_proxy' to the desired cam section!"
    cn_log_msg " "
}


if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: messages.sh\n"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefor...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
