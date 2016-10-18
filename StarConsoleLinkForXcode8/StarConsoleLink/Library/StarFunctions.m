//
//  StarFunctions.m
//  StarConsoleLink
//
//  Created by 星星 on 16/2/25.
//  Copyright © 2016年 AbsoluteStar. All rights reserved.
//

#import "StarFunctions.h"
#import <objc/runtime.h>
#import "JRSwizzle.h"

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

+ (void)printMothList:(Class)class {
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList(class, &mothCout_f);
    for(int i=0;i<mothCout_f;i++) {
        Method temp_f = mothList_f[i];
        // IMP imp_f = method_getImplementation(temp_f);
        // SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding =method_getTypeEncoding(temp_f);
        if ([@"insertNewline:" isEqualToString:[NSString stringWithUTF8String:name_s]]) {
            //debugger
        }
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,[NSString stringWithUTF8String:encoding]);
    }
    free(mothList_f);
}

+ (NSArray *)getAllProperties:(Class)class {
    u_int count;
    objc_property_t *properties  =class_copyPropertyList(class, &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}
+ (NSDictionary *)properties_aps:(Class)class {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [[[class alloc] init] valueForKey:propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}
@end
