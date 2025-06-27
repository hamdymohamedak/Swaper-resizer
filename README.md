# 🐧 Linux – setup_swap.sh
## 🔧 Features:

    Automatically disables any active swap.

    Creates a Btrfs-compatible swap file (no Copy-On-Write).

    Allows custom swap size (e.g., 4G, 8G, 16G).

    Sets vm.swappiness to control how aggressively Linux uses swap.

    Adds the swap file to /etc/fstab for auto-mounting at boot.

    Option to remove or only check swap status.

## ✅ How to Use:

    Open terminal.

    Make it executable:
```bash
chmod +x setup_swap.sh
```

## Run with desired size and swappiness:
    ```bash
    sudo ./setup_swap.sh 8G 60
    ```

## Extra Options:

    Show current swap status only:
```bash
./setup_swap.sh --status-only
```

## Remove current swap file:
```bash
./setup_swap.sh --remove
```

## Force recreation even if file already exists:

  ```bash
    ./setup_swap.sh 8G 60 --force
```

# 🪟 Windows – setup_pagefile.bat
## 🔧 Features:

    Enables or disables Windows-managed Page File.

    Sets custom size for the virtual memory.

    Removes old pagefile.sys and creates a new one.

    Shows current status of Page File.

## ✅ How to Use:

    Right-click → Run as Administrator

    By default, the file will:

        Set a fixed page file of 8GB on drive C:\

        You can change values inside the script:

        set "SIZE_MB=8192"
        set "AUTOMATIC=0"
        set "DRIVE=C:"

To let Windows manage the pagefile automatically:

set "AUTOMATIC=1"
