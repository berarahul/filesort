#!/usr/bin/env bash

# Config module
config_init() {
    # Set up XDG Base Dirs
    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

    FILESORT_CONFIG_DIR="${XDG_CONFIG_HOME}/filesort"
    FILESORT_DATA_DIR="${XDG_DATA_HOME}/filesort"
    FILESORT_CONFIG_FILE="${FILESORT_CONFIG_DIR}/config"

    if [[ ! -d "$FILESORT_CONFIG_DIR" ]]; then
        mkdir -p "$FILESORT_CONFIG_DIR"
    fi
    if [[ ! -d "$FILESORT_DATA_DIR" ]]; then
        mkdir -p "$FILESORT_DATA_DIR"
    fi

    # Create default config if it doesn't exist
    if [[ ! -f "$FILESORT_CONFIG_FILE" ]]; then
        config_reset
    fi
}

config_reset() {
    cat > "$FILESORT_CONFIG_FILE" << EOF
# FileSort Configuration

# Default organization mode (extension, category)
DEFAULT_MODE="extension"

# Ask for confirmation before moving files
CONFIRM_MOVES="true"

# Enable color output
COLOR_OUTPUT="true"
EOF
    log_success "Configuration reset to defaults."
}

config_show() {
    log_info "Current Configuration ($FILESORT_CONFIG_FILE):"
    echo "----------------------------------------"
    cat "$FILESORT_CONFIG_FILE"
    echo "----------------------------------------"
}

config_cli() {
    local cmd="${1:-}"

    # If no argument is provided, we assume we want an interactive menu for config
    if [[ -z "$cmd" ]]; then
        config_menu
        return
    fi

    case "$cmd" in
        show)
            config_show
            ;;
        reset)
            config_reset
            ;;
        *)
            log_error "Unknown config command: $cmd. Available: show, reset"
            return 1
            ;;
    esac
}

config_menu() {
    while true; do
        echo -e "\n${COLOR_CYAN}${COLOR_BOLD}--- Configuration Menu ---${COLOR_RESET}"
        echo "1. Show current configuration"
        echo "2. Reset configuration to defaults"
        echo "0. Return to main menu"
        echo ""
        read -r -p "Select an option: " choice

        case "$choice" in
            1) config_show ;;
            2)
                read -r -p "Are you sure you want to reset the configuration? (y/N): " confirm
                if [[ "${confirm,,}" == "y" ]]; then
                    config_reset
                else
                    log_info "Reset cancelled."
                fi
                ;;
            0) return ;;
            *) log_warn "Invalid selection. Please try again." ;;
        esac
    done
}
