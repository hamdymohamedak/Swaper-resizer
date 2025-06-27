#!/bin/bash

# ============================
# Enhanced Swap Setup Script (btrfs-compatible)
# ============================

# 🛠️ تأكد من المسار اللي فيه swapon
[[ ":$PATH:" != *":/usr/sbin:"* ]] && export PATH="$PATH:/usr/sbin"

# متغيرات
SWAP_PATH="/btrfs_swap/swapfile"
FSTAB_ENTRY="$SWAP_PATH none swap sw 0 0"
SWAP_SIZE="4G"
SWAPPINESS="60"
FORCE=false

# تأكد من وجود أمر swapon
function has_swapon() {
    command -v swapon &> /dev/null
}

# تعطيل أي swap شغال حاليًا
function disable_all_swap() {
    echo -e "🔻 Disabling all active swap files..."
    grep -v Filename /proc/swaps | awk '{print $1}' | while read path; do
        echo "⛔ swapoff $path"
        sudo swapoff "$path" 2>/dev/null || echo "⚠️ Couldn't disable $path"
    done
}

# عرض الحالة الحالية
function show_status() {
    echo -e "\n📊 \e[1;34mCurrent swap status:\e[0m"
    free -h
    if has_swapon; then
        swapon --show
    else
        echo -e "\e[33m⚠️  swapon not found. Can't show active swap.\e[0m"
    fi
}

# حذف swap قديم
function remove_swap() {
    echo -e "\n📛 Disabling and removing swap..."
    disable_all_swap
    sudo rm -f "$SWAP_PATH" || {
        echo "❌ Failed to delete $SWAP_PATH. It may still be in use."; exit 1;
    }
    sudo sed -i "\|$SWAP_PATH|d" /etc/fstab
    echo -e "🧹 Swap file removed and /etc/fstab cleaned."
    show_status
    exit 0
}

# إنشاء Swap جديد
function setup_swap() {
    local SIZE_MB=$(echo "$SWAP_SIZE" | grep -o '[0-9]\+' | awk '{ print $1 * 1024 }')

    if has_swapon && grep -q "$SWAP_PATH" /proc/swaps; then
        CURRENT_SWAP=$(swapon --show=NAME,SIZE --noheadings | grep "$SWAP_PATH" | awk '{print $2}')
        CURRENT_MB=$(echo "$CURRENT_SWAP" | grep -o '[0-9]\+')
    else
        CURRENT_MB=""
    fi

    if [[ "$CURRENT_MB" == "$SIZE_MB" && "$FORCE" = false ]]; then
        echo -e "\nℹ️  Swap already exists with size \e[34m$CURRENT_SWAP\e[0m — use --force to recreate."
        return
    fi

    echo -e "\n📛 Disabling existing swap (if active)..."
    disable_all_swap

    echo -e "🗑️  Removing old swap file..."
    sudo rm -f "$SWAP_PATH" || {
        echo "❌ Failed to delete $SWAP_PATH. It may still be in use."; exit 1;
    }

    echo -e "📁 Creating directory (no COW for btrfs)..."
    sudo mkdir -p "$(dirname $SWAP_PATH)"
    sudo chattr +C "$(dirname $SWAP_PATH)" 2>/dev/null

    echo -e "📦 Allocating swap file of size \e[32m$SWAP_SIZE\e[0m..."
    sudo dd if=/dev/zero of="$SWAP_PATH" bs=1M count=$SIZE_MB status=progress

    echo -e "🔐 Setting permissions..."
    sudo chmod 600 "$SWAP_PATH"

    echo -e "💾 Formatting as swap..."
    sudo mkswap "$SWAP_PATH"

    echo -e "✅ Enabling swap..."
    if has_swapon; then
        sudo swapon "$SWAP_PATH"
    else
        echo -e "⚠️  swapon not found. Swap file created but not activated."
    fi

    if ! grep -q "$FSTAB_ENTRY" /etc/fstab; then
        echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab
        echo -e "📎 Added to /etc/fstab"
    fi
}

# تعيين swappiness
function set_swappiness() {
    echo -e "⚙️  Setting swappiness = $SWAPPINESS"
    sudo sysctl vm.swappiness=$SWAPPINESS
    echo "vm.swappiness=$SWAPPINESS" | sudo tee /etc/sysctl.d/99-swappiness.conf > /dev/null
}

# تحليل المتغيرات
for arg in "$@"; do
    case $arg in
        --status-only)
            show_status
            exit 0
            ;;
        --remove)
            remove_swap
            ;;
        --force)
            FORCE=true
            ;;
        [0-9]*[Gg])
            SWAP_SIZE="$arg"
            ;;
        [0-9][0-9])
            SWAPPINESS="$arg"
            ;;
        *)
            echo "❌ Unknown argument: $arg"
            echo "Usage: $0 [SIZE] [SWAPPINESS] [--force] [--remove] [--status-only]"
            exit 1
            ;;
    esac
done

# تنفيذ الإعداد
echo -e "\n🔧 Swap Size: \e[36m$SWAP_SIZE\e[0m"
echo -e "🔁 Swappiness: \e[36m$SWAPPINESS\e[0m"
setup_swap
set_swappiness
show_status

echo -e "\n✅ \e[1;32mSwap setup complete!\e[0m"
