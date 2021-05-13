#!/bin/zsh

source $PWD/associate_changer_file_extensions.zsh

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
$PWD/association_changer_public_uti.swift com.adobe.pdf com.readdle.pdfexpert-mac

# Open with VSCode
for ty in $OPEN_WITH_VSCODE do
  $PWD/association_changer_public_uti.swift $ty $VSCODE
done

# For some custom exension names
associate_extension "gn" $VSCODE
associate_extension "gni" $VSCODE
associate_extension "meta" $VSCODE
associate_extension "toml" $VSCODE
associate_extension "props" $VSCODE

# Restart LaunchServices
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user
