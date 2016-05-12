//
//  OCLogger.m
//  StarConsoleLinkExample
//
//  Created by 星星 on 16/1/28.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//



#import "OCLogger.h"
#import "Logger.h"



@interface OCLogger ()

@end

@implementation OCLogger

//+ (void)backTrace:(NSString *)bt arg1:(NSString *)arg1 arg2:(NSString *)agr2;
+ (void)backTrace:(NSString *)bt
             arg1:(NSString *)arg1
             arg2:(NSString *)agr2{
    LogBackTrace(@"%@", bt);
}
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
    LogBackTrace(@"堆栈信息");
    LogBackTrace(@"堆栈信息");
    LogInfo(@"%s, ", __TIME__);
    LogInfo(@"%s, ", __DATE__);
    
    [OCLogger backTrace:@"啦啦啦" arg1: @"" arg2: @""];
    // LogAssert(false, @"检测%@",@"错误");
}

@end
