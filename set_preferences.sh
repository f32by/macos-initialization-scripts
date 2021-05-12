#!/usr/bin/zsh

OS_USER=`whoami`

# default input methods
read -r -d '' DEFAULT_INPUT_METHODS << EOF
[{
    "InputSourceKind": "Keyboard Layout",
    "KeyboardLayout ID": "252",
    "KeyboardLayout Name": "ABC"
},
{
    "Bundle ID": "com.apple.inputmethod.SCIM",
    "Input Mode": "com.apple.inputmethod.SCIM.ITABC",
    "InputSourceKind": "Input Mode"
},
{
    "Bundle ID": "com.apple.CharacterPaletteIM",
    "InputSourceKind": "Non Keyboard Input Method"
},
{
    "Bundle ID": "com.apple.inputmethod.EmojiFunctionRowItem",
    "InputSourceKind": "Non Keyboard Input Method"
},
{
    "Bundle ID": "im.rime.inputmethod.Squirrel",
    "Input Mode": "im.rime.inputmethod.Squirrel",
    "InputSourceKind": "Input Mode"
},
{
    "Bundle ID": "im.rime.inputmethod.Squirrel",
    "InputSourceKind": "Keyboard Input Method"
}]
EOF

set -xe

# disable Gatekeeper
sudo spctl --master-disable

# set display sleep timer
sudo pmset -a displaysleep 60
sudo pmset -b displaysleep 15

# automatically hide menu bar
defaults write NSGlobalDomain _HIHideMenuBar -bool YES

# fastest key repeat & shortest delay until repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 35
defaults write NSGlobalDomain KeyRepeat -int 12

# Dock magnification
# defaults write com.apple.dock magnification -bool YES
# Dock tile size
# defaults write com.apple.dock tilesize -int 16

# Prevent Time Machine from Prompting to Use New Hard Drives as Backup Volume
sudo defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES

# Add a spcace to Dock
# defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'

# Lock Dock size
defaults write com.apple.Dock size-immutable -bool YES

# Disable Dock bouncing to get attention
# defaults write com.apple.Dock no-bouncing -bool YES

# disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool YES
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool YES
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool YES

# Expand Save Panel by Default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool YES
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool YES

# Save to Disk by Default
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool NO

# Finder prefereneces
defaults write com.apple.finder ShowPathbar -bool YES
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool NO
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool YES
defaults write com.apple.finder NewWindowTarget PfHm
defaults write com.apple.finder NewWindowTargetPath "file:///Users/$OS_USER/"
defaults write com.apple.finder PreferencesWindow.LastSelection "ADVD"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool NO
defaults write com.apple.finder ShowRecentTags -bool NO
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool NO
defaults write com.apple.finder _FXSortFoldersFirst -bool YES
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool YES

# Disable Creation of Metadata Files on Network Volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool YES

# Disable Creation of Metadata Files on USB Volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool YES

# hide icons in menu bar
defaults write com.apple.Spotlight 'NSStatusItem Visible Item-0' -bool NO
defaults write com.apple.airplay 'NSStatusItem Visible Item-0' -bool NO
defaults write com.apple.controlcenter 'NSStatusItem Visible Battery' -bool NO
defaults write com.apple.Siri "StatusMenuVisible" -bool NO

# block ocsp.apple.com
# sudo echo "0.0.0.0 ocsp.apple.com" >> /etc/hosts

# set default input methods
sudo plutil -replace AppleEnabledInputSources -json $DEFAULT_INPUT_METHODS /Library/Preferences/com.apple.HIToolbox.plist
