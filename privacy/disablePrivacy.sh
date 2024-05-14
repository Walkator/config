#!/usr/bin/env bash
# https://privacy.sexy — v0.13.3 — Tue, 14 May 2024 18:40:19 GMT
if [ "$EUID" -ne 0 ]; then
    script_path=$([[ "$0" = /* ]] && echo "$0" || echo "$PWD/${0#./}")
    sudo "$script_path" || (
        echo 'Administrator privileges are required.'
        exit 1
    )
    exit 0
fi


# ----------------------------------------------------------
# -----------Remove Apple Remote Desktop Settings-----------
# ----------------------------------------------------------
echo '--- Remove Apple Remote Desktop Settings'
sudo rm -rf /var/db/RemoteManagement
sudo defaults delete /Library/Preferences/com.apple.RemoteDesktop.plist
defaults delete ~/Library/Preferences/com.apple.RemoteDesktop.plist
sudo rm -rf /Library/Application\ Support/Apple/Remote\ Desktop/
rm -r ~/Library/Application\ Support/Remote\ Desktop/
rm -r ~/Library/Containers/com.apple.RemoteDesktop
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----Disable Homebrew user behavior analytics (revert)-----
# ----------------------------------------------------------
echo '--- Disable Homebrew user behavior analytics (revert)'
command='export HOMEBREW_NO_ANALYTICS=1'
declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
for profile_file in "${profile_files[@]}"
do
    if grep -q "$command" "${profile_file}" 2>/dev/null; then
        sed -i '' "/$command/d" "$profile_file"
        echo "[$profile_file] Reverted configuration"
    else
        echo "[$profile_file] No need for any action, configuration does not exist"
    fi
done
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------Disable remote management service (revert)--------
# ----------------------------------------------------------
echo '--- Disable remote management service (revert)'
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -restart -agent -console
# ----------------------------------------------------------


# ----------------------------------------------------------
# --Disable participation in Siri data collection (revert)--
# ----------------------------------------------------------
echo '--- Disable participation in Siri data collection (revert)'
defaults delete com.apple.assistant.support 'Siri Data Sharing Opt-In Status'
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Disable "Ask Siri" (revert)----------------
# ----------------------------------------------------------
echo '--- Disable "Ask Siri" (revert)'
defaults write com.apple.assistant.support 'Assistant Enabled' -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------Disable Siri voice feedback (revert)-----------
# ----------------------------------------------------------
echo '--- Disable Siri voice feedback (revert)'
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 2
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---Disable Siri services (Siri and assistantd) (revert)---
# ----------------------------------------------------------
echo '--- Disable Siri services (Siri and assistantd) (revert)'
launchctl enable "user/$UID/com.apple.assistantd"
launchctl enable "gui/$UID/com.apple.assistantd"
sudo launchctl enable 'system/com.apple.assistantd'
launchctl enable "user/$UID/com.apple.Siri.agent"
launchctl enable "gui/$UID/com.apple.Siri.agent"
sudo launchctl enable 'system/com.apple.Siri.agent'
if [ $(/usr/bin/csrutil status | awk '/status/ {print $5}' | sed 's/\.$//') = "enabled" ]; then
    >&2 echo 'This script requires SIP to be disabled. Read more: https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection'
fi
# ----------------------------------------------------------


# ----------------------------------------------------------
# --Disable "Do you want to enable Siri?" pop-up (revert)---
# ----------------------------------------------------------
echo '--- Disable "Do you want to enable Siri?" pop-up (revert)'
defaults delete com.apple.SetupAssistant 'DidSeeSiriSetup'
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------------Remove Siri from menu bar (revert)------------
# ----------------------------------------------------------
echo '--- Remove Siri from menu bar (revert)'
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 1
# ----------------------------------------------------------


# ----------------------------------------------------------
# ----------Remove Siri from status menu (revert)-----------
# ----------------------------------------------------------
echo '--- Remove Siri from status menu (revert)'
defaults delete com.apple.Siri 'StatusMenuVisible'
defaults delete com.apple.Siri 'UserHasDeclinedEnable'
# ----------------------------------------------------------


# ----------------------------------------------------------
# -Disable display of recent applications on Dock (revert)--
# ----------------------------------------------------------
echo '--- Disable display of recent applications on Dock (revert)'
defaults delete com.apple.dock show-recents
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------Disable Spotlight indexing (revert)------------
# ----------------------------------------------------------
echo '--- Disable Spotlight indexing (revert)'
sudo mdutil -i on /
# ----------------------------------------------------------


# Disable personalized advertisements and identifier tracking (revert)
echo '--- Disable personalized advertisements and identifier tracking (revert)'
defaults write com.apple.AdLib allowIdentifierForAdvertising -bool true
defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool true
sudo defaults delete com.apple.AdLib forceLimitAdTracking
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----------Enable application firewall (revert)-----------
# ----------------------------------------------------------
echo '--- Enable application firewall (revert)'
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool false
defaults write com.apple.security.firewall EnableFirewall -bool false
# ----------------------------------------------------------


# ----------------------------------------------------------
# -------------Enable firewall logging (revert)-------------
# ----------------------------------------------------------
echo '--- Enable firewall logging (revert)'
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode off
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool false
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---------------Enable stealth mode (revert)---------------
# ----------------------------------------------------------
echo '--- Enable stealth mode (revert)'
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode off
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool false
defaults write com.apple.security.firewall EnableStealthMode -bool false
# ----------------------------------------------------------


# Disable automatic incoming connections for signed apps (revert)
echo '--- Disable automatic incoming connections for signed apps (revert)'
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool true
# ----------------------------------------------------------


# Disable automatic incoming connections for downloaded signed apps (revert)
echo '--- Disable automatic incoming connections for downloaded signed apps (revert)'
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool true
# ----------------------------------------------------------


# ----------------------------------------------------------
# -----Disable guest sign-in from login screen (revert)-----
# ----------------------------------------------------------
echo '--- Disable guest sign-in from login screen (revert)'
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool YES
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---Disable guest access to file shares over AF (revert)---
# ----------------------------------------------------------
echo '--- Disable guest access to file shares over AF (revert)'
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool YES
# ----------------------------------------------------------


# ----------------------------------------------------------
# --Disable guest access to file shares over SMB (revert)---
# ----------------------------------------------------------
echo '--- Disable guest access to file shares over SMB (revert)'
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool YES
# ----------------------------------------------------------


# ----------------------------------------------------------
# ---Disable incoming SSH and SFTP remote logins (revert)---
# ----------------------------------------------------------
echo '--- Disable incoming SSH and SFTP remote logins (revert)'
sudo systemsetup -setremotelogin on
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------Disable the insecure TFTP service (revert)--------
# ----------------------------------------------------------
echo '--- Disable the insecure TFTP service (revert)'
sudo launchctl enable 'system/com.apple.tftpd'
# ----------------------------------------------------------


# ----------------------------------------------------------
# ------Disable Bonjour multicast advertising (revert)------
# ----------------------------------------------------------
echo '--- Disable Bonjour multicast advertising (revert)'
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool false
# ----------------------------------------------------------


# ----------------------------------------------------------
# --------Disable insecure telnet protocol (revert)---------
# ----------------------------------------------------------
echo '--- Disable insecure telnet protocol (revert)'
sudo launchctl enable system/com.apple.telnetd
# ----------------------------------------------------------


echo 'Your privacy and security is now hardened 🎉💪'
echo 'Press any key to exit.'
read -n 1 -s