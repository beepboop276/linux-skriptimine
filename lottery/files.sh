#!/bin/bash
# Failide tühjendamine ja haldamine

clear_files() {
    local p_file="$1"
    local l_file="$2"

    > "$p_file" || return 1
    > "$l_file" || return 1
    return 0
}
