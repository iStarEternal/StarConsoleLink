
## Introduction

StarConsoleLink inject the link to your Xcode console, which allows you to click on the link area rapid positioning to the log line.

StarConsoleLink给你的Xcode控制台注入了超链接，它能让你点击链接区域快速定位到代码位置。

![Smaller icon](https://github.com/iStarEternal/StarConsoleLink/blob/master/example_image.png "Title here")


## The New Featrue

StarConsoleLink Integrated with XcodeColors, which allows you to custom you logs color.

Thank for you support @robbiehanson.  https://github.com/robbiehanson/XcodeColors


StarConsoleLink集成了XcodeColors，他可以让你自定义你Log的颜色。

谢谢@robbiehanson提供的支持。


## How to use

First.  Run StarConsoleLink in you Xcode.

Second.  If you are using Swift, Copy Logger.swift to you project.

Third.  If you are using Objective-C, Copy OCLogger.h define to you PrefixHeader.pch.

Fourth.  If you want to custom you logs, please follow the rules: [FileName.extension:LineNumber], Just like [main.swift:15].


第一步：用Xcode打开并运行StarConsoleLink。

第二步：如果你使用的是Swift，请拷贝Logger.swift到你的项目中去。

第三步：如果你使用的是Objective-C，请拷贝OCLogger.h中的宏定义到你的PCH文件中去。

第四步：如果你想要自定义你的日志，请遵照[FileName.extension:LineNumber]的书写规范，例：[main.swift:15]。


## Example
* Objective-C
```objective-c


#define XCodeColors 1

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


#if DEBUG

#if XCodeColors != 0      // color begin

#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color




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
NSLog(@"[" InfoTitle @"][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogDebug(format, ...) \
NSLog(@"[" DebugTitle @"][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogWarning(format, ...) \
NSLog(@"[" WarningTitle @"][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogError(format, ...) \
NSLog(@"[" ErrorTitle @"][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogSuccess(format, ...) \
NSLog(@"[" SuccessTitle @"][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogFailure(format, ...) \
NSLog(@"[" FailureTitle @"][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#endif  // color end

#else

#define LogInfo(...) while(0){}
#define LogDebug(...) while(0){}
#define LogError(...) while(0){}
#define LogWarning(...) while(0){}
#define LogSuccess(...) while(0){}
#define LogFailure(...) while(0){}
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
