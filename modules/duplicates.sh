#!/usr/bin/env bash

# Duplicates module
duplicates_cli() {
    local src_dir=""
    local report_file=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --report)
                report_file="$2"
                shift 2
                ;;
            -*)
                log_error "Unknown option: $1"
                return 1
                ;;
            *)
                if [[ -z "$src_dir" ]]; then
                    src_dir="$1"
                else
                    log_error "Too many arguments for duplicates."
                    return 1
                fi
                shift
                ;;
        esac
    done

    if [[ -z "$src_dir" ]]; then
        log_error "Source directory not specified."
        return 1
    fi

    if ! validate_directory "$src_dir"; then
        return 1
    fi

    find_duplicates "$src_dir" "$report_file"
}

find_duplicates() {
    local dir="$1"
    local report="$2"

    log_info "Scanning for duplicates in '$dir'..."

    local tmp_sizes
    tmp_sizes=$(mktemp)

    # 1. Group by size first
    find "$dir" -type f -print0 | while IFS= read -r -d '' file; do
        local size
        size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
        if [[ -n "$size" && $size -gt 0 ]]; then
            local b64_path
            b64_path=$(echo -n "$file" | base64 -w 0)
            echo "${size} ${b64_path}" >> "$tmp_sizes"
        fi
    done || true

    local tmp_duplicates_size
    tmp_duplicates_size=$(mktemp)
    awk '{print $1}' "$tmp_sizes" | sort | uniq -d > "$tmp_duplicates_size" || true

    local tmp_hashes
    tmp_hashes=$(mktemp)

    # 2. Hash files that have matching sizes
    while read -r size; do
        while read -r b64_path; do
            local file
            file=$(echo "$b64_path" | base64 -d)
            local hash
            hash=$(sha256sum "$file" | awk '{print $1}')
            echo "${hash} ${b64_path}" >> "$tmp_hashes"
        done < <(grep "^${size} " "$tmp_sizes" | awk '{print $2}')
    done < "$tmp_duplicates_size" || true

    # 3. Find duplicates by hash
    local tmp_duplicates_hash
    tmp_duplicates_hash=$(mktemp)
    awk '{print $1}' "$tmp_hashes" | sort | uniq -d > "$tmp_duplicates_hash" || true

    local count=0
    local waste=0

    if [[ -n "$report" ]]; then
        echo "hash,file_path" > "$report"
    fi

    while read -r hash; do
        echo -e "${COLOR_YELLOW}Duplicate group (hash: ${hash:0:8}...):${COLOR_RESET}"
        local first=1
        while read -r b64_path; do
            local file
            file=$(echo "$b64_path" | base64 -d)
            echo "  $file"
            if [[ -n "$report" ]]; then
                local safe_file
                safe_file=$(echo "$file" | sed 's/"/""/g')
                echo "${hash},\"${safe_file}\"" >> "$report"
            fi

            if [[ $first -eq 1 ]]; then
                first=0
            else
                count=$((count + 1))
                local size
                size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
                waste=$((waste + size))
            fi
        done < <(grep "^${hash} " "$tmp_hashes" | awk '{print $2}')
        echo ""
    done < "$tmp_duplicates_hash" || true

    if [[ $count -eq 0 ]]; then
        log_success "No duplicates found."
    else
        log_warn "Found $count redundant files taking up $waste bytes."
    fi

    rm -f "$tmp_sizes" "$tmp_duplicates_size" "$tmp_hashes" "$tmp_duplicates_hash"
}
