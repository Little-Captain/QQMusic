//
//  LCLrcCell.h
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCLrcLabel;

@interface LCLrcCell : UITableViewCell

/** 显示歌词的 label */
@property (nonatomic, strong) LCLrcLabel *lrcLabel;

+ (LCLrcCell *)lrcCell:(UITableView *)tableView;

@end
