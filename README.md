
## Introduction
  StarConsoleLink add the link to your console, which allows you to click on the link area rapid positioning to the log line

![Smaller icon](https://github.com/iStarEternal/StarConsoleLink/blob/master/example_image.jpg "Title here")

## How to use

1.  Run StarConsoleLink in you Xcode

2.  If you are using Swift, Copy /StarConsoleLink/Plugin/Logger.swift in you project

3.  If you are using Objective-C, Copy below text in you PrefixHeader.pch

4.  If you want to custom you log, please follow the rules: [FileName.extension:LineNumber], Just like [main.swift:15]

## Example
* Objective-C
```objective-c
#if DEBUG
#define NSLog(format, ...) NSLog(@"[Info][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define XCodeColors 1

#if XCodeColors != 0
#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#define LogInfo(format, ...) \
NSLog(XCODE_COLORS_ESCAPE @"fg11,11,11;" @"[Info][%@:%d] %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogError(format, ...) \
NSLog(XCODE_COLORS_ESCAPE @"fg255,0,0;" @"[Error][%@:%d] %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogWarning(format, ...) \
NSLog(XCODE_COLORS_ESCAPE @"fg244,189,10;" @"[Warning][%@:%d] %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogSuccess(format, ...) \
NSLog(XCODE_COLORS_ESCAPE @"fg0,153,0;" @"[Success][%@:%d] %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogFailure(format, ...) \
NSLog(XCODE_COLORS_ESCAPE @"fg255,0,0;" @"[Failure][%@:%d] %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#else

#define LogInfo(format, ...) \
NSLog(@"[Info][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogError(format, ...) \
NSLog(@"[Error][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogWarning(format, ...) \
NSLog(@"[Warning][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogSuccess(format, ...) \
NSLog(@"[Success][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogFailure(format, ...) \
NSLog(@"[Failure][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#endif

#else

#define NSLog(...) while(0){}
#define LogInfo(...) while(0){}
#define LogError(...) while(0){}
#define LogWarning(...) while(0){}
#define LogSuccess(...) while(0){}
#define LogFailure(...) while(0){}
#endif

```
And then you can log within a Objective-C method like so:
```Objective-C
NSLog("StarLinkConsole")
```
* Swift
```swift

import Foundation

struct LogColor {
    
    static let ESCAPE = "\u{001b}["
    static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    static let RESET_BG = ESCAPE + "bg;" // Clear any background color
    static let RESET = ESCAPE + ";"   // Clear any foreground or background color
}

class Logger: NSObject {
    
    class func print<T>(value: T, title: String, color: String, functionName: String, fileName: String, lineNumber: Int) {
        
        Swift.print("\(LogColor.ESCAPE)fg\(color);[\(title)][\((fileName as NSString).lastPathComponent):\(lineNumber)] \(value)\(LogColor.RESET)")
    }
    
    // WEIGHT: 0
    class func debug<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        //        guard DEBUG != 0 else {
        //            return
        //        }
        print(value, title: "Debug", color: "0,0,255", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 0
    class func info<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: "Info", color: "11,11,11", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 2
    class func warning<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: "Warning", color: "244,189,10", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 4
    class func error<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: "Error", color: "255,0,0", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    // WEIGHT: 5
    class func important<T>(value: T, functionName: String = __FUNCTION__, fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        print(value, title: "Important][如果发现该行日志，应该及时处理", color: "255,0,0", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
}


```
And then you can log within a Swift method like so:

```Swift
Logger.info("StarLinkConsole")
```
