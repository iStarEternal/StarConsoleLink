//
//  Logger.m
//  StarConsoleLinkExample
//
//  Created by 星星 on 16/5/9.
//  Copyright © 2016年 星星. All rights reserved.
//

#include "Logger.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <execinfo.h>
#include <time.h>
#include <sys/timeb.h>


#define STAR_BACK_TRACE_BUFFER 4096

static char star_back_trace_str[STAR_BACK_TRACE_BUFFER];

const char* star_back_trace(int open, int depth) {
    
    if (!open) {
        return "";
    }
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


#define STAR_TIME_BUFFER 255

static char star_time_str[STAR_TIME_BUFFER];

const char* star_current_time() {
    
    time_t rawtime;
    struct tm * timeinfo;
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    memset(star_time_str, 0, STAR_TIME_BUFFER * sizeof(char));
    strftime(star_time_str, STAR_TIME_BUFFER, "%Y-%m-%d %H:%M:%S", timeinfo);
    return star_time_str;
}


// 某些用户需要用到毫秒，那就替换成下列函数好了

//const char* star_current_time() {
//
//    struct timeb timeinfo;
//    ftime(&timeinfo);
//
//    struct tm * second_timeinfo;
//    second_timeinfo = localtime(&timeinfo.time);
//
//    memset(star_time_str, 0, STAR_TIME_BUFFER * sizeof(char));
//    strftime(star_time_str, STAR_TIME_BUFFER, "%Y-%m-%d %H:%M:%S", second_timeinfo);
//
//    char millitm[16];
//    sprintf(millitm, ".%03d", timeinfo.millitm);
//    strcat(star_time_str, millitm);
//    return star_time_str;
//}


