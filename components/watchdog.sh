#!/usr/bin/env bash

#### watchdog.sh - check for lost camera devices while running
####
#### crowsnest - A webcam Service for multiple Cams and Stream Services.
####
#### Written by Stephan Wendel aka KwadFan <me@stephanwe.de>
#### Copyright 2021 - till today
#### https://github.com/mainsail-crew/crowsnest
####
#### This File is distributed under GPLv3
####

#### Note: Even if DRY paradigm should be obeyed, isolate watchdog from other
####       parts of the application.

# shellcheck enable=require-variable-braces

# Exit upon Errors
set -Ee

CN_WATCHDOG_DEVICE_ARRAY=()
CN_WATCHDOG_SLEEP_TIME="120"
CN_WATCHDOG_LOST_DEV_ARRAY=()

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    CN_WATCHDOG_SLEEP_TIME="5"
fi

declare -gr CN_WATCHDOG_SLEEP_TIME
declare -ag CN_WATCHDOG_LOST_DEV_ARRAY

### msg's
cn_watchdog_next_check_msg() {
    local prefix
    prefix="WATCHDOG:"
    cn_log_msg "${prefix} Next check in ${CN_WATCHDOG_SLEEP_TIME} seconds ..."
}

cn_watchdog_lost_dev_msg() {
    local prefix
    prefix="WATCHDOG:"
    cn_log_msg " "
    cn_log_msg "${prefix} Lost device '${1}' !!!!"
    cn_watchdog_next_check_msg
    cn_log_msg " "
}

cn_watchdog_returned_dev_msg() {
    local prefix
    prefix="WATCHDOG:"
    cn_log_msg " "
    cn_log_msg "${prefix} Device '${1}' returned ..."
    cn_watchdog_next_check_msg
    cn_log_msg " "
}

cn_watchdog_still_missing_msg() {
    local prefix
    prefix="WATCHDOG:"
    cn_log_msg " "
    cn_log_msg "${prefix} Still missing ${1} device(s) ..."
}

cn_watchdog_still_missing_dev_msg() {
    local prefix
    prefix="WATCHDOG:"
    for x in ${1}; do
        cn_log_msg "${prefix}    ${x}"
    done
    cn_watchdog_next_check_msg
    cn_log_msg " "
}

cn_watchdog_set_device_array() {
    cn_log_debug_msg "Gathering device list ..."
    if [[ "${CN_UVC_BY_ID[0]}" != "null" ]]; then
        for x in "${CN_UVC_VALID_DEVICES[@]}"; do
            CN_WATCHDOG_DEVICE_ARRAY+=( "${x}" )
        done
    fi
    if [[ "${CN_LIBCAMERA_DEV_PATH}" != "null" ]]; then
        CN_WATCHDOG_DEVICE_ARRAY+=( "${CN_LIBCAMERA_DEV_PATH}" )
    fi
    if [[ "${CN_LEGACY_DEV_PATH}" != "null" ]]; then
        CN_WATCHDOG_DEVICE_ARRAY+=( "${CN_LEGACY_DEV_PATH}" )
    fi
}

cn_watchdog_remove_dev_from_array() {
    for i in "${!CN_WATCHDOG_LOST_DEV_ARRAY[@]}"; do
        if [[ "${CN_WATCHDOG_LOST_DEV_ARRAY[${i}]}" = "${1}" ]]; then
            unset "${CN_WATCHDOG_LOST_DEV_ARRAY[${i}]}"
        fi
    done
}

cn_watchdog_debug_print_devices() {
    cn_log_debug_msg  "-------- Watchdog: devices list --------"
    for x in "${CN_WATCHDOG_DEVICE_ARRAY[@]}"; do
        # for simplicity hardcode a 'tab'
        cn_log_debug_msg "    ${x}"
    done
}

cn_watchdog_runtime() {
    local prefix
    sleep "${CN_WATCHDOG_SLEEP_TIME}"
    for x in "${CN_WATCHDOG_DEVICE_ARRAY[@]}"; do
        # filter to by_id only!
        if [[ "${x}" =~ "/dev/v4l/by-id" ]]; then
            if [[ ! "${CN_WATCHDOG_LOST_DEV_ARRAY[*]}" =~ ${x} ]] \
            && [[ ! -e "${x}" ]]; then
                CN_WATCHDOG_LOST_DEV_ARRAY+=("${x}")
                cn_watchdog_lost_dev_msg "${x}"
            elif [[ "${#CN_WATCHDOG_LOST_DEV_ARRAY[*]}" -gt "0" ]] \
            && [[ ! -e "${x}" ]]; then
                cn_watchdog_still_missing_msg "${#CN_WATCHDOG_LOST_DEV_ARRAY[@]}"
                cn_watchdog_still_missing_dev_msg "${CN_WATCHDOG_LOST_DEV_ARRAY[*]}"
            elif [[ "${CN_WATCHDOG_LOST_DEV_ARRAY[*]}" =~ ${x} ]] \
            && [[ -e "${x}" ]]; then
                cn_watchdog_returned_dev_msg "${x}"
                if [[ "${#CN_WATCHDOG_LOST_DEV_ARRAY[@]}" -gt "1" ]]; then
                    cn_watchdog_remove_dev_from_array "${x}"
                else
                    CN_WATCHDOG_LOST_DEV_ARRAY=()
                fi
            fi
        fi
    done
    ### Let inplace commented out for debugging
    # if [[ "${CN_DEV_MSG}" = "1" ]]; then
    #     printf "watchdog:\n###########\n"
    #     declare -p | grep "CN_WATCHDOG"
    #     printf "###########\n"
    # fi
}

cn_init_watchdog() {

    cn_log_sect_header "Watchdog"

    cn_log_info_msg "Initializing watchdog ..."

    cn_watchdog_set_device_array

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "watchdog:\n###########\n"
        declare -p | grep "CN_WATCHDOG"
        printf "###########\n"
    fi

    cn_watchdog_debug_print_devices
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: watchdog.sh\n"
fi
