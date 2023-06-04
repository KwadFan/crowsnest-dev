#!/usr/bin/env bash

#### cmdline_options.sh - Argument parser for commandline options

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
}

cn_wrong_args_msg() {
    printf "%s\n" "${CN_SELF_TITLE}"
    printf "\nERROR: Wrong Arguments!\n"
    printf "\n\tTry: crowsnest -h\n"
}

cn_help_msg() {
    echo -e "crowsnest - webcam deamon\nUsage:"
    echo -e "\t crowsnest [Options]"
    echo -e "\n\t\t-h Prints this help."
    echo -e "\n\t\t-v Prints Version of crowsnest."
    echo -e "\n\t\t-c </path/to/configfile>\n\t\t\tPath to your webcam.conf\n"
}

cn_init_argparse() {
    if [ "$#" -eq 0 ]; then
        cn_missing_args_msg
        exit 1
    fi

    while getopts ":vhc:d" arg; do
    case "${arg}" in
        v )
            echo -e "\ncrowsnest Version: $(self_version)\n"
            exit 0
        ;;
        h )
            help_msg
            exit 0
        ;;
        c )
            check_cfg "${OPTARG}"
            CROWSNEST_CFG="${OPTARG}"
            # shellcheck disable=SC2034
            declare -r CROWSNEST_CFG
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
}
