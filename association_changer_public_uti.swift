#!/usr/bin/xcrun swift

// For public.* UTIs.

import Foundation

func main() -> Void {
    let args = CommandLine.arguments

    if args.count != 3 {
        print("Invalid arguments.")
        return
    }

    let ty = args[1]
    let handler = args[2]

    if LSSetDefaultRoleHandlerForContentType(
        ty as CFString,
        LSRolesMask.all,
        handler as CFString
    ) != 0 {
        print("Failed.")
        return
    }
    
    print("Succeeded.")
}

main()
