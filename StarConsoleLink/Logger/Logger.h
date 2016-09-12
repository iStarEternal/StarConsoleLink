//
//  Logger.h
//  StarConsoleLink
//
//  Created by 星星 on 16/4/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

#ifndef Logger_h
#define Logger_h

#define StarDebug DEBUG         // DEBUG环境下使用
#define StarXCodeColors 1       // 开关颜色
#define StarBackTrace 0         // 开关方法调用栈输出
#define StarBackTraceDepth 4    // 栈深度


//#define STAR_CONSOLE_COLOR_ESCAPE     "\033["
#define STAR_CONSOLE_COLOR_ESCAPE_FG  "\033[fg"
//#define STAR_CONSOLE_COLOR_ESCAPE_BG  "\033[bg"

//#define STAR_CONSOLE_COLOR_RESET      "\033[;"
#define STAR_CONSOLE_COLOR_RESET_FG   "\033[fg;"
//#define STAR_CONSOLE_COLOR_RESET_BG   "\033[bg;"


#define NSLogColor "22,22,22"           // 黑色
#define NSLogTitle "Info"

#define InfoColor "22,22,22"            // 黑色
#define InfoTitle "Info"

#define DebugColor "28,0,207"           // 蓝色
#define DebugTitle "Debug"

#define WarningColor "218,130,53"       // 黄色
#define WarningTitle "Warning"

#define ErrorColor "196,26,22"          // 红色
#define ErrorTitle "Error"

#define SuccessColor "0,116,0"          // 绿色
#define SuccessTitle "Success"

#define FailureColor "196,26,22"        // 红色
#define FailureTitle "Failure"

#define AssertColor "196,26,22"         // 红色
#define AssertTitle "Assert"

#define BackTraceColor "22,22,22"       // 黑色
#define BackTraceTitle "BackTrace"


#if StarDebug /* Debug Begin */

#if StarXCodeColors != 0 /* Color Begin */

#define PrivateLog(color, title, stack, format, ...)\
printf("%s%s;<%s> [%s][%s:%d] %s %s %s\n",\
STAR_CONSOLE_COLOR_ESCAPE_FG,\
color,\
star_current_time(),\
title,\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String],\
STAR_CONSOLE_COLOR_RESET_FG,\
star_back_trace(stack, StarBackTraceDepth)\
)\

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

// LogBackTrace
#define LogBackTrace(format, ...) \
PrivateLog(BackTraceColor, BackTraceTitle, 1, format, ##__VA_ARGS__)\

#else /* Color Else */

#define PrivateLog(color, title, stack, format, ...)\
printf("<%s> [%s][%s:%d] %s %s\n",\
star_current_time(),\
title,\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__,\
[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String],\
star_back_trace(stack, StarBackTraceDepth)\
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




/* Function Begin */

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <execinfo.h>
#include <time.h>
#include <sys/timeb.h>

#define STAR_BACK_TRACE_BUFFER 4096
#define STAR_TIME_BUFFER 255


static inline const char * star_back_trace(int open, int depth) {
    
    if (!open) {
        return "";
    }
    
    static char star_back_trace_str[STAR_BACK_TRACE_BUFFER];
    
    void *callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    memset(star_back_trace_str, 0, STAR_BACK_TRACE_BUFFER * sizeof(char));
    strcat(star_back_trace_str, "\n<BackTrace Begin>");
    for (int i = 1; i < frames; i++) {
        // if (strlen(star_back_trace_str) + strlen(strs[i]) + 16 > STAR_BACK_TRACE_BUFFER)
        //     break;
        strcat(star_back_trace_str, "\n\t");
        strcat(star_back_trace_str, strs[i]);
        if (i == depth)
            break;
    }
    strcat(star_back_trace_str, "\n<End>");
    
    free(strs);
    strs = NULL;
    
    return star_back_trace_str;
}

static inline const char * star_current_time() {
    
    static char star_time_str[STAR_TIME_BUFFER];
    
    time_t rawtime;
    struct tm * timeinfo;
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    memset(star_time_str, 0, STAR_TIME_BUFFER * sizeof(char));
    strftime(star_time_str, STAR_TIME_BUFFER, "%Y-%m-%d %H:%M:%S", timeinfo);
    return star_time_str;
}

/**
 *  如果需要用到毫秒，那就替换成下列函数好了
 */
static inline const char * star_current_time_milli() {
    
    static char star_time_str[STAR_TIME_BUFFER];
    
    struct timeb timeinfo;
    ftime(&timeinfo);
    
    struct tm * second_timeinfo;
    second_timeinfo = localtime(&timeinfo.time);
    
    memset(star_time_str, 0, STAR_TIME_BUFFER * sizeof(char));
    strftime(star_time_str, STAR_TIME_BUFFER, "%Y-%m-%d %H:%M:%S", second_timeinfo);
    
    char millitm[16];
    sprintf(millitm, ".%03d", timeinfo.millitm);
    strcat(star_time_str, millitm);
    return star_time_str;
}

/* Function End */



#endif /* Logger_h */
