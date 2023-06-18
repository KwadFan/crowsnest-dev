#!/usr/bin/env bash

#### hw_libcamera.sh - libamera related stuff

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

CN_LIBCAMERA_BIN_PATH=""
CN_LIBCAMERA_AVAIL="0"
CN_LIBCAMERA_OUTPUT_ARRAY=()
CN_LIBCAMERA_DEV_PATH=""

cn_check_libcamera_hello_bin() {
    local bin
    bin="$(command -v libcamera-hello)"
    if [[ -x "${bin}" ]]; then
        CN_LIBCAMERA_BIN_PATH="${bin}"
    else
        CN_LIBCAMERA_BIN_PATH="null"
    fi
    declare -gr CN_LIBCAMERA_BIN_PATH
}

cn_set_libcamera_avail() {
    if [[ "${CN_LIBCAMERA_BIN_PATH}" != "null" ]]; then
        CN_LIBCAMERA_AVAIL="1"
    fi
    declare -gr CN_LIBCAMERA_AVAIL
}

cn_set_libcamera_output_array() {
    if [[ "${CN_LIBCAMERA_AVAIL}" = "1" ]]; then
        readarray -t CN_LIBCAMERA_OUTPUT_ARRAY < <("${CN_LIBCAMERA_BIN_PATH}" --list-cameras)
    fi
    declare -gr CN_LIBCAMERA_OUTPUT_ARRAY
}

cn_get_libcamera_dev_path() {
    cut -f2 -d'(' <<< "${CN_LIBCAMERA_OUTPUT_ARRAY[*]}" | cut -f1 -d')'
}

cn_set_libcamera_dev_path() {
    if [[ "${CN_LIBCAMERA_AVAIL}" = "1" ]]; then
        CN_LIBCAMERA_DEV_PATH="$(cn_get_libcamera_dev_path)"
        # shellcheck disable=SC2034
        declare -gr CN_LIBCAMERA_DEV_PATH
    fi
}

cn_get_libcamera_dev_count() {
    if [[ -n "$(cn_get_libcamera_dev_path)" ]]; then
        printf "1"
    else
        printf "0"
    fi
}

cn_init_hw_libcamera() {

    cn_check_libcamera_hello_bin

    cn_set_libcamera_avail

    cn_set_libcamera_output_array

    cn_set_libcamera_dev_path

    cn_set_libcamera_dev_count

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "hw_libcamera:\n###########\n"
        declare -p | grep "CN_LIBCAMERA"
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: hw_libcamera.sh\n"
fi
