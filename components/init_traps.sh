#!/bin/bash

#### init_traps.sh - error exit handling, start/stop behaviour

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


cn_err_exit() {
    local file_trace func_trace line_trace
    read -r LINE FUNC FILE < <(caller 0)
    func_trace="${FUNC}"
    file_trace="$(basename "${FILE}")"
    line_trace="${LINE}"
    if [ "${1}" != "0" ]; then
        log_msg "ERROR: Error ${1} occured on line ${line_trace}"
        log_msg "==> Error occured in file: ${file_trace} -> ${func_trace}"
        log_msg "ERROR: Stopping $(basename "$0")."
        log_msg "Goodbye..."
    fi
    if [ -n "$(jobs -pr)" ]; then
        jobs -pr | while IFS='' read -r job_id; do
            kill "${job_id}"
        done
    fi
    exit 1
}

cn_shutdown() {
    log_msg "Shutdown or Killed by User!"
    log_msg "Please come again :)"
    if [ -n "$(jobs -pr)" ]; then
        jobs -pr | while IFS='' read -r job_id; do
            kill "${job_id}"
        done
    fi
    log_msg "Goodbye..."
    exit 0
}

cn_init_traps() {
    trap 'cn_shutdown' 1 2 3 15
    trap 'cn_err_exit $? $LINENO' ERR
}
