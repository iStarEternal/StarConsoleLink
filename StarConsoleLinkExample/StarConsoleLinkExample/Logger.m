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
#import <Foundation/Foundation.h>

const char * getBackTrace(int stack, int depth) {
    
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
