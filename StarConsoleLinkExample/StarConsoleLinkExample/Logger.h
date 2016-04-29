//
//  Logger.h
//  StarConsoleLink
//
//  Created by 星星 on 16/4/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

#ifndef Logger_h
#define Logger_h

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


#endif /* Logger_h */
