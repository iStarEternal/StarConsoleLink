//
//  StarFunctions.m
//  StarConsoleLink
//
//  Created by 星星 on 16/2/25.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

#import "StarFunctions.h"

@implementation StarFunctions

+ (NSString*)workspacePath {
    @try {
        NSDocument *document = [NSApp orderedDocuments].firstObject;
        return [[document valueForKeyPath:@"_workspace.representingFilePath.fileURL"] URLByDeletingLastPathComponent].path;
    }
    @catch (NSException *exception) {
        return nil;
    }
    return nil;
}

@end
