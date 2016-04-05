//
//  LogColorKit.h
//  StarConsoleLink
//
//  Created by 星星 on 16/2/19.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface LogColorKit : NSObject

+ (void)applyANSIColorsWithTextStorage:(NSTextStorage *)textStorage
                      textStorageRange:(NSRange)textStorageRange
                             escapeSeq:(NSString *)escapeSeq;
//void ApplyANSIColors(NSTextStorage *textStorage, NSRange textStorageRange, NSString *escapeSeq);

@end
