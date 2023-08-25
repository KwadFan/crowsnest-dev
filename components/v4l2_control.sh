#!/usr/bin/env bash

#### v4l2_control.sh - get/set v4l2-ctl options

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

cn_get_v4l2ctl_array_name() {
    local array_name
    array_name="CN_CAM_${1}_V4L2CTL_ARRAY"
    printf "%s" "${array_name}"
}


# cn_get_v4l2ctl_values() {
#     local var values
#     var="CN_CAM_${1}_V4L2CTL"
#     values="$(echo "${!var}" | tr -d ' ')"
#     printf "%s\n" "${values}"
# }

cn_set_v4l2ctl_array() {
    local array_name cam v4l2ctl
    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        array_name="$(cn_get_v4l2ctl_array_name "${cam}")"
        array_name="${array_name/\'/}"
        v4l2ctl="CN_CAM_${cam}_V4L2CTL"
        declare -ag "${array_name}"
        declare -n target_array="${array_name}"
        # for x in $(cn_get_v4l2ctl_values "${cam}"); do
        #     target_array+=("${x}")
        # done
        IFS="," while read -r x; do
            target_array+=("${x}")
        done < <(echo "${!v4l2ctl// /}")
        unset "${IFS}"
        readonly -a "${array_name}"
    done
}

cn_set_v4l2ctl_bin_path() {
    local bin_path
    bin_path="$(command -v v4l2-ctl)"
    [[ -n "${bin_path}" ]] || bin_path="null"
    CN_V4L2CTL_BIN_PATH="${bin_path}"
    # shellcheck disable=SC2034
    declare -gr CN_V4L2CTL_BIN_PATH
}


cn_v4l2ctl_dev_has_ctrl() {
    local ctrl device has_ctrl valueless
    device="${1,,}"
    ctrl="${2,,}"
    valueless="$(echo "${ctrl}" | cut -f1 -d"=")"
    has_ctrl="$("${CN_V4L2CTL_BIN_PATH}" -d "${device}" -L 2> /dev/null)"
    #has_ctrl="$(echo "${has_ctrl}" | grep -c "${valueless}")"
    #printf "%s" "${has_ctrl}"
    if [[ "${has_ctrl}" =~ ${valueless} ]]; then
        printf "1"
    else
        printf "0"
    fi
}

cn_get_v4l2ctl_value() {
    local device value valueless
    device="${1,,}"
    value="${2,,}"
    if [[ "$(cn_v4l2ctl_dev_has_ctrl "${device}" "${value}")" != "0" ]]; then
        valueless="$(echo "${value}" | cut -f1 -d"=")"
        is_value="$("${CN_V4L2CTL_BIN_PATH}" -d "${device}" --get-ctrl "${valueless}")"
        is_value="${is_value/\: /=}"
        printf "%s\n" "${is_value}"
    fi
}

cn_set_v4l2ctl_value() {
    local device value
    device="${1,,}"
    value="${2,,}"
    is_value="$(cn_get_v4l2ctl_value "${device}" "${value}")"
    if [[ "$(cn_v4l2ctl_dev_has_ctrl "${device}" "${value}")" = "0" ]]; then
        cn_v4l2ctl_ctrl_not_supported_msg "${value/=.*/}"
    else
        cn_log_msg "bar"
    fi
}

cn_v4l2ctl_get_mode() {
    local cam mode
    cam="${1}"
    mode="CN_CAM_${cam}_MODE"
    if [[ "camera-streamer" = "${!mode}" ]]; then
        printf "1"
    else
        printf "0"
    fi
}

cn_v4l2ctl_external_iterator() {
    local array_name cam device
    cam="${1}"
    device="CN_CAM_${1}_DEVICE"
    array_name="CN_CAM_${1}_V4L2CTL_ARRAY[@]"
    for x in ${!array_name}; do
        has_ctrl="$(cn_v4l2ctl_dev_has_ctrl "${!device}" "${x}")"
        if [[ "${has_ctrl}" != "0" ]]; then
            cn_log_msg "DEBUG: ${x}"
        fi
    done
}

cn_v4l2ctl_main() {
    local array_name cam config device
    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        array_name="CN_CAM_${cam}_V4L2CTL_ARRAY[@]"
        device="CN_CAM_${cam}_DEVICE"
        config="CN_CAM_${cam}_V4L2CTL"
        config="$(echo "${!config}" | tr -d ' ')"
        cn_v4l2ctl_cam_sect_header_msg "${cam}"

        cn_v4l2ctl_cam_config_msg "${config}"

        if [[ "$(cn_v4l2ctl_get_mode "${cam}")" = "1" ]]; then
            cn_v4l2ctl_cs_skip_msg
        else
            for x in "${!array_name}"; do
                cn_set_v4l2ctl_value "${device}" "${x}"
            done
        fi

    done
}

cn_init_v4l2ctl() {

    cn_set_v4l2ctl_bin_path

    cn_set_v4l2ctl_array

    cn_log_sect_header "V4L2 Control"

    cn_v4l2ctl_main
    #cn_v4l2ctl_external_iterator "1"


    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "v4l2_control:\n###########\n"
        printf "Configured cams: %s\n" "${CN_CONFIGURED_CAMS[@]}"
        declare -p | grep "CN_V4L2CTL_BIN_PATH"
        declare -p | grep "CN_CAM_.*_V4L2CTL"
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: v4l2_control.sh\n"
fi
