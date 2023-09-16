#!/usr/bin/env bash

#### argparser.sh - Argument parser for commandline options

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

cn_init_argparse() {
    if [ "$#" -eq 0 ]; then
        cn_missing_args_msg
        exit 1
    fi

    while getopts ":vhc:d" arg; do
        case "${arg}" in
            v )
                cn_self_version_msg
                exit 0
            ;;
            h )
                cn_help_msg
                exit 0
            ;;
            c )
                CN_CONFIG_FILE="${OPTARG}"
            ;;
            d )
                set -x
            ;;
            \?)
                cn_wrong_args_msg
                exit 1
            ;;
        esac
        if [[ "${CN_DEV_MSG}" = "1" ]]; then
            printf "Args given: %s\n" "${arg}"
        fi
    done

    if [[ -z "${CN_CONFIG_FILE}" ]]; then
        cn_missing_cfg_path
        exit 1
    fi

    if [[ -n "${CN_CONFIG_FILE}" ]]; then
        declare -g -r CN_CONFIG_FILE
    fi

    if [[ "${CN_DEV_MSG}" = "1" ]]; then
        printf "Given config path: %s\n" "${CN_CONFIG_FILE}"
    fi
}

if [[ "${CN_DEV_MSG}" = "1" ]]; then
    printf "Sourced component: arg_parser.sh\n"
fi

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "This is a component of crowsnest!\n"
    printf "Components are not meant to be executed, therefore...\n"
    printf "DO NOT EXECUTE %s ON ITS OWN!\n" "$(basename "${0}")"
    exit 1
fi
