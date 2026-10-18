#!/usr/bin/env bash

# History module
history_init() {
    FILESORT_HISTORY_FILE="${FILESORT_DATA_DIR}/history.csv"
    if [[ ! -f "$FILESORT_HISTORY_FILE" ]]; then
        echo "id,timestamp,operation,source,destination,status" > "$FILESORT_HISTORY_FILE"
    fi
}

history_record() {
    local op_id="$1"
    local operation="$2"
    local source_path="$3"
    local dest_path="$4"
    local status="$5"

    local timestamp
    timestamp=$(date -Iseconds)

    # basic CSV escaping for paths that might contain commas or quotes
    # replace " with "" and wrap in "
    local safe_source
    safe_source=$(echo "$source_path" | sed 's/"/""/g')
    safe_source="\"$safe_source\""

    local safe_dest
    safe_dest=$(echo "$dest_path" | sed 's/"/""/g')
    safe_dest="\"$safe_dest\""

    echo "${op_id},${timestamp},${operation},${safe_source},${safe_dest},${status}" >> "$FILESORT_HISTORY_FILE"
}

history_cli() {
    log_info "Operation History"
    if [[ -f "$FILESORT_HISTORY_FILE" ]]; then
        column -s, -t < "$FILESORT_HISTORY_FILE" | head -n 20
        echo "..."
    else
        echo "No history found."
    fi
}
