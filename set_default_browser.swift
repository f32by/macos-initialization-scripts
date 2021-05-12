#!/usr/bin/xcrun swift

import Cocoa

struct ProgramOption {
    var list : Bool = false
    var set : String? = nil
    var help : Bool = false
}

public func checkError(_ error: OSStatus) -> Void
{
    if (error == noErr) { return }
    
    let count = 5
    let stride = MemoryLayout<OSStatus>.stride
    let byteCount = stride * count
    
    var error_ =  CFSwapInt32HostToBig(UInt32(error))
    var charArray: [CChar] = [CChar](repeating: 0, count: byteCount )
    withUnsafeBytes(of: &error_) { (buffer: UnsafeRawBufferPointer) in
        for (index, byte) in buffer.enumerated() {
            charArray[index + 1] = CChar(byte)
        }
    }
    
    let v1 = charArray[1], v2 = charArray[2], v3 = charArray[3], v4 = charArray[4]
    
    if (isprint(Int32(v1)) > 0 && isprint(Int32(v2)) > 0 && isprint(Int32(v3)) > 0 && isprint(Int32(v4)) > 0) {
        charArray[0] = "\'".utf8CString[0]
        charArray[5] = "\'".utf8CString[0]
        let errStr = NSString(bytes: &charArray, length: charArray.count, encoding: String.Encoding.ascii.rawValue)
        print("Error: (\(errStr!))")
    }
    else {
        print("Error: \(error)")
    }

}

func showInstalledBrowsers() {
    if let array = LSCopyApplicationURLsForURL(URL(string: "https:")! as CFURL, .all)?.takeRetainedValue() as? [URL] {
        for i in 0..<array.count {
            let bundleId = array[i]

            if let bundle = Bundle(url: bundleId) {
                print(bundle.bundleIdentifier!, bundle.bundlePath)
            }
        }
    }
}

func setDefaultBrowser(bundleId: String) -> Bool {
    let httpResult = LSSetDefaultHandlerForURLScheme("http" as CFString, bundleId as CFString)
//    let httpsResult = LSSetDefaultHandlerForURLScheme("https" as CFString, bundleId as CFString)

    if httpResult == noErr /*&& httpsResult == noErr*/ {
        return true
    } else {
        checkError(httpResult)
//        checkError(httpsResult)
        return false
    }
}

var option = ProgramOption()

for var i in 0..<CommandLine.arguments.count {
    let arg = CommandLine.arguments[i]
    switch arg {
    case "-h", "--help":
        option.help = true
    case "-l", "--list":
        option.list = true
    case "-s", "--set":
        i += 1
        option.set = CommandLine.arguments[i]
    default:
        break
    }
}

if option.help {
  print("-h, --help: Show help (this)")
  print("-l, --list: Show installed browser list")
  print("-s [bundleId], --set [bundleId]: Set default browser to specified browser")
  exit(0)
}

if option.list {
  showInstalledBrowsers()
}

if let bundleId = option.set {
    if setDefaultBrowser(bundleId: bundleId) {
        print("Default browser was set to", bundleId)
        exit(0)
    } else {
        print("Error occured when setting default browser.")
        exit(1)
    }
}

exit(0)
