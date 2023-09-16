#!/usr/bin/env bash

#### hw_legacy_cam.sh - Legacy cam stack (Raspicam) related stuff

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

cn_get_vcgencmd_path() {
    local vcgencmd_bin_path
    vcgencmd_bin_path="$(command -v vcgencmd)"
    [[ -n "${vcgencmd_bin_path}" ]] && CN_LEGACY_VCGENCMD_BIN="${vcgencmd_bin_path}" \
    || CN_LEGACY_VCGENCMD_BIN="null"
    # shellcheck disable=SC2034
    declare -gr CN_LEGACY_VCGENCMD_BIN
}

cn_get_legacy_dev_avail() {
    local legacy_avail
    if [[ "${CN_LEGACY_VCGENCMD_BIN}" != "null" ]] \
    && [[ "${CN_LIBCAMERA_DEV_PATH}" = "null" ]]; then
        legacy_avail="$("${CN_LEGACY_VCGENCMD_BIN}" get_camera | cut -d',' -f1)"
        [[ "${legacy_avail}" = "supported=1 detected=1" ]] \
        && CN_LEGACY_DEV_AVAIL="1" || CN_LEGACY_DEV_AVAIL="0"
    else
        CN_LEGACY_DEV_AVAIL="0"
    fi
    # shellcheck disable=SC2034
    declare -gr CN_LEGACY_DEV_AVAIL
}

cn_get_legacy_dev_count() {
    [[ "${CN_LEGACY_DEV_AVAIL}" = "1" ]] && printf "1" || printf "0"
}

cn_get_legacy_dev_path() {
    local dev_path v4l2ctl_bin
    v4l2ctl_bin="$(command -v v4l2-ctl)"
    if [[ "${CN_LEGACY_DEV_AVAIL}" = "1" ]]; then
        dev_path="$(
            ${v4l2ctl_bin} --list-devices | grep "mmal" -A 1 \
            | sed '1d;s/^[[:blank:]]//g'
            )"
        [[ "${dev_path}" =~ ^/dev/video[0-9] ]] \
        && CN_LEGACY_DEV_PATH="${dev_path}"
    else
        CN_LEGACY_DEV_PATH="null"
    fi
    #shellcheck disable=SC2034
    declare -gr CN_LEGACY_DEV_PATH
}

cn_init_hw_legacy() {
    cn_get_vcgencmd_path

    cn_get_legacy_dev_avail

    cn_get_legacy_dev_path

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "hw_legacy_cam:\n###########\n"
        declare -p | grep "CN_LEGACY"
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: hw_legacy_cam.sh\n"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefor...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
