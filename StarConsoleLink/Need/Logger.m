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

char * strjoin(const char *s1, const char *s2);

char * strjoin(const char *s1, const char *s2) {
    
    char *result = malloc(strlen(s1) + strlen(s2) + 1);
    if (result == NULL)
        exit (EXIT_FAILURE);
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}



#define BACK_TRACE_BUFFER 4096

static char backtracestr[BACK_TRACE_BUFFER];

const char * getBackTrace(int open, int depth) {
    
    if (!open) {
        return "";
    }
    void *callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    memset(backtracestr, 0, BACK_TRACE_BUFFER * sizeof(char));
    strcat(backtracestr, "\n<BackTrace Begin>");
    for (int i = 1; i < frames; i++) {
        strcat(backtracestr, "\n\t");
        strcat(backtracestr, strs[i]);
        if (i == depth)
            break;
    }
    strcat(backtracestr, "\n<End>");
    
    free(strs);
    strs = NULL;
    
    return backtracestr;
    
}


#define TIME_BUFFER 255

static char timestr[TIME_BUFFER];

const char * currentTime() {
    
    time_t rawtime;
    struct tm * timeinfo;
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    memset(timestr, 0, TIME_BUFFER * sizeof(char));
    strftime(timestr, TIME_BUFFER, "%Y-%m-%d %H:%M:%S", timeinfo);
    return timestr;
}




