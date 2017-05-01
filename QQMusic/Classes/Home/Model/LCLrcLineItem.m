//
//  LCLrcLineItem.m
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCLrcLineItem.h"

@implementation LCLrcLineItem

- (instancetype)initWithLine:(NSString *)lineStr {
    
    // [00:01.40]朋友
    NSArray<NSString *> *allComponents = [lineStr componentsSeparatedByString:@"]"];
    
    // 时间 : 00:01.40
    NSString *timeStr = [allComponents.firstObject componentsSeparatedByString:@"["].lastObject;
    NSTimeInterval min = [[timeStr componentsSeparatedByString:@":"].firstObject doubleValue];
    NSTimeInterval second = [[timeStr substringWithRange:NSMakeRange(3, 2)] doubleValue];
    NSTimeInterval millisecond = [[timeStr substringWithRange:NSMakeRange(6, 2)] doubleValue];
    self.time = min * 60 + second + millisecond * 0.01;
    // 歌词 : 朋友
    self.text = allComponents.lastObject;
    
    return self;
}

@end
