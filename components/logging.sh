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
    printf "%s crowsnest:" "$(date +'[%D %T]')"
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
    local msg
    msg="${1}"
    # print to log file
    printf "%s %s\n" "$(cn_log_prefix)" "${msg}" >> "${CN_SELF_LOG_PATH}"
    # print to stdout/journald
    printf "%s\n" "${msg}"
}

#call '| log_output "<prefix>"'
cn_log_output() {
    local prefix
    prefix="DEBUG: ${1}"
    while read -r line; do
        if [[ "${CN_SELF_LOG_LEVEL}" = "debug" ]]; then
            cn_log_msg "${prefix}: ${line}"
        fi
    done
}

cn_init_logging() {
    cn_delete_log
    cn_log_header
}
