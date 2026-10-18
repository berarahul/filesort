#!/usr/bin/env bash

# Undo module
undo_cli() {
    local op_id="${1:-}"

    if [[ -z "$op_id" ]]; then
        log_error "Must provide an operation ID to undo."
        return 1
    fi

    log_info "Undoing operation $op_id..."

    local tmp_undo
    tmp_undo=$(mktemp)

    awk -F',' -v id="$op_id" '
    BEGIN { OFS="," }
    NR>1 && $1 == id && $6 == "SUCCESS" {
        print $0
    }' "$FILESORT_HISTORY_FILE" > "$tmp_undo"

    if [[ ! -s "$tmp_undo" ]]; then
        log_warn "No successful actions found for operation ID: $op_id"
        rm -f "$tmp_undo"
        return 1
    fi

    while read -r line; do
        if [[ $line =~ ^([^,]+),([^,]+),([^,]+),\"(.*)\",\"(.*)\",([^,]+)$ ]]; then
            local current_dest="${BASH_REMATCH[5]}"
            local original_src="${BASH_REMATCH[4]}"

            # Undo is dest -> src
            current_dest=$(echo "$current_dest" | sed 's/""/"/g')
            original_src=$(echo "$original_src" | sed 's/""/"/g')

            if [[ -e "$current_dest" ]]; then
                if [[ -e "$original_src" ]]; then
                    log_warn "Cannot undo. Original location already exists: $original_src"
                else
                    mkdir -p "$(dirname "$original_src")"
                    if mv "$current_dest" "$original_src"; then
                        echo "Restored: $original_src"
                        # Try to remove empty dir
                        rmdir "$(dirname "$current_dest")" 2>/dev/null || true
                    else
                        log_error "Failed to restore: $original_src"
                    fi
                fi
            else
                log_warn "File not found at destination: $current_dest"
            fi
        fi
    done < "$tmp_undo"

    rm -f "$tmp_undo"
    log_success "Undo completed."
}
