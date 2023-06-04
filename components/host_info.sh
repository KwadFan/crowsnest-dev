#!/usr/bin/env bash

#### host_info.sh - determine and print host information

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

cn_print_host() {
    local disksize generic_model memtotal sbc_model
    generic_model="$(grep "model name" /proc/cpuinfo | cut -d':' -f2 | awk NR==1)"
    sbc_model="$(grep "Model" /proc/cpuinfo | cut -d':' -f2)"
    memtotal="$(grep "MemTotal:" /proc/meminfo | awk '{print $2" "$3}')"
    disksize="$(LC_ALL=C df -h / | awk 'NR==2 {print $4" / "$2}')"
    ## print only if not "${CROWSNEST_LOG_LEVEL}": quiet
    if [[ "${CROWSNEST_LOG_LEVEL}" != "quiet" ]]; then
        log_msg "INFO: Host information:"
        ## OS Infos
        ## OS Version
        if [[ -f /etc/os-release ]]; then
            log_msg "Host Info: Distribution: $(grep "PRETTY" /etc/os-release | \
            cut -d '=' -f2 | sed 's/^"//;s/"$//')"
        fi
        ## Release Version of MainsailOS (if file present)
        if [[ -f /etc/mainsailos-release ]]; then
            log_msg "Host Info: Release: $(cat /etc/mainsailos-release)"
        fi
        ## Kernel version
        log_msg "Host Info: Kernel: $(uname -s) $(uname -rm)"
        ## Host Machine Infos
        ## Host model
        if [[ -n "${sbc_model}" ]]; then
            log_msg "Host Info: Model: ${sbc_model}"
        fi
        if [[ -n "${generic_model}" ]] &&
        [[ -z "${sbc_model}" ]]; then
            log_msg "Host Info: Model: ${generic_model}"
        fi
        ## CPU count
        log_msg "Host Info: Available CPU Cores: $(nproc)"
        ## Avail mem
        log_msg "Host Info: Available Memory: ${memtotal}"
        ## Avail disk size
        log_msg "Host Info: Diskspace (avail. / total): ${disksize}"
    fi
}
