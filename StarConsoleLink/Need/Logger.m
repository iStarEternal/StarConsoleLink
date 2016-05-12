//
//  Logger.m
//  StarConsoleLinkExample
//
//  Created by 星星 on 16/5/9.
//  Copyright © 2016年 星星. All rights reserved.
//

#import "Logger.h"

#import <stdio.h>
#import <stdlib.h>
#import <execinfo.h>

char * strjoin(char *s1, char *s2);

const char * getBackTrace(int stack, int depth) {
    
    if (stack) {
        void* callstack[128];
        int frames = backtrace(callstack, 128);
        char **strs = backtrace_symbols(callstack, frames);
        
        char * backtrace = "\n<BackTrace Begin>";
        for (int i = 1; i < frames; i++) {
            backtrace = strjoin(backtrace, "\n\t");
            backtrace = strjoin(backtrace, strs[i]);
            if (i == depth)
                break;
        }
        free(strs);
        
        backtrace = strjoin(backtrace, "\n<End>");
        return backtrace;
    }
    return "";
}

char * strjoin(char *s1, char *s2) {
    char *result = malloc(strlen(s1) + strlen(s2) + 1);
    if (result == NULL)
        exit (1);
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}
