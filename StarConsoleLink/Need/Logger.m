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

char * strjoin(const char *s1, const char *s2);

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

char * strjoin(const char *s1, const char *s2) {
    
    char *result = malloc(strlen(s1) + strlen(s2) + 1);
    if (result == NULL)
        exit (1);
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}


//const char * getBackTrace(int stack, int depth) {
//
//    if (stack) {
//        void* callstack[128];
//        int frames = backtrace(callstack, 128);
//        char **strs = backtrace_symbols(callstack, frames);
//
//        NSMutableString * backtrace = [@"\n<BackTrace Begin>" mutableCopy];
//        for (int i = 1; i < frames; i++) {
//            [backtrace appendString:@"\n\t"];
//            [backtrace appendString:[NSString stringWithUTF8String:strs[i]]];
//            if (i == depth)
//                break;
//        }
//        free(strs);
//
//        [backtrace appendString:@"\n<End>"];
//        return [[backtrace copy] UTF8String];
//    }
//    return "";
//}