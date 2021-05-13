#!/bin/zsh

export LS_PLIST="$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"

function associate_extension {
  EXT=$1
  APP=$2

  i=0
  while true; do
    # Check if we reach the end of LSHandlers array.
    CHECK_EXIST_CMD='Print :LSHandlers:'$i
    EXIST=$(/usr/libexec/PlistBuddy -c "$CHECK_EXIST_CMD" $LS_PLIST 2>/dev/null)
    if [ $? -ne 0 ]; then
      break
    fi

    CHECK_TAG_CMD='Print :LSHandlers:'$i':LSHandlerContentTag'
    # Check if there is a LSHandlerContentTag and it is the one we need to modify.
    PREVIOUS=$(/usr/libexec/PlistBuddy -c "$CHECK_TAG_CMD" $LS_PLIST 2>/dev/null)
    if [[ "$PREVIOUS" = "$EXT" ]]; then
      # Found. Modify it!
      echo "Modified existing association: *.$EXT -> $APP"
      MODIFY_CMD='Set :LSHandlers:'$i':LSHandlerRoleAll $APP'
      /usr/libexec/PlistBuddy -c "$MODIFY_CMD" $LS_PLIST
      return
    fi

    i=$((i+1))
  done

  # Exist entry not found. Just create a new one.
  CONTENT="<dict>
             <key>LSHandlerContentTag</key>
             <string>$EXT</string>
             <key>LSHandlerContentTagClass</key>
             <string>public.filename-extension</string>
             <key>LSHandlerPreferredVersions</key>
             <dict>
				       <key>LSHandlerRoleAll</key>
				         <string>-</string>
			       </dict>
             <key>LSHandlerRoleAll</key>
             <string>$APP</string>
           </dict>"
  defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add $CONTENT

  echo "Created new association: *.$EXT -> $APP"
}
