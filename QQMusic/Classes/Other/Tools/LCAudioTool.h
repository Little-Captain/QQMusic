//
//  LCAudioTool.h
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LCAudioTool : NSObject

+ (void)playSound:(NSString *)fileName;

+ (AVAudioPlayer *)playMusic:(NSString *)fileName;

+ (void)pauseMusic:(NSString *)fileName;

+ (void)stopMusic:(NSString *)fileName;

@end
