//
//  LCLrcView.m
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCLrcView.h"
#import "LCLrcLabel.h"
#import "LCLrcCell.h"
#import "LCLrcParseTool.h"
#import "LCLrcLineItem.h"

#import <Masonry.h>

@interface LCLrcView () <UITableViewDataSource>

/** 显示歌词的 TableView */
@property (nonatomic, strong) UITableView *tableView;
/** 歌词的模型数组 */
@property (nonatomic, strong) NSArray<LCLrcLineItem *> *lrcList;

@end

@implementation LCLrcView {
    
    NSInteger _currentIndex;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
    // 添加约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView.superview.mas_left).offset([UIScreen mainScreen].bounds.size.width);
        make.right.equalTo(self.tableView.superview.mas_right);
        make.top.equalTo(self.tableView.superview.mas_top);
        make.bottom.equalTo(self.tableView.superview.mas_bottom);
        make.size.equalTo(self.tableView.superview);
    }];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 清空tableView的颜色
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 清空tableView的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置额外滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.bounds.size.height * 0.5, 0, self.tableView.bounds.size.height * 0.5, 0);
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
    }
    
    return _tableView;
}

- (void)setLrcName:(NSString *)lrcName {
    
    _lrcName = [lrcName copy];
    
    // 初始化当前歌词的下标
    _currentIndex = -1;
    // 设置歌词显示在屏幕中间
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.contentOffset = CGPointMake(0, -self.tableView.bounds.size.height * 0.5);
    });
    // 获取内部解析歌词文件转化为数组的模型
    NSArray<LCLrcLineItem *> *lrcList = [LCLrcParseTool getLrcList:lrcName];
    // 给 lrcLabel 赋值
    _lrcLabel.progress = 0;
    _lrcLabel.text = [lrcList.firstObject text];
    // 赋值给当前数组属性
    self.lrcList = lrcList;
}

- (void)setLrcList:(NSArray<LCLrcLineItem *> *)lrcList {
    
    _lrcList = lrcList;
    
    [self.tableView reloadData];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    
    if (!_lrcList) { return; }
    // 遍历模型数组
    for (NSInteger i = 0; i < _lrcList.count; ++i) {
        
        // 获取当前歌词的时间
        NSTimeInterval currentLrcTime = _lrcList[i].time;
        // 获取下一句歌词的时间
        NSTimeInterval nextLrcTime = 0.0;
        if (i < _lrcList.count - 1) {
            nextLrcTime = _lrcList[i+1].time;
        }
        if (currentTime >= currentLrcTime && currentLrcTime > nextLrcTime) {
            nextLrcTime = MAXFLOAT;
        }
        // 当前播放器的播放时间 大于等于 当前歌词的播放时间,
        // 并且 小于 下一句歌词的播放时间,则显示当前这句歌词
        if (_currentIndex != i && currentTime >= currentLrcTime && currentTime < nextLrcTime) {
            // 当前这句歌词移动到中间
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            // 滚动到对应的行
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            // 记录当前歌词的下标
            _currentIndex = i;
            // 刷新歌词 cell
            [self.tableView reloadData];
            // 更新主界面的歌词的 label
            _lrcLabel.text = _lrcList[i].text;
        }
        
        if (i == _currentIndex) { // 当前这句歌词
            // 当前播放器的播放时间 - 当前这句歌词的时间 / 下一句歌词的时间 - 当前这句歌词的时间
            float progress = (currentTime - currentLrcTime) / (nextLrcTime - currentLrcTime);
            // 获取当前这句歌词的 cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            LCLrcCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            // 更新cell的lrclabel的进度
            cell.lrcLabel.progress = progress;
            // 更新主界面的歌词的 label 进度
            self.lrcLabel.progress = progress;
        }
    }
}



#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _lrcList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LCLrcCell *cell = [LCLrcCell lrcCell:tableView];
    
    // 取出对应的模型
    LCLrcLineItem *lrcItem = _lrcList[indexPath.row];
    
    cell.lrcLabel.text = lrcItem.text;
    
    if (_currentIndex == indexPath.row) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:16];
    } else {
        cell.lrcLabel.font = [UIFont systemFontOfSize:13];
        cell.lrcLabel.progress = 0;
    }
    
    return cell;
}

@end
