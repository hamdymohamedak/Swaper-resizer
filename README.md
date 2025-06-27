# 🧠 Advanced Swap / Page File Manager Scripts

Automate swap setup for **Linux (Btrfs compatible)** and **Windows (Page File configuration)** environments with these cross-platform scripts. Useful for performance tuning, RAM-limited systems, and virtual environments.

---

## 🐧 Linux – `setup_swap.sh`

### 🔧 Features

- ❌ Disables any existing swap.
- 📦 Creates a **Btrfs-compatible swap file** (Copy-On-Write disabled).
- 📏 Supports **custom swap sizes** (e.g., `4G`, `8G`, `16G`).
- 🎯 Sets `vm.swappiness` (how aggressively Linux uses swap).
- 🔁 Automatically adds swap to `/etc/fstab` for persistence.
- 🧹 Optional swap **removal** or **status-only check**.
- 💪 Force mode to **recreate** swap file if needed.

---

### ✅ Usage Instructions

#### 1. Make the script executable:

```bash
chmod +x setup_swap.sh

2. Run with your desired swap size and swappiness:

sudo ./setup_swap.sh 8G 60

Argument	Description
8G	Swap file size
60	Swappiness value (0–100)
🧩 Extra Options
🔍 Show current swap status only:

./setup_swap.sh --status-only

🗑️ Remove current swap file:

./setup_swap.sh --remove

💪 Force recreation (even if file exists):

sudo ./setup_swap.sh 8G 60 --force

🪟 Windows – setup_pagefile.bat
🔧 Features

    🧠 Enables or disables Windows-managed Page File.

    🔧 Sets a custom fixed size for virtual memory.

    ♻️ Removes and recreates pagefile.sys.

    📊 Shows current Page File configuration.

✅ Usage Instructions

    🛑 Must run as Administrator

1. Right-click → Run as Administrator
2. Default behavior:

    Fixed 8GB Page File on drive C:\

    Automatically reconfigures system settings.

⚙️ Customization

To modify behavior, edit the following lines inside the .bat file:

set "SIZE_MB=8192"   :: Page file size in MB
set "AUTOMATIC=0"    :: Set to 1 for Windows to auto-manage
set "DRIVE=C:"       :: Target drive

🧠 Let Windows auto-manage the Page File:

set "AUTOMATIC=1"

📎 Notes

    These scripts are best used on fresh setups or when fine-tuning performance.

    Backup important data before altering system-level memory settings.

    Btrfs users must avoid Copy-On-Write for swap — handled automatically in this script.

📄 License

MIT License
🙋‍♂️ Author

HamdyMohamedak – Passionate about performance, systems, and automation.
