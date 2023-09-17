#!/usr/bin/env bash

#### configparser.sh - parse config file

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

cn_check_config_exist() {
    if [[ ! -f "${CN_CONFIG_FILE}" ]]; then
        cn_config_file_missing_msg
        exit 1
    fi
}

cn_get_all_sections() {
    crudini --existing=file --get "${CN_CONFIG_FILE}"
}

cn_get_section() {
    local cfg section
    cfg="${CN_CONFIG_FILE}"
    section="${1}"
    crudini --get "${cfg}" "${section}" 2> /dev/null
}

cn_get_param() {
    local cfg section param
    cfg="${CN_CONFIG_FILE}"
    section="${1}"
    param="${2}"
    crudini --get "${cfg}" "${section}" "${param}" 2> /dev/null | \
    sed "s/\#.*//;s/[[:space:]]*$//;s#^~#${HOME}#gi"
    return
}

cn_get_config() {
    local var_name section prefix
    local -a variables
    section="${1}"
    prefix="${2}"
    variables=()
    for param in $(cn_get_section "${section}"); do
        var_name="${prefix}${param^^}"
        variables+=( "${var_name}" )
    done
    echo "${variables[@]}"
}

cn_set_config() {
    local expose_var var_name section prefix
    local -a config
    section="${1}"
    prefix="${2}"
    config=()
    for var in $(cn_get_config "${section}" "${prefix}"); do
        var_name="${var}"
        var="${var/${prefix}/}"
        var="${var,,}"
        config+=("${var_name}=$(cn_get_param "${section}" "${var}")")
    done

    for expose_var in "${config[@]}"; do
        expose_var="${expose_var/\'/}"
        declare -g -r "${expose_var}"
    done
}

cn_set_cam_sections() {
    local cam_sections
    cam_sections=$(cn_get_all_sections | grep "cam" | cut -f2 -d' ')
    if [[ -n "${cam_sections}" ]]; then
        readarray -t name_spaces <<< "${cam_sections}"
        #shellcheck disable=SC2034
        declare -agr CN_CONFIGURED_CAMS=("${name_spaces[@]}")
    else
        cn_missing_cam_section_msg
        exit 1
    fi
}

cn_set_cam_config() {
    local cam
    for cam in "${CN_CONFIGURED_CAMS[@]}"; do
        cn_set_config "cam ${cam}" "CN_CAM_${cam^^}_"
    done
}

cn_set_no_proxy_default() {
    if [[ -z "${CN_SELF_NO_PROXY}" ]]; then
        CN_SELF_NO_PROXY=""
    fi
    declare -gr CN_SELF_NO_PROXY
}

cn_init_config_parse() {
    cn_check_config_exist

    cn_set_config "crowsnest" "CN_SELF_"

    cn_set_no_proxy_default

    cn_set_cam_sections

    cn_set_cam_config

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "config_parser:\n###########\n"
        declare -p | grep "CN_"
        printf "###########\n"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: config_parser.sh\n"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefore...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
