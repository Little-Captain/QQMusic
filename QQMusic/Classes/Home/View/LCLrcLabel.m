//
//  LCLrcLabel.m
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCLrcLabel.h"

@implementation LCLrcLabel

- (void)setProgress:(float)progress {
    
    _progress = progress;
    
    // 歌词进度改变了, 需要重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    // 重绘的矩形
    CGRect drawRect = CGRectMake(0, 0, rect.size.width * _progress, rect.size.height);
    
    [[UIColor purpleColor] set];
    
    // 开始重绘
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
}

@end
