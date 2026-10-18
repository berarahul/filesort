# Installation

You can install FileSort for your user account without requiring root privileges.

## Automated Install

Run the included install script from the repository root:

```bash
./install.sh
```

This will copy the necessary files to `~/.local/share/filesort_app` and create a symlink at `~/.local/bin/filesort`.

Make sure `~/.local/bin` is in your `$PATH`.

## Automated Uninstall

To remove the application files:

```bash
./uninstall.sh
```

Your operation history and configuration files will be preserved.
