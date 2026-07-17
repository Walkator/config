#!/usr/bin/env bash
# https://privacy.sexy — v0.13.7 — Fri, 20 Dec 2024 18:48:06 GMT

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [ "${1:-}" != "--yes" ]; then
    echo 'This script permanently deletes logs, caches, backups, simulator data and trash.' >&2
    echo 'Run it again with --yes if that is intentional.' >&2
    exit 2
fi

if [ "$EUID" -ne 0 ]; then
    script_path="$SCRIPT_DIR/$(basename -- "$0")"
    sudo "$script_path" --yes || (
        echo 'Administrator privileges are required.'
        exit 1
    )
    exit 0
fi


# ----------------------------------------------------------
# ------------------Clear diagnostic logs-------------------
# ----------------------------------------------------------
echo '--- Clear diagnostic logs'
# Clear directory contents: "/private/var/db/diagnostics"
glob_pattern="/private/var/db/diagnostics/*"
sudo rm -rfv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Clear diagnostic log details---------------
# ----------------------------------------------------------
echo '--- Clear diagnostic log details'
# Clear directory contents: "/private/var/db/uuidtext"
glob_pattern="/private/var/db/uuidtext/*"
sudo rm -rfv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Clear Apple System Logs (ASL)---------------
# ----------------------------------------------------------
echo '--- Clear Apple System Logs (ASL)'
# Clear directory contents: "/private/var/log/asl"
glob_pattern="/private/var/log/asl/*"
sudo rm -rfv $glob_pattern
# Delete files matching pattern: "/private/var/log/asl.log"
glob_pattern="/private/var/log/asl.log"
sudo rm -fv $glob_pattern
# Delete files matching pattern: "/private/var/log/asl.db"
glob_pattern="/private/var/log/asl.db"
sudo rm -fv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------------Clear installation logs------------------
# ----------------------------------------------------------
echo '--- Clear installation logs'
# Delete files matching pattern: "/private/var/log/install.log"
glob_pattern="/private/var/log/install.log"
sudo rm -fv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------------Clear all system logs-------------------
# ----------------------------------------------------------
echo '--- Clear all system logs'
# Clear directory contents: "/private/var/log"
glob_pattern="/private/var/log/*"
sudo rm -rfv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Clear system application logs---------------
# ----------------------------------------------------------
echo '--- Clear system application logs'
# Clear directory contents: "/Library/Logs"
glob_pattern="/Library/Logs/*"
sudo rm -rfv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Clear user application logs----------------
# ----------------------------------------------------------
echo '--- Clear user application logs'
# Clear directory contents: "$HOME/Library/Logs"
glob_pattern="$HOME/Library/Logs/*"
 rm -rfv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------------Clear Mail app logs--------------------
# ----------------------------------------------------------
echo '--- Clear Mail app logs'
# Clear directory contents: "$HOME/Library/Containers/com.apple.mail/Data/Library/Logs/Mail"
glob_pattern="$HOME/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/*"
 rm -rfv $glob_pattern
# ----------------------------------------------------------


# Clear user activity audit logs (login, logout, authentication, etc.)
echo '--- Clear user activity audit logs (login, logout, authentication, etc.)'
# Clear directory contents: "/private/var/audit"
glob_pattern="/private/var/audit/*"
sudo rm -rfv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------Clear system maintenance logs---------------
# ----------------------------------------------------------
echo '--- Clear system maintenance logs'
# Delete files matching pattern: "/private/var/log/daily.out"
glob_pattern="/private/var/log/daily.out"
sudo rm -fv $glob_pattern
# Delete files matching pattern: "/private/var/log/weekly.out"
glob_pattern="/private/var/log/weekly.out"
sudo rm -fv $glob_pattern
# Delete files matching pattern: "/private/var/log/monthly.out"
glob_pattern="/private/var/log/monthly.out"
sudo rm -fv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Clear app installation logs----------------
# ----------------------------------------------------------
echo '--- Clear app installation logs'
# Clear directory contents: "/private/var/db/receipts"
glob_pattern="/private/var/db/receipts/*"
sudo rm -rfv $glob_pattern
# Delete files matching pattern: "/Library/Receipts/InstallHistory.plist"
glob_pattern="/Library/Receipts/InstallHistory.plist"
 rm -fv $glob_pattern
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------Clear iOS app copies from iTunes-------------
# ----------------------------------------------------------
echo '--- Clear iOS app copies from iTunes'
rm -rfv ~/Music/iTunes/iTunes\ Media/Mobile\ Applications/* &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------------Clear iOS photo cache-------------------
# ----------------------------------------------------------
echo '--- Clear iOS photo cache'
rm -rf ~/Pictures/iPhoto\ Library/iPod\ Photo\ Cache/*
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------------Clear iOS Device Backups-----------------
# ----------------------------------------------------------
echo '--- Clear iOS Device Backups'
rm -rfv ~/Library/Application\ Support/MobileSync/Backup/* &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------------Clear iOS simulators-------------------
# ----------------------------------------------------------
echo '--- Clear iOS simulators'
if type "xcrun" &>/dev/null; then
    osascript -e 'tell application "com.apple.CoreSimulator.CoreSimulatorService" to quit'
    osascript -e 'tell application "iOS Simulator" to quit'
    osascript -e 'tell application "Simulator" to quit'
    xcrun simctl shutdown all
    xcrun simctl erase all
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------Clear list of connected iOS devices------------
# ----------------------------------------------------------
echo '--- Clear list of connected iOS devices'
sudo defaults delete /Users/$USER/Library/Preferences/com.apple.iPod.plist "conn:128:Last Connect"
sudo defaults delete /Users/$USER/Library/Preferences/com.apple.iPod.plist Devices
sudo defaults delete /Library/Preferences/com.apple.iPod.plist "conn:128:Last Connect"
sudo defaults delete /Library/Preferences/com.apple.iPod.plist Devices
sudo rm -rfv /var/db/lockdown/*
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Clear CUPS printer job cache---------------
# ----------------------------------------------------------
echo '--- Clear CUPS printer job cache'
sudo rm -rfv /var/spool/cups/c0*
sudo rm -rfv /var/spool/cups/tmp/*
sudo rm -rfv /var/spool/cups/cache/job.cache*
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------------Empty trash on all volumes----------------
# ----------------------------------------------------------
echo '--- Empty trash on all volumes'
# on all mounted volumes
sudo rm -rfv /Volumes/*/.Trashes/* &>/dev/null
# on main HDD
sudo rm -rfv ~/.Trash/* &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------------------Clear system cache--------------------
# ----------------------------------------------------------
echo '--- Clear system cache'
sudo rm -rfv /Library/Caches/* &>/dev/null
sudo rm -rfv /System/Library/Caches/* &>/dev/null
sudo rm -rfv ~/Library/Caches/* &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------Clear Xcode's derived data and archives----------
# ----------------------------------------------------------
echo '--- Clear Xcode'\''s derived data and archives'
rm -rfv ~/Library/Developer/Xcode/DerivedData/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/Archives/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/iOS Device Logs/* &>/dev/null
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------------Clear DNS cache----------------------
# ----------------------------------------------------------
echo '--- Clear DNS cache'
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------------Clear inactive memory-------------------
# ----------------------------------------------------------
echo '--- Clear inactive memory'
sudo purge
# ----------------------------------------------------------


echo 'Your privacy and security is now hardened 🎉💪'
echo 'Press any key to exit.'
read -n 1 -s
