




function print_cams {
    local total v4l
    v4l="$(find /dev/v4l/by-id/ -iname "*index0" 2> /dev/null | wc -l)"
    total="$((v4l+($(detect_libcamera))))"
    if [ "${total}" -eq 0 ]; then
        log_msg "ERROR: No usable Devices Found. Stopping $(basename "${0}")."
        exit 1
    else
        log_msg "INFO: Found ${total} total available Device(s)"
    fi
    if [[ "$(detect_libcamera)" -ne 0 ]]; then
        log_msg "Detected 'libcamera' device -> $(get_libcamera_path)"
    fi
    if [[ -d "/dev/v4l/by-id/" ]]; then
        detect_avail_cams
    fi
}
