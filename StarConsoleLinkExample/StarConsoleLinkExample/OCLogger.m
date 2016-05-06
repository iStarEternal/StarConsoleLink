//
//  OCLogger.m
//  StarConsoleLinkExample
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//



#import "OCLogger.h"
#import "Logger.h"
//#import "NSLog-Logger.h"



@interface OCLogger ()

@end

@implementation OCLogger

- (void)runLog {
    
    LogWarning(@"------------------ ObjectiveC Logger Test ------------------");
    PrivateLog(@"0,0,0", @"Hello", 0, @"你好：%@", @"星星");
    NSLog(@"NSLog");
    LogDebug(@"调试");
    LogInfo(@"消息");
    LogWarning(@"警告");
    LogError(@"错误");
    LogSuccess(@"成功");
    LogFailure(@"失败");
    LogBackTrace(@"堆栈信息");
}

@end
