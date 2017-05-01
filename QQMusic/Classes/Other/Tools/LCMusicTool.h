//
//  LCMusicTool.h
//  QQMusic
//
//  Created by Liu-Mac on 4/30/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCMusicItem;

@interface LCMusicTool : NSObject

/** 获取/修改当前播放的歌曲 */
+ (LCMusicItem *)playingMusic;

/** 获取下一首歌曲 */
+ (LCMusicItem *)nextMusic;

/** 获取上一首歌曲 */
+ (LCMusicItem *)previousMusic;

@end
