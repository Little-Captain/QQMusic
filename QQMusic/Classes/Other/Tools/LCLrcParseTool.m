//
//  LCLrcParseTool.m
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCLrcParseTool.h"
#import "LCLrcLineItem.h"

#import <RXCollection.h>

@implementation LCLrcParseTool

+ (NSArray *)getLrcList:(NSString *)lrcName {
    
    // 获取歌词的全路径
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    
    // 将 lrc 文件转为字符串
    NSString *lrcLineStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // 将字符串以'\n'进行分割成数组
    // 过滤 :
    // 映射 : line string -> line item
    return [[[lrcLineStr componentsSeparatedByString:@"\n"] rx_filterWithBlock:^BOOL(NSString *each) {
        if ([each hasPrefix:@"[ti:"] ||
            [each hasPrefix:@"[ar:"] ||
            [each hasPrefix:@"[al:"] ||
            ![each hasPrefix:@"["]) {
            return NO;
        } else {
            return YES;
        }
    }] rx_mapWithBlock:^LCLrcLineItem *(NSString *each) {
        return [[LCLrcLineItem alloc] initWithLine:each];
    }];
}

@end
