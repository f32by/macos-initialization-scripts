#!/usr/bin/zsh

set -xe

VSCODE='com.microsoft.vscode'

OPEN_WITH_VSCODE=(
  'net.daringfireball.markdown'
  'public.c-header'
  'public.objective-c-source'
  'public.plain-text'
  'public.patch-file'
  'public.python-script'
  'public.c-plus-plus-source'
  'com.netscape.javascript-source'
  'public.xml'
  'public.yaml'
  'public.protobuf-source'
  'public.html'
)

OPEN_WITH_DUMB_BROWSER=(
  'public.url'
)

# PDF
./change_file_association.swift com.adobe.pdf com.readdle.pdfexpert-mac

# Open with VSCode
for ty in $OPEN_WITH_VSCODE do
  ./change_file_association.swift $ty $VSCODE
done

# TODO: prevent duplications
function register_extension {
  CONTENT="<dict>
             <key>LSHandlerContentTag</key>
             <string>$1</string>
             <key>LSHandlerContentTagClass</key>
             <string>public.filename-extension</string>
             <key>LSHandlerRoleAll</key>
             <string>$2</string>
            </dict>"
  # echo $CONTENT
  defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add $CONTENT
}

# For some custom exension names
register_extension "gn" $VSCODE
register_extension "gni" $VSCODE
register_extension "meta" $VSCODE
register_extension "toml" $VSCODE
register_extension "props" $VSCODE

# Restart LaunchServices
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user
