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
        cn_log_sect_header "Host information:"
        ## OS Infos
        ## OS Version
        if [[ -f /etc/os-release ]]; then
            cn_log_msg "Distribution: $(grep "PRETTY" /etc/os-release | \
            cut -d '=' -f2 | sed 's/^"//;s/"$//')"
        fi
        ## Release Version of MainsailOS (if file present)
        if [[ -f /etc/mainsailos-release ]]; then
            cn_log_msg "Release: $(cat /etc/mainsailos-release)"
        fi
        ## Kernel version
        cn_log_msg "Kernel: $(uname -s) $(uname -rm)"
        ## Host Machine Infos
        ## Host model
        if [[ -n "${sbc_model}" ]]; then
            cn_log_msg "Model: ${sbc_model}"
        fi
        if [[ -n "${generic_model}" ]] &&
        [[ -z "${sbc_model}" ]]; then
            cn_log_msg "Model: ${generic_model}"
        fi
        ## CPU count
        cn_log_msg "Available CPU Cores: $(nproc)"
        ## Avail mem
        cn_log_msg "Available Memory: ${memtotal}"
        ## Avail disk size
        cn_log_msg "Diskspace (avail. / total): ${disksize}"
    fi
    # put a little whitespace here
    cn_log_msg " "
}

cn_print_host_cfg() {
    local host_config
    host_config="/boot/config.txt"
    if [[ -f "${host_config}" ]]; then
        if [[ "${CN_SELF_LOG_LEVEL}" = "debug" ]]; then
            mapfile -t cfg < <(cat "${host_config}")
            cn_log_sect_header "Host configuration: '${host_config}'"
            # put a little whitespace here
            cn_log_msg " "
            for i in "${cfg[@]}"; do
                if [[ -n "${CN_SELF_LOG_PATH}" ]]; then
                    printf "%s\t\t%s\n" "$(cn_log_prefix)" "${i}" >> "${CN_SELF_LOG_PATH}"
                fi
                printf "\t%s\n" "${i}"
            done
            # put a little whitespace here
            cn_log_msg " "
        fi
    fi
}

cn_init_print_host() {
    cn_print_host

    cn_print_host_cfg
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: host_info.sh\n"
fi
