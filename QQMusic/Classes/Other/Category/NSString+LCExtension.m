//
//  NSString+LCExtension.m
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "NSString+LCExtension.h"

@implementation NSString (LCExtension)

+ (instancetype)musicTimeFormater:(NSTimeInterval)time {
    
    // 分钟
    NSUInteger min = (NSUInteger)time / 60;
    // 秒
    NSUInteger second = (NSUInteger)time % 60;
    return [NSString stringWithFormat:@"%02zd:%02zd", min, second];
}

@end
