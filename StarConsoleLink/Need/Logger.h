//
//  Logger.h
//  StarConsoleLink
//
//  Created by 星星 on 16/4/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

#ifndef Logger_h
#define Logger_h

const char* getBackTrace(int stack, int depth);

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

#define AssertColor @"196,26,22"      // 红色
#define AssertTitle @"Assert"

#define BackTraceColor @"22,22,22"          // 黑色
#define BackTraceTitle @"BackTrace"


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

// Assert
#define LogAssert(condition, format, ...)\
PrivateLog(AssertColor, AssertTitle, StarBackTrace, format, ##__VA_ARGS__);\
NSAssert(condition, format, ##__VA_ARGS__)

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

// Assert
#define LogAssert(condition, format, ...)\
PrivateLog(0, FailureTitle, StarBackTrace, format, ##__VA_ARGS__);\
NSAssert(condition, format, ##__VA_ARGS__)

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
#define LogAssert(condition, format, ...) while(0){}
#define LogBackTrace(...) while(0){}

#endif /* Debug End */


#endif /* Logger_h */
