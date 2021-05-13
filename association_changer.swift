#!/usr/bin/xcrun swift

import Darwin
import Foundation

func main() -> Void {
    let args = CommandLine.arguments

    if args.count != 4 {
        print("Invalid arguments.")
        exit(1)
    }

    let type = args[1]
    let ext = args[2] as CFString
    let bundleId = args[3] as CFString

    let ret: OSStatus
    if type == "pub" {
        ret = LSSetDefaultRoleHandlerForContentType(ext, LSRolesMask.all, bundleId)
    }
    else if type == "ext" {
        let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext, nil)!.takeUnretainedValue()
        ret = LSSetDefaultRoleHandlerForContentType(uti, LSRolesMask.all, bundleId)
    }
    else {
        print("Invalid UTI type.")
        exit(1)
    }
    
    if ret == kOSReturnSuccess {
        print("Succeeded.")
    }
    else {
        print("Failed to associate \(ext) with \(bundleId).")
        exit(1)
    }
}

main()
exit(0)
