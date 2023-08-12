#!/usr/bin/env bash

#### logging.sh - logging related stuff

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

cn_log_prefix() {
    printf "%s" "$(date +'[%D %T]')"
}

cn_check_log_level() {
    if [ -z "${CN_SELF_LOG_LEVEL}" ] ||
    [[ "${CN_SELF_LOG_LEVEL}" != @(quiet|verbose|debug) ]]; then
        cn_log_level_invalid_msg "${CN_SELF_LOG_LEVEL}"
        exit 1
    fi
}

cn_delete_log() {
    if [[ "${CN_SELF_DELETE_LOG}" = "true" ]] &&
    [[ -f "${CN_SELF_LOG_PATH}" ]]; then
        rm -rf "${CN_SELF_LOG_PATH}"
    fi
}

cn_log_header() {
    cn_log_msg "${CN_SELF_TITLE}"
    cn_version_log_msg
    cn_log_msg "Prepare Startup ..."
}

cn_log_msg() {
    # log to stdout only if log_path is missing
    if [[ -n "${CN_SELF_LOG_PATH}" ]]; then
        printf "%s %s\n" "$(cn_log_prefix)" "${1}" >> "${CN_SELF_LOG_PATH}"
    fi
    # print to stdout/journald
    printf "%s\n" "${1}"
}

cn_log_info_msg() {
    prefix="INFO:"
    cn_log_msg "${prefix} ${1}"
}

cn_log_warn_msg() {
    prefix="WARN:"
    cn_log_msg "${prefix} ${1}"
}

cn_log_err_msg() {
    prefix="ERROR:"
    cn_log_msg "${prefix} ${1}"
}

cn_log_sect_header() {
    cn_log_msg "-------- ${1} --------"
}

#call '| log_output "<prefix>"'
cn_log_output() {
    local prefix
    prefix="DEBUG: ${1}"
    while read -r line; do
        if [[ "${CN_SELF_LOG_LEVEL}" = "debug" ]]; then
            ## Ustreamer workaround
            cn_log_msg "${prefix}: ${line/=/}"
        fi
    done
}

cn_log_v4l2ctl_output() {
    while read -r line; do
        if [[ "${CN_SELF_LOG_LEVEL}" != "quiet" ]]; then
            cn_log_msg "$(echo -e "\t\t")${line}"
        fi
    done
}

cn_log_err_dump() {
    local line msg prefix
    prefix="DUMP -> Line#"

    while read -r line; do
        line="$(sed '0,/-/ {s/[-|:]/\t/}' <<< "${line}")"
        msg="${prefix} ${line}"
        if [[ "${CN_SELF_LOG_LEVEL}" = "debug" ]]; then
            if [[ "${msg}" =~ ^${prefix}[[:space:]][0-9].* ]]; then
                cn_log_msg "${msg}"
            else
                cn_log_msg "..."
            fi
        fi
    done
}

cn_init_logging() {
    cn_check_log_level

    cn_delete_log

    cn_log_header
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: logging.sh\n"
fi
