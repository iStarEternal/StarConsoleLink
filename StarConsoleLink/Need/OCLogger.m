//
//  OCLogger.m
//  StarConsoleLinkExample
//
//  Created by 黄耀红 on 16/2/17.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//






#import "OCLogger.h"

@implementation OCLogger

- (void)runLog {
    
    LogWarning(@"------------------ ObjectiveC Logger Test ------------------");
    LogDebug(@"调试");
    LogInfo(@"消息");
    LogError(@"错误");
    LogWarning(@"警告");
    LogSuccess(@"成功");
    LogFailure(@"失败");
}

@end
