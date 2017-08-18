//
//  StarFunctions.h
//  StarConsoleLink
//
//  Created by 星星 on 16/2/25.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface StarFunctions: NSObject
+ (NSString*)workspacePath;
+ (void)printMothList:(Class)class;
+ (NSArray *)getAllProperties:(Class)class;
+ (NSDictionary *)properties_aps:(Class)class;
@end