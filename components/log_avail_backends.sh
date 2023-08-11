#!/usr/bin/env bash

#### log_config_backends.sh - test for avail backends and wirte infos to log

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

CN_CUR_USABLE_BACKENDS=(ustreamer camera-streamer)
declare -gar CN_CUR_USABLE_BACKENDS

CN_AVAIL_BACKENDS=()

cn_get_bin_path() {
    local cn_bin sys_bin path
    cn_bin="${CN_WORKDIR_PATH}/bin/${1}/${1}"
    sys_bin=$(command -v "${1}" || echo "")
    if [[ -x "${cn_bin}" ]]; then
        path="${cn_bin}"
    elif [[ -n "${sys_bin}" ]]; then
        path="${sys_bin}"
    else
        path=""
    fi
    echo "${path}"
}

cn_set_bin_path() {
    local bin expose_var
    bin="${1}"
    bin_path="$(cn_get_bin_path "${bin/\_/\-}")"
    if [[ -n "${bin_path}" ]]; then
        CN_AVAIL_BACKENDS+=("${bin}")
        if [[ "${bin_path}" =~ "camera-streamer" ]]; then
            bin="${bin/\-/\_}"
        fi
        expose_var="CN_${bin^^}_BIN_PATH=${bin_path}"
        declare -gr "${expose_var}"
        #CN_AVAIL_BACKENDS="$((CN_AVAIL_BACKENDS+1))"
    else
        cn_streamer_not_found_msg "${bin}"
        # if [[ "${CN_AVAIL_BACKENDS}" != 0 ]]; then
        #     CN_AVAIL_BACKENDS="$((CN_AVAIL_BACKENDS-1))"
        # fi
    fi
}

cn_check_avail_backends() {
    declare -gr CN_AVAIL_BACKENDS
    if [[ "${#CN_AVAIL_BACKENDS[*]}" -lt "1" ]]; then
        cn_no_usable_backends_msg
        exit 1
    fi
}

cn_log_streamer_info() {
    local bin
    for i in "${CN_CUR_USABLE_BACKENDS[@]}"; do
        bin="CN_${i^^}_BIN_PATH"
        if [[ "${bin_path}" =~ "camera-streamer" ]]; then
            bin="${bin/\-/\_}"
        fi
        if [[ -v "${bin}" ]] && [[ -n "${!bin}" ]]; then
            cn_log_msg "Backend '${i}' found in '${!bin}' ..."
        fi
    done
    # put a little whitespace here
    cn_log_msg " "
}

cn_init_check_backends() {
    cn_log_sect_header "Backends:"

    for backend in "${CN_CUR_USABLE_BACKENDS[@]}"; do
        cn_set_bin_path "${backend}"
    done

    cn_check_avail_backends

    cn_log_streamer_info

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "Backends:\n###########\n"
        declare -p | grep "CN_.*STREAMER_BIN_PATH"
        declare -p | grep "CN_AVAIL_BACKENDS"
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: log_config_backends.sh\n"
fi
