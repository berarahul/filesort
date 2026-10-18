# Usage Guide

## Interactive Mode

Simply run `filesort` to enter interactive mode.

```bash
filesort
```

## CLI Mode

### Organization

Organize files by extension:

```bash
filesort organize ~/Downloads --mode extension
```

Organize files by category:

```bash
filesort organize ~/Downloads --mode category
```

Dry-run to see what would happen without moving files:

```bash
filesort organize ~/Downloads --mode category --dry-run
```

### Duplicates

Find duplicate files:

```bash
filesort duplicates ~/Downloads
```

Export duplicates to a CSV report:

```bash
filesort duplicates ~/Downloads --report dups.csv
```

### History and Undo

View history of operations:

```bash
filesort history
```

Undo an operation by ID:

```bash
filesort undo <OPERATION_ID>
```
