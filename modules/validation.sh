#!/usr/bin/env bash

# Validation
validate_directory() {
    local dir="$1"
    if [[ -z "$dir" ]]; then
        log_error "Directory path is empty."
        return 1
    fi
    if [[ ! -d "$dir" ]]; then
        log_error "Directory '$dir' does not exist or is not a directory."
        return 1
    fi
    if [[ ! -r "$dir" ]]; then
        log_error "Directory '$dir' is not readable."
        return 1
    fi
    return 0
}
