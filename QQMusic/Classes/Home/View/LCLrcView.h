//
//  LCLrcView.h
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCLrcLabel;

@interface LCLrcView : UIScrollView

/** 歌词文件名 */
@property (nonatomic, copy) NSString *lrcName;
/** 主界面的歌词的 label */
@property (nonatomic, strong) LCLrcLabel *lrcLabel;
/** 当前的播放器的播放时间 */
@property (nonatomic, assign) NSTimeInterval currentTime;

@end
