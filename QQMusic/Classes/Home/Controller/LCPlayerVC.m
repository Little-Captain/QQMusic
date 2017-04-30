//
//  LCPlayerVC.m
//  QQMusic
//
//  Created by Liu-Mac on 4/30/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

// view 加载到展示的过程
// 1. loadView : 创建加载 view
// 2. viewDidLoad : view 加载完成
// 3. viewWillAppear : view 即将显示
// 4. viewWillLayoutSubviews : view 即将布局内部子控件
// 5. viewDidLayoutSubviews : view 布局了了内部子控件
// 4->5, 4->5 会来回调用多次
// 6. viewDidAppear : view 显示完成

// view 消失过程
// 1. viewWillDisappear
// 2. viewDidDisappear

#import "LCPlayerVC.h"

@interface LCPlayerVC ()

@property (weak, nonatomic) IBOutlet UIImageView *albumImageV;
@property (weak, nonatomic) IBOutlet UISlider *musicProgress;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;

@end

@implementation LCPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 这里面拿到的控件的大小是storyboard中布局时使用的界面大小, 而不是程序运行时的实际大小
    // 解决方案
    // 1. 在 viewWillLayoutSubviews 方法中调用, 缺点: 这个方法会调用多次(不知道我们要布局的控件是第几次调用布局, 所以只有让它每次都调用)
    // 2. 在 viewDidAppear 方法中调用, 缺点: 因为 view 已经显示完成, 这时再改变布局, 用户可能会看到一个闪现效果
    // 3. 在 viewDidLoad 方法中调用, 但是需要使用 多线程技术(GCD)
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setUpUI];
    });
}

- (void)setUpUI {
    
    // 添加毛玻璃
    [self setBlur];
    // 设置 musicProgress 的指示图标
    [_musicProgress setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    // 设置中间的 icon 圆角
    [self setIconImageVCornerRadius];
}

- (void)setBlur {
    
    UIToolbar *blur = [[UIToolbar alloc] initWithFrame:_albumImageV.bounds];
    blur.barStyle = UIBarStyleBlack;
    [_albumImageV addSubview:blur];
}

- (void)setIconImageVCornerRadius {
    
    _iconImageV.layer.cornerRadius = _iconImageV.frame.size.width * 0.5;
    _iconImageV.layer.masksToBounds = YES;
    _iconImageV.layer.borderWidth = 8;
    _iconImageV.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

@end
