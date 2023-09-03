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

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    CN_WATCHDOG_SLEEP_TIME="5"
fi

declare -gr CN_WATCHDOG_SLEEP_TIME

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

cn_set_watchdog_device_array() {
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

cn_watchdog_debug_print_devices() {
    cn_log_debug_msg  "-------- Watchdog: devices list --------"
    for x in "${CN_WATCHDOG_DEVICE_ARRAY[@]}"; do
        # for simplicity hardcode a 'tab'
        cn_log_debug_msg "    ${x}"
    done
}

cn_watchdog_runtime() {
    local prefix
    local -a lost_dev
    lost_dev=()
    sleep "${CN_WATCHDOG_SLEEP_TIME}"
    for x in "${CN_WATCHDOG_DEVICE_ARRAY[@]}"; do
        # filter to by_id only!
        if [[ "${x}" =~ "/dev/v4l/by-id" ]]; then
            if [[ "${#lost_dev[@]}" -eq "0" ]] && [[ ! -e "${x}" ]]; then
                lost_dev+=("${x}")
                cn_watchdog_lost_dev_msg "${x}"
            fi
            # elif [[ "${lost_dev[*]}" =~ ${x} ]] && [[ -e "${x}" ]]; then
            #     cn_watchdog_returned_dev_msg "${x}"
            #     for i in "${!lost_dev[@]}"; do
            #         if [[ "${lost_dev[${i}]}" = "${x}" ]]; then
            #             unset "${lost_dev[${i}]}"
            #         fi
            #     done
            if [[ "${#lost_dev[@]}" -gt "0" ]] && [[ ! -e "${x}" ]]; then
                cn_log_msg " "
                cn_log_msg "${prefix} Still missing ${#lost_dev[*]} device(s) ..."
                for dev in "${lost_dev[@]}"; do
                    cn_log_msg "    ${dev}"
                done
                cn_log_msg " "
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

    cn_set_watchdog_device_array

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
