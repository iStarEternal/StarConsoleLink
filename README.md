
## Introduction
StarConsoleLink inject the link to your Xcode console, which allows you to click on the link area rapid positioning to the log line

## The New Featrue

StarConsoleLink Integrated with XcodeColors

Thank for you support @robbiehanson
https://github.com/robbiehanson/XcodeColors


![Smaller icon](https://github.com/iStarEternal/StarConsoleLink/blob/master/example_image.png "Title here")

## How to use

1.  Run StarConsoleLink in you Xcode

2.  If you are using Swift, Copy /StarConsoleLink/Plugin/Logger.swift in you project

3.  If you are using Objective-C, Copy below text in you PrefixHeader.pch

4.  If you want to custom you log, please follow the rules: [FileName.extension:LineNumber], Just like [main.swift:15]

## Example
* Objective-C
```objective-c

#if DEBUG

#define XCodeColors 1

#if XCodeColors != 0      // color begin

#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#define InfoColor @"22,22,22"          // 黑色
#define InfoTitle @"Info"

#define DebugColor @"28,0,207"         // 蓝色
#define DebugTitle @"Debug"

#define WarningColor @"218,130,53"     // 黄色
#define WarningTitle @"Warning"

#define ErrorColor @"196,26,22"        // 红色
#define ErrorTitle @"Error"

#define SuccessColor @"0,116,0"        // 绿色
#define SuccessTitle @"Success"

#define FailureColor @"196,26,22"      // 红色
#define FailureTitle @"Failure"



#define LogInfo(format, ...) \
NSLog(XCODE_COLORS_ESCAPE @"fg" InfoColor @";" @"[" InfoTitle @"][%@:%d] %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogDebug(format, ...) \
NSLog(XCODE_COLORS_ESCAPE @"fg" DebugColor @";" @"[" DebugTitle @"][%@:%d] %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogWarning(format, ...) \
NSLog(XCODE_COLORS_ESCAPE @"fg" WarningColor @";" @"[" WarningTitle @"][%@:%d] %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogError(format, ...) \
NSLog(XCODE_COLORS_ESCAPE @"fg" ErrorColor @";" @"[" ErrorTitle @"][%@:%d] %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogSuccess(format, ...) \
NSLog(XCODE_COLORS_ESCAPE @"fg" SuccessColor @";" @"[" SuccessTitle @"][%@:%d] %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogFailure(format, ...) \
NSLog(XCODE_COLORS_ESCAPE @"fg" FailureColor @";" @"[" FailureTitle @"][%@:%d] %@" XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#else

#define LogInfo(format, ...) \
NSLog(@"[Info][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogDebug(format, ...) \
NSLog(@"[Debug][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogError(format, ...) \
NSLog(@"[Error][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogWarning(format, ...) \
NSLog(@"[Warning][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogSuccess(format, ...) \
NSLog(@"[Success][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogFailure(format, ...) \
NSLog(@"[Failure][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#endif  // color end

#define NSLog(format, ...)\
NSLog(@"[Info][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])
#else

#define LogInfo(...) while(0){}
#define LogDebug(...) while(0){}
#define LogError(...) while(0){}
#define LogWarning(...) while(0){}
#define LogSuccess(...) while(0){}
#define LogFailure(...) while(0){}
#define NSLog(...) while(0){}
#endif

```
And then you can log within a Objective-C method like so:
```Objective-C
LogInfo("StarConsoleLink");
```
* Swift
```swift

struct LogColor {

static let ESCAPE = "\u{001b}["
static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
static let RESET_BG = ESCAPE + "bg;" // Clear any background color
static let RESET = ESCAPE + ";"   // Clear any foreground or background color
}

let InfoColor = "22,22,22"          // 黑色
let InfoTitle = "Info"

let DebugColor = "28,0,207"         // 蓝色
let DebugTitle = "Debug"

let WarningColor = "218,130,53"     // 黄色
let WarningTitle = "Warning"

let ErrorColor = "196,26,22"        // 红色
let ErrorTitle = "Error"

let ImportantColor = "196,26,22"    // 红色
let ImportantTitle = "Important - 如果发现该行日志，应该及时处理"


class Logger: NSObject {

// WEIGHT: 0
class func print<T>(value: T, title: String, color: String, functionName: String, fileName: String, lineNumber: Int) {
Swift.print("\(LogColor.ESCAPE)fg\(color);[\(title)][\((fileName as NSString).lastPathComponent):\(lineNumber)] \(value)\(LogColor.RESET)")
}

// WEIGHT: 0
class func info<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
print(value, title: InfoTitle, color: InfoColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

// WEIGHT: 0
class func debug<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
print(value, title: DebugTitle, color: DebugColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

// WEIGHT: 2
class func warning<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
print(value, title: WarningTitle, color: WarningColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

// WEIGHT: 4
class func error<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
print(value, title: ErrorTitle, color: ErrorColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

// WEIGHT: 5
class func important<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
print(value, title: ImportantTitle, color: ImportantColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

}


```
And then you can log within a Swift method like so:

```Swift
Logger.info("StarConsoleLink")
```
