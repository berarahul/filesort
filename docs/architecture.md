# FileSort Architecture

FileSort is a modular Bash application.

## Core Modules

- `filesort.sh`: The main entry point, routes commands to modules.
- `modules/ui.sh`: Interactive menus and CLI help.
- `modules/organizer.sh`: Core logic for organizing files by extension or category.
- `modules/duplicates.sh`: Duplicate file detection based on size and SHA-256 hash.
- `modules/history.sh`: Logs every file operation to a CSV file.
- `modules/undo.sh`: Reads the history CSV to safely restore files to their previous locations.
- `modules/categories.sh`: Defines standard mappings for file extensions to broad categories.
- `modules/config.sh`: Manages XDG-based configuration.
- `modules/validation.sh`: Reusable checks for paths and permissions.
- `modules/logger.sh`: Standardized colorful logging.

## Data Storage

Data is stored following XDG Base Directory conventions:

- `~/.config/filesort/config`: Future persistent user config.
- `~/.local/share/filesort/history.csv`: Operation history for undo functionality.
