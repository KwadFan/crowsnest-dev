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

cn_get_param() {
    local cfg section param
    cfg="${CROWSNEST_CFG}"
    section="${1}"
    param="${2}"
    crudini --get "${cfg}" "${section}" "${param}" 2> /dev/null | \
    sed 's/\#.*//;s/[[:space:]]*$//'
    return
}

cn_get_section() {
    local cfg section
    cfg="${CROWSNEST_CFG}"
    section="${1}"
    crudini --get "${cfg}" "${section}" 2> /dev/null
}

cn_get_self_config() {
    local var_name
    local -a variables
    variables=()
    for param in $(cn_get_section "crowsnest"); do
        var_name="CN_SELF_${param^^}"
        variables+=( "${var_name}" )
    done
    echo "${variables[@]}"
}

cn_set_self_config() {
    local var_name
    for var in $(cn_get_self_config); do
        var_name="${var}"
        echo "${var}"
        var="${var/CN_SELF_/}"
        var="${var,,}"
        cn_get_param "crowsnest" "${var}"
        echo "${var}"
        eval "${var_name}=$(cn_get_param "crowsnest" "${var}")"
        echo "${var_name}"
    done
}

init_config_parse() {
    cn_set_self_config
}


    # variables=("${variables[@]/CN_SELF_/}")
    # variables=("${variables[@],,}")
    # echo "${variables[@]}"
