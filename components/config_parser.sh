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
    if [[ ! -f "${CROWSNEST_CONFIG_FILE}" ]]; then
        cn_log_msg "ERROR: Given configuration file '${CROWSNEST_CONFIG_FILE}' doesn't exist!"
        exit 1
    fi
}

cn_get_all_sections() {
    local cfg
    cfg="${CROWSNEST_CONFIG_FILE}"
}

cn_get_section() {
    local cfg section
    cfg="${CROWSNEST_CONFIG_FILE}"
    section="${1}"
    crudini --get "${cfg}" "${section}" 2> /dev/null
}

cn_get_param() {
    local cfg section param
    cfg="${CROWSNEST_CONFIG_FILE}"
    section="${1}"
    param="${2}"
    crudini --get "${cfg}" "${section}" "${param}" 2> /dev/null | \
    sed 's/\#.*//;s/[[:space:]]*$//'
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
    local var_name section prefix
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
        declare -g -r "$(echo "${expose_var}" | tr -d "'")"
    done
}

init_config_parse() {
    cn_check_config_exist
    cn_set_config "crowsnest" "CN_SELF_"
}
