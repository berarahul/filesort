#!/usr/bin/env bash
# FileSort - Professional Linux CLI File Organizer

set -e
set -u
set -o pipefail

# Determine script directory to source modules correctly
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all required modules
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/modules/utils.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/modules/logger.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/modules/config.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/modules/validation.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/modules/ui.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/modules/categories.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/modules/organizer.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/modules/duplicates.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/modules/history.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/modules/undo.sh"

# Main entry point
main() {
    # Initialize configuration and history (XDG based)
    config_init
    history_init

    if [[ $# -eq 0 ]]; then
        # Interactive mode
        ui_main_menu
    else
        # CLI arguments mode
        parse_args "$@"
    fi
}

parse_args() {
    local cmd="${1:-}"
    shift || true

    case "$cmd" in
        organize)
            organizer_cli "$@"
            ;;
        duplicates)
            duplicates_cli "$@"
            ;;
        config)
            config_cli "$@"
            ;;
        history)
            history_cli "$@"
            ;;
        undo)
            undo_cli "$@"
            ;;
        help|--help|-h)
            ui_print_help
            ;;
        version|--version|-v)
            ui_print_version
            ;;
        *)
            log_error "Unknown command: $cmd"
            ui_print_help
            exit 1
            ;;
    esac
}

# Run main if this script is not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
