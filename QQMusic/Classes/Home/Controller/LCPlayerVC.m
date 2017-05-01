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
#import "LCLrcLabel.h"
#import "LCLrcView.h"
#import "LCMusicTool.h"
#import "LCAudioTool.h"
#import "LCMusicItem.h"
#import "NSString+LCExtension.h"
#import "CALayer+PauseAimate.h"

@interface LCPlayerVC () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *albumImageV;
@property (weak, nonatomic) IBOutlet UISlider *musicProgress;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *songL;
@property (weak, nonatomic) IBOutlet UILabel *singerL;
@property (weak, nonatomic) IBOutlet UILabel *totalL;
@property (weak, nonatomic) IBOutlet UILabel *currentL;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet LCLrcLabel *lrcLabel;
@property (weak, nonatomic) IBOutlet LCLrcView *lrcView;

@end

@implementation LCPlayerVC {
    
    AVAudioPlayer *_currentPlayer;
    NSTimer *_progressTimer;
    CADisplayLink *_lrcTimer;
}

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
    
    // 设置歌词的View的额外滚动区域
    _lrcView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    
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

- (void)startPlayingMusic {
    
    // 更新滑块的位置
    _musicProgress.value = 0;
    
    // 获取当前正在播放的音乐
    LCMusicItem *musicItem = [LCMusicTool playingMusic];
    
    // 更新界面信息
    _albumImageV.image = [UIImage imageNamed:musicItem.singerIcon];
    _iconImageV.image = [UIImage imageNamed:musicItem.icon];
    _songL.text = musicItem.name;
    _singerL.text = musicItem.singer;
    
    // 播放音乐
    AVAudioPlayer *player = [LCAudioTool playMusic:musicItem.filename];
    _currentPlayer = player;
    
    // 设置歌词 label
    _lrcView.lrcLabel = _lrcLabel;
    // 设置当前歌曲的歌词
    _lrcView.lrcName = musicItem.lrcname;
    
    // 更新当前的播放时间以及播放的总时间
    _currentL.text = [NSString musicTimeFormater:player.currentTime];
    _totalL.text = [NSString musicTimeFormater:player.duration];
    
    // 更新按钮状态
    _playOrPauseBtn.selected = player.isPlaying;
    
    // 开始旋转图片
    [self startAnimation];
    
    // 使用滑动条的定时器(先移除之前的定时器)
    [self removeProgressTimer];
    [self addProgressTimer];
    
    // 歌词的定时器(先移除之前的定时器)
    [self removeLrcTimer];
    [self addLrcTimer];
}

- (void)startAnimation {
    
    CABasicAnimation *basicA = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicA.fromValue = @(0);
    basicA.toValue = @(2 * M_PI);
    basicA.duration = 30;
    basicA.repeatCount = MAXFLOAT;
    basicA.removedOnCompletion = NO;
    [_iconImageV.layer addAnimation:basicA forKey:nil];
}

#pragma mark -
#pragma mark 定时器相关
- (void)addProgressTimer {
    
    _progressTimer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (!_currentPlayer) { return; }
        // 更新播放时间
        NSTimeInterval currentTime = _currentPlayer.currentTime;
        _currentL.text = [NSString musicTimeFormater:currentTime];
        
        // 更新滑块的位置
        NSTimeInterval totalTime = _currentPlayer.duration;
        _musicProgress.value = (float)(currentTime / totalTime);
    }];
    [[NSRunLoop currentRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
    // 马上启动定时器
    [_progressTimer fire];
}

- (void)removeProgressTimer {
    
    [_progressTimer invalidate];
    _progressTimer = nil;
}

#pragma mark -
#pragma mark 歌词的定时器

- (void)addLrcTimer {
    
    _lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(lrcUpdateInfo)];
    [_lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer {
    
    [_lrcTimer invalidate];
    _lrcTimer = nil;
}

- (void)lrcUpdateInfo {
    
    // 将播放器的播放时间时时传给lrcView
    _lrcView.currentTime = _currentPlayer.currentTime;
}

#pragma mark -
#pragma mark 监听播放事件
- (IBAction)playOrPause {
    
    if (!_currentPlayer) {
        [self startPlayingMusic];
        return;
    }
    
    if (_currentPlayer.isPlaying) { // 正在播放, 就暂停
        
        // 设置播放器按钮
        _playOrPauseBtn.selected = NO;
        // 暂停播放
        [_currentPlayer pause];
        // 移除定时器
        [self removeProgressTimer];
        // 暂停动画
        [_iconImageV.layer pauseAnimate];
    } else { // 暂停播放, 就播放
        
        // 设置播放器按钮
        _playOrPauseBtn.selected = YES;
        // 开始播放
        [_currentPlayer play];
        // 添加定时器
        [self addProgressTimer];
        // 恢复动画
        [_iconImageV.layer resumeAnimate];
    }
}

- (IBAction)preVious {
    
    // 获取上一首音乐
    LCMusicItem *item = [LCMusicTool previousMusic];
    
    // 播放音乐
    [self playMusic:item];
}

- (IBAction)next {
    
    // 获取下一首音乐
    LCMusicItem *item = [LCMusicTool nextMusic];
    
    // 播放音乐
    [self playMusic:item];
}

- (void)playMusic:(LCMusicItem *)musicItem {
    
    // 停止正在播放的音乐
    LCMusicItem *item = [LCMusicTool playingMusic];
    [LCAudioTool stopMusic:item.filename];
    
    // 设置当前正在播放的音乐
    [LCMusicTool setPlayingMusic:musicItem];
    
    // 播放音乐
    [self startPlayingMusic];
}

#pragma mark -
#pragma mark 处理滑块事件

// 滑块被点击
- (IBAction)touchDown {
    
    // 移除定时器
    [self removeProgressTimer];
}

// 值改变事件
- (IBAction)valueChange {
    
    if (!_currentPlayer) {
        [self startPlayingMusic];
    }
    
    // 更新当前播放显示时间
    // 当前进度
    float progress = _musicProgress.value;
    // 总时间
    NSTimeInterval totalTime = _currentPlayer.duration;
    // 当前时间
    NSTimeInterval currentTime = progress * totalTime;
    _currentL.text = [NSString musicTimeFormater:currentTime];
}

// 手指弹开事件
- (IBAction)touchUpInside {
    
    if (!_currentPlayer) {
        [self startPlayingMusic];
    }
    
    // 更新播放器的播放时间
    // 当前进度
    float progress = _musicProgress.value;
    // 总时间
    NSTimeInterval totalTime = _currentPlayer.duration;
    // 当前时间
    NSTimeInterval currentTime = progress * totalTime;
    _currentPlayer.currentTime = currentTime;
    
    // 添加定时器
    [self addProgressTimer];
}

- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    
    // 获取点击比例
    CGPoint point = [sender locationInView:sender.view];
    float ratio = 1.0 * point.x / _musicProgress.bounds.size.width;
    
    // 设置播放器的播放时间
    if (!_currentPlayer) {
        [self startPlayingMusic];
    }
    // 总时间
    NSTimeInterval totalTime = _currentPlayer.duration;
    // 当前时间
    NSTimeInterval currentTime = ratio * totalTime;
    _currentPlayer.currentTime = currentTime;
    
    // 更新滑块的位置以及播放显示时间
    _musicProgress.value = ratio;
    _currentL.text = [NSString musicTimeFormater:currentTime];
    
    // 判断如果定时器没有值,则添加定时器
    if (!_progressTimer) {
        [self addProgressTimer];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 获取水平方向的偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 计算偏移量的比例
    CGFloat ratio = 1 - offsetX / scrollView.bounds.size.width;
    // 设置图片的透明度以及当前歌词 label 的透明度
    _iconImageV.alpha = ratio;
    _lrcLabel.alpha = ratio;
}

@end
