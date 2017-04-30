//
//  LCMusicItem.h
//  QQMusic
//
//  Created by Liu-Mac on 4/30/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCMusicItem : NSObject

/** 歌曲名 */
@property (nonatomic, strong) NSString *name;

/** mp3 文件名 */
@property (nonatomic, strong) NSString *filename;

/** lrc 歌词文件名 */
@property (nonatomic, strong) NSString *lrcname;

/** 歌手名 */
@property (nonatomic, strong) NSString *singer;

/** 歌手图片 */
@property (nonatomic, strong) NSString *singerIcon;

/** 封面图片 */
@property (nonatomic, strong) NSString *icon;

@end
