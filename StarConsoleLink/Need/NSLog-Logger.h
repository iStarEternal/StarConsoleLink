//
//  Logger.h
//  StarConsoleLink
//
//  Created by 星星 on 16/4/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

#ifndef NSLog_Logger_h
#define NSLog_Logger_h

#define StarDebug DEBUG
#define StarXCodeColors 1

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


#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_ESCAPE_FG @"\033[fg"
#define XCODE_COLORS_ESCAPE_BG @"\033[bg"
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color


#define LogInfo(format, ...) \
NSLog(XCODE_COLORS_ESCAPE_FG InfoColor @";" @"[" InfoTitle @"][%@:%d] %@" XCODE_COLORS_RESET_FG, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogDebug(format, ...) \
NSLog(XCODE_COLORS_ESCAPE_FG DebugColor @";" @"[" DebugTitle @"][%@:%d] %@" XCODE_COLORS_RESET_FG, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogWarning(format, ...) \
NSLog(XCODE_COLORS_ESCAPE_FG WarningColor @";" @"[" WarningTitle @"][%@:%d] %@" XCODE_COLORS_RESET_FG, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogError(format, ...) \
NSLog(XCODE_COLORS_ESCAPE_FG ErrorColor @";" @"[" ErrorTitle @"][%@:%d] %@" XCODE_COLORS_RESET_FG, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogSuccess(format, ...) \
NSLog(XCODE_COLORS_ESCAPE_FG SuccessColor @";" @"[" SuccessTitle @"][%@:%d] %@" XCODE_COLORS_RESET_FG, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#define LogFailure(format, ...) \
NSLog(XCODE_COLORS_ESCAPE_FG FailureColor @";" @"[" FailureTitle @"][%@:%d] %@" XCODE_COLORS_RESET_FG, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])

#else /* Color Else */

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

#endif /* Color End */

#else /* Debug Else */

#define LogInfo(...) while(0){}
#define LogDebug(...) while(0){}
#define LogError(...) while(0){}
#define LogWarning(...) while(0){}
#define LogSuccess(...) while(0){}
#define LogFailure(...) while(0){}

#endif /* Debug End */


#endif /* NSLog_Logger_h */
