#!/usr/bin/env bash

organizer_cli() {
    local src_dir=""
    local mode="extension"
    local dry_run=0

    # Parse arguments for organize
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --mode)
                mode="$2"
                shift 2
                ;;
            --dry-run)
                dry_run=1
                shift
                ;;
            -*)
                log_error "Unknown option: $1"
                return 1
                ;;
            *)
                if [[ -z "$src_dir" ]]; then
                    src_dir="$1"
                else
                    log_error "Too many arguments. Expected one source directory."
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

    organize_directory "$src_dir" "$mode" "$dry_run"
}

organize_directory() {
    local src_dir="$1"
    local mode="$2"
    local dry_run="$3"

    log_info "Organizing '$src_dir' by '$mode'"
    [[ $dry_run -eq 1 ]] && log_info "DRY RUN MODE"

    if [[ "$mode" == "category" ]]; then
        categories_init
    fi

    # Read files null-delimited to handle spaces/newlines
    # -maxdepth 1 to not recurse initially, though configurable later
    # -type f to only match files
    local op_id
    op_id=$(date +%s%N)

    while IFS= read -r -d '' file; do
        local filename
        filename=$(basename "$file")

        # skip hidden files for now
        if [[ "$filename" == .* ]]; then
            continue
        fi

        # get extension
        local ext=""
        if [[ "$filename" == *.* ]]; then
            ext="${filename##*.}"
            ext="${ext,,}" # to lowercase
        fi

        local dest_subdir=""
        if [[ "$mode" == "extension" ]]; then
            if [[ -n "$ext" ]]; then
                dest_subdir="$ext"
            else
                dest_subdir="no_extension"
            fi
        elif [[ "$mode" == "category" ]]; then
            if [[ -n "$ext" ]]; then
                dest_subdir=$(get_category_for_ext "$ext")
            else
                dest_subdir="Other"
            fi
        else
            log_error "Mode $mode not implemented fully yet."
            return 1
        fi

        local dest_dir="${src_dir}/${dest_subdir}"
        local dest_path="${dest_dir}/${filename}"

        if [[ "$file" == "$dest_path" ]]; then
            continue # already in place
        fi

        if [[ -e "$dest_path" ]]; then
            log_warn "Conflict: $dest_path already exists. Skipping $filename."
            continue
        fi

        if [[ $dry_run -eq 1 ]]; then
            echo -e "Would move: ${COLOR_CYAN}$filename${COLOR_RESET} -> ${COLOR_GREEN}${dest_subdir}/${COLOR_RESET}"
        else
            mkdir -p "$dest_dir"
            if mv "$file" "$dest_path"; then
                echo -e "Moved: ${COLOR_CYAN}$filename${COLOR_RESET} -> ${COLOR_GREEN}${dest_subdir}/${COLOR_RESET}"
                history_record "$op_id" "MOVE" "$file" "$dest_path" "SUCCESS"
            else
                log_error "Failed to move $filename"
                history_record "$op_id" "MOVE" "$file" "$dest_path" "ERROR"
            fi
        fi

    done < <(find "$src_dir" -maxdepth 1 -type f -print0)

    log_success "Organization complete."
}
