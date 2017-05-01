//
//  LCLrcCell.m
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCLrcCell.h"
#import "LCLrcLabel.h"
#import <Masonry.h>

static NSString * const LrcCellID = @"LrcCellID";

@implementation LCLrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    // 创建 lrcLabel
    LCLrcLabel *lrcLabel = [LCLrcLabel new];
    [self.contentView addSubview:lrcLabel];
    [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(lrcLabel.superview);
    }];
    // 其他设置
    self.backgroundColor = [UIColor clearColor];
    lrcLabel.textAlignment = NSTextAlignmentCenter;
    lrcLabel.textColor = [UIColor whiteColor];
    lrcLabel.font = [UIFont systemFontOfSize:13];
    self.lrcLabel = lrcLabel;
    
    return self;
}

+ (LCLrcCell *)lrcCell:(UITableView *)tableView {
    
    LCLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:LrcCellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LrcCellID];
    }
    
    return cell;
}

@end
