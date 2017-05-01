//
//  LCAudioTool.m
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCAudioTool.h"

@implementation LCAudioTool

static NSMutableDictionary *_soundIDs;
+ (NSMutableDictionary *)soundIDs {
    
    if (_soundIDs) { return _soundIDs; }
    
    _soundIDs = [NSMutableDictionary dictionary];
    
    return _soundIDs;
}

+ (void)playSound:(NSString *)fileName {
    
    // 通过 音效文件名 为 key 到字典中获取对应 soundIDObj
    id soundIDObj = [[self soundIDs] objectForKey:fileName];
    // 获取 soundID
    SystemSoundID soundID = [soundIDObj unsignedIntValue];
    if (!soundIDObj) { // 没有值则创建, 之后保存到字典中
        // 音效文件的 url
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        // 生成 sound ID
        // 参数1: 音效文件的 url
        // 参数2: 通过 url 创建的 sound ID
        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(url), &soundID);
        // 保存到字典中
        [self soundIDs][fileName] = @(soundID);
    }
    // 播放音效
    // 播放的时候伴随着手机震动效果
//    AudioServicesPlayAlertSound(soundID);
    // 没有震动效果
    AudioServicesPlaySystemSound(soundID);
}

static NSMutableDictionary *_players;
+ (NSMutableDictionary *)players {
    
    if (_players) { return _players; }
    
    _players = [NSMutableDictionary dictionary];
    
    return _players;
}

+ (AVAudioPlayer *)playMusic:(NSString *)fileName {
    
    // 从字典中通过音乐文件名作为 key 取出对应的播放器
    AVAudioPlayer *player = [[self players] objectForKey:fileName];
    if (!player) {
        // 创建音乐的URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        // 创建播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        // 准备播放
        [player prepareToPlay];
        // 将播放器保存到字典中
        [self players][fileName] = player;
    }
    
    // 播放音乐
    [player play];
    
    return player;
}

+ (void)pauseMusic:(NSString *)fileName {
    
    // 从字典中通过音乐文件名作为 key 取出对应的播放器
    AVAudioPlayer *player = [[self players] objectForKey:fileName];
    if (!player) { return; }
    
    // 暂停播放音乐
    [player pause];
}

+ (void)stopMusic:(NSString *)fileName {
    
    // 从字典中通过音乐文件名作为 key 取出对应的播放器
    AVAudioPlayer *player = [[self players] objectForKey:fileName];
    if (!player) { return; }
    
    // 停止播放音乐
    [player stop];
    player = nil;
    
    // 从字典中移除
    [[self players] removeObjectForKey:fileName];
}

@end
