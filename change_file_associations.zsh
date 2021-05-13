#!/bin/zsh

set -xe

VSCODE='com.microsoft.vscode'

OPEN_UTI_WITH_VSCODE=(
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

OPEN_EXT_WITH_VSCODE=(
  'gn'
  'gni'
  'meta'
  'toml'
  'props'
)

# PDF
$PWD/association_changer.swift pub com.adobe.pdf com.readdle.pdfexpert-mac

# Open with VSCode
for ty in $OPEN_UTI_WITH_VSCODE do
  $PWD/association_changer_public_uti.swift pub $ty $VSCODE
done

for ty in $OPEN_EXT_WITH_VSCODE do
  $PWD/association_changer_public_uti.swift ext $ty $VSCODE
done

# Restart LaunchServices
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user
