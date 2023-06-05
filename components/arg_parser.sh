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


cn_missing_args_msg() {
    printf "%s\n" "${CN_SELF_TITLE}"
    printf "\nERROR: Missing arguments!\n"
    printf "\n\tTry: crowsnest -h\n"
    printf "\n"
}

cn_wrong_args_msg() {
    printf "%s\n" "${CN_SELF_TITLE}"
    printf "\nERROR: Wrong Arguments!\n"
    printf "\n\tTry: crowsnest -h\n"
    printf "\n"
}

cn_help_msg() {
    printf "%s\n" "${CN_SELF_TITLE}"
    printf "\nUsage:\t crowsnest [Options]"
    printf "\n\t\t-h Prints this help."
    printf "\n\t\t-v Prints Version of crowsnest."
    printf "\n\t\t-c </path/to/configfile>\n\t\t\tPath to your webcam.conf\n"
    printf "\n"
}

cn_missing_cfg_path() {
    printf "%s\n" "${CN_SELF_TITLE}"
    printf "\nERROR: No configuration file path specified!\n"
    printf "\n\tTry: crowsnest -c /path/to/configfile\n"
    printf "\n"
}

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
            CROWSNEST_CONFIG_FILE="${OPTARG}"
        ;;
        d )
            set -x
        ;;
        \?)
            cn_wrong_args_msg
            exit 1
        ;;
    esac
done

if [[ -z "${CROWSNEST_CONFIG_FILE}" ]]; then
    cn_missing_cfg_path
    exit 1
fi

if [[ -n "${CROWSNEST_CONFIG_FILE}" ]]; then
    declare -g -r CROWSNEST_CONFIG_FILE
fi

}
