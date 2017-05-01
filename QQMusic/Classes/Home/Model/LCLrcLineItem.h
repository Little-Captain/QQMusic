//
//  LCLrcLineItem.h
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLrcLineItem : NSObject

/** 时间(s) */
@property (nonatomic, assign) NSTimeInterval time;
/** 歌词 */
@property (nonatomic, copy) NSString *text;

- (instancetype)initWithLine:(NSString *)lineStr;

@end
