
## Introduction

StarConsoleLink inject the link to your Xcode console, which allows you to click on the link area rapid positioning to the log line.

StarConsoleLink给你的Xcode控制台注入了超链接，它能让你点击链接区域快速定位到代码位置。

* This is Case Diagram for Objective-C
![Smaller icon](https://github.com/iStarEternal/StarConsoleLink/blob/master/ExampleImage/example_image_objc.png "Title here")

* This is Case Diagram for Swift
![Smaller icon](https://github.com/iStarEternal/StarConsoleLink/blob/master/ExampleImage/example_image_swift.png "Title here")


## The New Feature

StarConsoleLink Integrated with XcodeColors, which allows you to custom you logs color.

Thank for you support @robbiehanson.  https://github.com/robbiehanson/XcodeColors

StarConsoleLink集成了XcodeColors，他可以让你自定义你Log的颜色。

谢谢@robbiehanson提供的支持。


## Install

```install
curl -fsSL https://raw.githubusercontent.com/iStarEternal/StarConsoleLink/master/Scripts/install.sh | sh
```


## Uninstall

```uninstall
curl -fsSL https://raw.githubusercontent.com/iStarEternal/StarConsoleLink/master/Scripts/uninstall.sh | sh
```


## How to use ?

1.  If you are using Swift, Copy Logger.swift to you project.

2.  If you are using Objective-C, Copy Logger.h to you project and import to you PrefixHeader.pch.

3.  If you want to custom you logs, please follow the rules: [FileName.extension:LineNumber], Just like [main.swift:15].

一、如果你使用的是Swift，请拷贝Logger.swift到你的项目中去。

二、如果你使用的是Objective-C，请拷贝Logger.h到你的项目中去，并在你的.pch文件中#import它。

三、如果你想要自定义你的日志，请遵照[FileName.extension:LineNumber]的书写规范，例：[main.swift:15]。


## Example

* Objective-C
```objective-c

#define StarDebug DEBUG
#define StarXCodeColors 1

#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_ESCAPE_FG XCODE_COLORS_ESCAPE @"fg"
#define XCODE_COLORS_ESCAPE_BG XCODE_COLORS_ESCAPE @"bg"

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color



#define NSLogColor @"22,22,22"          // 黑色
#define NSLogTitle @"Info"

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


#if StarDebug /* Debug Begin */

#if StarXCodeColors != 0 /* Color Begin */

// NSLog
#define NSLog(format, ...) \
printf("%s%s;[%s][%s:%d] %s %s \n",\
[XCODE_COLORS_ESCAPE_FG UTF8String],\
[NSLogColor UTF8String],\
[NSLogTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String],\
[XCODE_COLORS_RESET_FG UTF8String]\
);\

// Information
#define LogInfo(format, ...) \
printf("%s%s;[%s][%s:%d] %s %s \n",\
[XCODE_COLORS_ESCAPE_FG UTF8String],\
[InfoColor UTF8String],\
[InfoTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String],\
[XCODE_COLORS_RESET_FG UTF8String]\
);\

// Debug
#define LogDebug(format, ...) \
printf("%s%s;[%s][%s:%d] %s %s \n",\
[XCODE_COLORS_ESCAPE_FG UTF8String],\
[DebugColor UTF8String],\
[DebugTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String],\
[XCODE_COLORS_RESET_FG UTF8String]\
);\

// Warning
#define LogWarning(format, ...) \
printf("%s%s;[%s][%s:%d] %s %s \n",\
[XCODE_COLORS_ESCAPE_FG UTF8String],\
[WarningColor UTF8String],\
[WarningTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String],\
[XCODE_COLORS_RESET_FG UTF8String]\
);\

// Error
#define LogError(format, ...) \
printf("%s%s;[%s][%s:%d] %s %s \n",\
[XCODE_COLORS_ESCAPE_FG UTF8String],\
[ErrorColor UTF8String],\
[ErrorTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String],\
[XCODE_COLORS_RESET_FG UTF8String]\
);\

// Success
#define LogSuccess(format, ...) \
printf("%s%s;[%s][%s:%d] %s %s \n",\
[XCODE_COLORS_ESCAPE_FG UTF8String],\
[SuccessColor UTF8String],\
[SuccessTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String],\
[XCODE_COLORS_RESET_FG UTF8String]\
);\

// Failure
#define LogFailure(format, ...) \
printf("%s%s;[%s][%s:%d] %s %s \n",\
[XCODE_COLORS_ESCAPE_FG UTF8String],\
[FailureColor UTF8String],\
[FailureTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String],\
[XCODE_COLORS_RESET_FG UTF8String]\
);\

#else /* Color Else */

// NSLog
#define NSLog(format, ...) \
printf("[%s][%s:%d] %s\n",\
[NSLogTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String]\
);\

// Information
#define LogInfo(format, ...) \
printf("[%s][%s:%d] %s\n",\
[InfoTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String]\
);\

// Debug
#define LogDebug(format, ...) \
printf("[%s][%s:%d] %s\n",\
[DebugTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String]\
);\

// Warning
#define LogWarning(format, ...) \
printf("[%s][%s:%d] %s\n",\
[WarningTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String]\
);\

// Error
#define LogError(format, ...) \
printf("[%s][%s:%d] %s\n",\
[ErrorTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String]\
);\

// Success
#define LogSuccess(format, ...) \
printf("[%s][%s:%d] %s\n",\
[SuccessTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String]\
);\

// Failure
#define LogFailure(format, ...) \
printf("[%s][%s:%d] %s\n",\
[FailureTitle UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String]\
);\

#endif /* Color End */

#else /* Debug Else */

#define NSLog(...) while(0){}
#define LogInfo(...) while(0){}
#define LogDebug(...) while(0){}
#define LogError(...) while(0){}
#define LogWarning(...) while(0){}
#define LogSuccess(...) while(0){}
#define LogFailure(...) while(0){}

#endif /* Debug End */


```
And then you can log within a Objective-C method like so:

```Objective-C Log
LogInfo("StarConsoleLink");
```

* Swift
```swift

let StarDebug = true

struct LogColor {

    static let XcodeColors = true

    static let ESCAPE = "\u{001b}["
    static let ESCAPE_FG = "\u{001b}[fg"
    static let ESCAPE_BG = "\u{001b}[bg"

    static let RESET = ESCAPE + ";"      // Clear any foreground or background color
    static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    static let RESET_BG = ESCAPE + "bg;" // Clear any background color
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
        guard StarDebug else {
            return
        }
        if LogColor.XcodeColors {
            Swift.print("\(LogColor.ESCAPE_FG)\(color);[\(title)][\((fileName as NSString).lastPathComponent):\(lineNumber)] \(value)\(LogColor.RESET_FG)")
        }
        else {
            Swift.print("[\(title)][\((fileName as NSString).lastPathComponent):\(lineNumber)] \(value)")
        }
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
