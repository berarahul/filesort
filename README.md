# FileSort 📂✨

**FileSort** is a handy, easy-to-use tool for Linux that acts like a digital housekeeper for your computer. It quickly organizes your messy folders, finds duplicate files that are wasting space, and helps keep your digital life tidy. 

Best of all, it includes an "Undo" feature, so you never have to worry about making a mistake!

---

## 🌟 What Can FileSort Do?

1. **Organize the Mess:** Point FileSort at a cluttered folder (like your Downloads folder), and it will automatically group your files into neat, labeled folders either by **Extension** (like `.pdf`, `.jpg`, `.mp4`) or by **Category** (like `Documents`, `Images`, `Video`).
2. **Find Wasted Space:** It scans your folders for duplicate files—even if the duplicates have different names! It tells you exactly how much space those extra copies are taking up.
3. **Safe "Dry Run" Mode:** Want to see what FileSort will do *before* it actually moves anything? The "Dry Run" feature gives you a preview, so you are always in control.
4. **Oops? Just Undo:** Every time FileSort moves a file, it keeps a history log. If you didn't like how a folder was organized, you can easily tell it to put everything back exactly where it was.

---

## 📥 How to Install

Installing FileSort is quick and doesn't require any special administrator (root) passwords.

1. Open your Terminal.
2. Go to the folder where you downloaded FileSort.
3. Run the installation script by typing:
   ```bash
   ./install.sh
   ```
4. *That's it!* FileSort is now installed on your computer.

---

## 🚀 How to Use FileSort

There are two ways to use FileSort. You can use the **Interactive Menu** (great for beginners), or you can use **Direct Commands** if you prefer typing things out quickly.

### Method 1: The Interactive Menu (Recommended)
Simply open your terminal and type:
```bash
filesort
```
You will be greeted with a friendly menu:
```text
    ╔══════════════════════════════════════════╗
    ║              FILESORT CLI                ║
    ║       Organize. Detect. Simplify.        ║
    ╚══════════════════════════════════════════╝

    What would you like to do?

    1. Organize unstructured files
    2. Detect duplicate files
    3. Customize settings
    4. View operation history
    5. Undo a previous operation
    6. Help and documentation
    0. Exit
```
Just type the number of what you want to do and hit **Enter**. The tool will guide you through the rest step-by-step!

### Method 2: Direct Commands (For Advanced Users)
If you know exactly what you want to do, you can tell FileSort in one line.

**To organize your Downloads folder by file extension (e.g., puts all PDFs in a "pdf" folder):**
```bash
filesort organize ~/Downloads --mode extension
```

**To organize your Downloads folder by category (e.g., puts PDFs and Word docs into a "Documents" folder):**
```bash
filesort organize ~/Downloads --mode category
```

**To scan a folder for duplicate files:**
```bash
filesort duplicates ~/Documents
```

**To view your history of moved files:**
```bash
filesort history
```

**To UNDO a move (find the ID from your history first):**
```bash
filesort undo <OPERATION_ID>
```

---

## 🛡️ Is it Safe?

**Yes.** We designed FileSort with safety as the #1 priority.
- It will **never** automatically delete your files. Even when it finds duplicates, it just reports them to you; you get to decide what to do with them.
- It will **never** overwrite a file if one with the same name already exists in the destination folder.
- It keeps a persistent log of everything it does so you can always reverse a move.

---

## 🗑️ How to Uninstall
If you ever want to remove FileSort, just open your terminal in the FileSort folder and run:
```bash
./uninstall.sh
```
*(Note: Uninstalling the app will keep your configuration settings and history logs safe, just in case you ever decide to install it again later.)*

---

## 📝 License

This project is open-source and free to use under the MIT License.
