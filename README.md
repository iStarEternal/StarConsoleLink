
# Introduction 【简介】

StarConsoleLink inject the link to your Xcode console, which allows you to click on the link area rapid positioning to the log line.

StarConsoleLink给你的Xcode控制台注入了超链接，它能让你点击链接时，快速跳转到日志输出语句位置。

![Smaller icon](https://github.com/iStarEternal/StarConsoleLink/blob/master/ExampleImage/StarConsoleLink.gif "Case Diagram")


# How to use?  【使用说明】

Please note that plugins are not supported by Xcode 8. See https://github.com/alcatraz/Alcatraz/issues/475 for more information.


1.  If you are using Swift, Copy Logger.swift to you project.

2.  If you are using Objective-C, Copy Logger.h to you project and #import "Logger.h" to you PrefixHeader.pch.

3.  If you want to custom you logs, please follow the rules: [FileName.extension:LineNumber], Just like [main.swift:15].


1.  如果你使用的是Swift，请拷贝 Logger.swift 到你的项目中去。

2.  如果你使用的是Objective-C，请拷贝 Logger.h 到你的项目中，并在你的.pch文件中添加 #import "Logger.h"。

3.  如果你想要自定义你的日志，请遵照[FileName.extension:LineNumber]的书写规范，例：[main.swift:15]。


# Install 【安装】

```install
curl -fsSL https://raw.githubusercontent.com/iStarEternal/StarConsoleLink/master/Scripts/install.sh | sh
```



# Uninstall 【卸载】

```uninstall
curl -fsSL https://raw.githubusercontent.com/iStarEternal/StarConsoleLink/master/Scripts/uninstall.sh | sh
```


# The New Feature 【新功能】

#### v1.4.1

重构Logger.h并删除了Logger.m
现已加入alcatraz-packages（Package Manager）


#### v1.4

修复了1.3在控制台输入文字会发生闪退的BUG


#### v1.3

添加了NSDictionary和NSArray的日志显示，Unicode转中文

您现在可以在菜单栏 Plugins -> Star Console Link -> Chinese Unicode Enabled 选择是否关闭中文转换了。
```objective-c
LogWarning(@"%@", @{@"name": @"星星", @"age": @"18岁"});
```
```
以前：
<2016-07-14 14:07:03> [Warning][OCLogger.m:45] {
    age = "18\U5c81";
    name = "\U661f\U661f";
} 
现在：
<2016-07-14 14:07:41> [Warning][OCLogger.m:45] {
    age = "18岁";
    name = "星星";
} 
```


#### v1.2

添加了LogBackTrace，并对LogBackTrace的日志加入了超链接，您现在也可以更快的定位到日志的方法调用堆栈了。

您现在可以在菜单栏 Plugins -> Star Console Link -> Enabled 选择是否关闭StarConsoleLink

您现在可以在菜单栏 Plugins -> Star Console Link -> Setting 进行Link的颜色配置


#### v1.1

将OC的NSLog替换成了printf，并添加了日志输出时间



#### v1.0

StarConsoleLink集成了XcodeColors，他可以让你自定义你Log的颜色。感谢@robbiehanson提供的支持：https://github.com/robbiehanson/XcodeColors

给您的日志加入了超链接，让您可以更快的定位到打印输出的位置。

给您的日志加入了色彩元素，让您可以更好的区分日志的类型。

增强您的日志语句，您可以使用下面的语句来输出更多类型的日志。

```objective-c
LogInfo(@"你好");
// 黑色  [Info][ViewController.m:35]你好
LogSuccess(@"Hello");
// 绿色  [Success][ViewController.m:35]Hello
LogWarning(@"Bonjour");
// 黄色  [Warning][ViewController.m:35]Bonjour
LogError(@"¡Hola");
// 红色 [Error][ViewController.m:35]¡Hola
```

# If Ineffective【如果插件未生效】

第一步：请先检查你是否启用了该插件
```
defaults read com.apple.dt.Xcode DVTPlugInManagerNonApplePlugIns-Xcode-{Current Xcode Version}
```

第二步：如果发现插件在skipped中，请执行下列代码，然后重启Xcode，并点击Load Bundles
```
defaults delete com.apple.dt.Xcode DVTPlugInManagerNonApplePlugIns-Xcode-{Current Xcode Version}
```

# Example 【案例】

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

#if StarDebug /* Debug Begin */

#if StarXCodeColors != 0 /* Color Begin */

#define PrivateLog(color, title, format, ...)\
printf("%s%s;[%s][%s:%d] %s %s\n",\
[XCODE_COLORS_ESCAPE_FG UTF8String],\
[color UTF8String],\
[title UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String],\
[XCODE_COLORS_RESET_FG UTF8String]\
);\

// NSLog
#define NSLog(format, ...) \
PrivateLog(NSLogColor, NSLogTitle, format, ##__VA_ARGS__)

// Information
#define LogInfo(format, ...) \
PrivateLog(InfoColor, InfoTitle, format, ##__VA_ARGS__)

#else /* Color Else */

#define PrivateLog(color, title, format, ...)\
printf("[%s][%s:%d] %s\n",\
[title UTF8String],\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String]\
);\

// NSLog
#define NSLog(format, ...) \
PrivateLog(0, NSLogTitle, format, ##__VA_ARGS__)

// Information
#define LogInfo(format, ...) \
PrivateLog(0, InfoTitle, format, ##__VA_ARGS__)

#endif /* Color End */

#else /* Debug Else */

#define PrivateLog(color, title, format, ...) while(0){}
#define NSLog(...) while(0){}
#define LogInfo(...) while(0){}

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
    class func info<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: InfoTitle, color: InfoColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    class func debug<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: DebugTitle, color: DebugColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    class func warning<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: WarningTitle, color: WarningColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    class func error<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: ErrorTitle, color: ErrorColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    class func important<T>(value: T, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        print(value, title: ImportantTitle, color: ImportantColor, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
}

```
And then you can log within a Swift method like so:

```Swift
Logger.info("StarConsoleLink")
```
