#!/usr/bin/env bash

# UI
ui_main_menu() {
    while true; do
        echo -e "\n${COLOR_CYAN}${COLOR_BOLD}╔══════════════════════════════════════════╗${COLOR_RESET}"
        echo -e "${COLOR_CYAN}${COLOR_BOLD}║              FILESORT CLI                ║${COLOR_RESET}"
        echo -e "${COLOR_CYAN}${COLOR_BOLD}║       Organize. Detect. Simplify.        ║${COLOR_RESET}"
        echo -e "${COLOR_CYAN}${COLOR_BOLD}╚══════════════════════════════════════════╝${COLOR_RESET}\n"

        echo "What would you like to do?"
        echo ""
        echo "1. Organize unstructured files"
        echo "2. Detect duplicate files"
        echo "3. Customize settings"
        echo "4. View operation history"
        echo "5. Undo a previous operation"
        echo "6. Help and documentation"
        echo "0. Exit"
        echo ""
        read -r -p "Select an option: " choice

        case "$choice" in
            1) ui_prompt_organize ;;
            2) ui_prompt_duplicates ;;
            3) config_cli ;;
            4) history_cli ;;
            5) undo_cli ;;
            6) ui_print_help ;;
            0) exit 0 ;;
            *) log_warn "Invalid selection. Please try again." ;;
        esac
    done
}

ui_prompt_organize() {
    read -r -p "Enter source directory to organize: " src_dir
    # Basic expand tilde
    src_dir="${src_dir/#\~/$HOME}"
    if validate_directory "$src_dir"; then
        echo "Choose organization mode:"
        echo "1. By extension"
        echo "2. By category"
        echo "3. Custom organization"
        read -r -p "Mode: " mode_choice

        local mode_str="extension"
        case "$mode_choice" in
            1) mode_str="extension" ;;
            2) mode_str="category" ;;
            3) mode_str="custom" ;;
            *) log_error "Invalid mode"; return ;;
        esac

        organizer_cli "$src_dir" "--mode" "$mode_str"
    fi
}

ui_prompt_duplicates() {
    read -r -p "Enter directory to scan for duplicates: " src_dir
    src_dir="${src_dir/#\~/$HOME}"
    if validate_directory "$src_dir"; then
        duplicates_cli "$src_dir"
    fi
}

ui_print_help() {
    echo "FileSort CLI"
    echo "Usage: filesort [command] [options]"
    echo ""
    echo "Commands:"
    echo "  organize [dir]    Organize files in directory"
    echo "  duplicates [dir]  Find duplicate files in directory"
    echo "  config            Manage configuration"
    echo "  history           View operation history"
    echo "  undo [id]         Undo operation by ID"
    echo "  help              Show this help message"
    echo "  version           Show version"
}

ui_print_version() {
    echo "FileSort version 1.0.0"
}
