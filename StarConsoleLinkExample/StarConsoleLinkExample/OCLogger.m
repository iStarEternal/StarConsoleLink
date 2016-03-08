//
//  OCLogger.m
//  StarConsoleLinkExample
//
//  Created by 黄耀红 on 16/2/17.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//
#ifdef DEBUG
#define NSLog(format, ...) NSLog(@"[Info][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])
#else
#define NSLog(...) while(0){}
#endif


#import "OCLogger.h"

@implementation OCLogger

- (void)runLog {
    NSLog(@"当前在Objective-C中测试打印");
}

@end
