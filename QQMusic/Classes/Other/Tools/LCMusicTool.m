//
//  LCMusicTool.m
//  QQMusic
//
//  Created by Liu-Mac on 4/30/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCMusicTool.h"
#import "LCMusicItem.h"

#import <MJExtension.h>

@implementation LCMusicTool

static NSArray<LCMusicItem *> *_musics;
/** 获取当前的所有歌曲 */
+ (NSArray<LCMusicItem *> *)allMusics {
    
    if (_musics) { return _musics; }
    
    _musics = [LCMusicItem mj_objectArrayWithFilename:@"Musics.plist"].copy;
    
    return _musics;
}

/** 获取/修改当前播放的歌曲 */
+ (LCMusicItem *)playingMusic {
    
    return [self allMusics][1];
}

/** 获取下一首歌曲 */
+ (LCMusicItem *)nextMusic {
    
    // 获取当前正在播放的歌曲的下标
    NSUInteger index = [[self allMusics] indexOfObject:[self playingMusic]];
    
    // 获取下一首歌曲的下标
    NSUInteger nextIndex;
    if (index >= [self allMusics].count - 1) {
        nextIndex = 0;
    } else {
        nextIndex = index + 1;
    }
    return [self allMusics][nextIndex];
}

/** 获取上一首歌曲 */
+ (LCMusicItem *)previousMusic {
    
    // 获取当前正在播放的歌曲的下标
    NSUInteger index = [[self allMusics] indexOfObject:[self playingMusic]];
    
    // 获取下一首歌曲的下标
    NSUInteger previousIndex;
    if (index == 0) {
        previousIndex = [self allMusics].count - 1;
    } else {
        previousIndex = index - 1;
    }
    return [self allMusics][previousIndex];
}

@end
