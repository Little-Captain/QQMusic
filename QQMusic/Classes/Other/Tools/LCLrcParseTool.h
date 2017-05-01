//
//  LCLrcParseTool.h
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCLrcLineItem;

@interface LCLrcParseTool : NSObject

+ (NSArray *)getLrcList:(NSString *)lrcName;

@end
