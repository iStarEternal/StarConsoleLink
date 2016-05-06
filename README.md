
## Introduction

StarConsoleLink inject the link to your Xcode console, which allows you to click on the link area rapid positioning to the log line.

StarConsoleLink给你的Xcode控制台注入了超链接，它能让你点击链接区域快速跳转到代码位置。

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

#include <stdio.h>
#include <stdlib.h>
#include <execinfo.h>



#define StarDebug DEBUG
#define StarXCodeColors 1
#define StarBackTrace 0

#define StarBackTraceDepth 4

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

#define BackTraceColor @"22,22,22"          // 黑色
#define BackTraceTitle @"BackTrace"


const char* getBackTrace(BOOL stack, int depth);

const char* getBackTrace(BOOL stack, int depth) {

    if (stack) {
        void* callstack[128];
        int frames = backtrace(callstack, 128);
        char **strs = backtrace_symbols(callstack, frames);
        NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
        for (int i = 1; i < frames; i++) {
            NSString *str = [NSString stringWithUTF8String:strs[i]];
            [backtrace addObject:str];
            if (i == depth)
                break;
        }
        free(strs);
        return [[NSString stringWithFormat:@"\n%@", backtrace.description] UTF8String];
    }
    return "";
}


#if StarDebug /* Debug Begin */

#if StarXCodeColors != 0 /* Color Begin */

#define PrivateLog(color, title, stack, format, ...)\
printf("%s%s;[%s][%s:%d] %s %s %s\n",\
[XCODE_COLORS_ESCAPE_FG UTF8String],\
[color UTF8String],\
[title UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String],\
[XCODE_COLORS_RESET_FG UTF8String],\
getBackTrace(stack, StarBackTraceDepth)\
);\

// NSLog
#define NSLog(format, ...) \
PrivateLog(NSLogColor, NSLogTitle, StarBackTrace, format, ##__VA_ARGS__)

// Information
#define LogInfo(format, ...) \
PrivateLog(InfoColor, InfoTitle, StarBackTrace, format, ##__VA_ARGS__)

// Debug
#define LogDebug(format, ...) \
PrivateLog(DebugColor, DebugTitle, StarBackTrace, format, ##__VA_ARGS__)

// Warning
#define LogWarning(format, ...) \
PrivateLog(WarningColor, WarningTitle, StarBackTrace, format, ##__VA_ARGS__)

// Error
#define LogError(format, ...) \
PrivateLog(ErrorColor, ErrorTitle, StarBackTrace, format, ##__VA_ARGS__)

// Success
#define LogSuccess(format, ...) \
PrivateLog(SuccessColor, SuccessTitle, StarBackTrace, format, ##__VA_ARGS__)

// Failure
#define LogFailure(format, ...) \
PrivateLog(FailureColor, FailureTitle, StarBackTrace, format, ##__VA_ARGS__)


// Stack
#define LogBackTrace(format, ...) \
PrivateLog(BackTraceColor, BackTraceTitle, 1, format, ##__VA_ARGS__)\

#else /* Color Else */

#define PrivateLog(color, title, stack, format, ...)\
printf("[%s][%s:%d] %s %s\n",\
[title UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String],\
getBackTrace(stack, StarBackTraceDepth)\
);\

// NSLog
#define NSLog(format, ...) \
PrivateLog(0, NSLogTitle, StarBackTrace, format, ##__VA_ARGS__)

// Information
#define LogInfo(format, ...) \
PrivateLog(0, InfoTitle, StarBackTrace, format, ##__VA_ARGS__)

// Debug
#define LogDebug(format, ...) \
PrivateLog(0, DebugTitle, StarBackTrace, format, ##__VA_ARGS__)

// Warning
#define LogWarning(format, ...) \
PrivateLog(0, WarningTitle, StarBackTrace, format, ##__VA_ARGS__)

// Error
#define LogError(format, ...) \
PrivateLog(0, ErrorTitle, StarBackTrace, format, ##__VA_ARGS__)

// Success
#define LogSuccess(format, ...) \
PrivateLog(0, SuccessTitle, StarBackTrace, format, ##__VA_ARGS__)

// Failure
#define LogFailure(format, ...) \
PrivateLog(0, FailureTitle, StarBackTrace, format, ##__VA_ARGS__)

// Stack
#define LogBackTrace(format, ...) \
PrivateLog(0, BackTraceTitle, 1, format, ##__VA_ARGS__)\

#endif /* Color End */

#else /* Debug Else */

#define PrivateLog(color, title, format, ...) while(0){}
#define NSLog(...) while(0){}
#define LogInfo(...) while(0){}
#define LogDebug(...) while(0){}
#define LogError(...) while(0){}
#define LogWarning(...) while(0){}
#define LogSuccess(...) while(0){}
#define LogFailure(...) while(0){}
#define LogBackTrace(...) while(0){}

#endif /* Debug End */


```
And then you can log within a Objective-C method like so:

```Objective-C
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
