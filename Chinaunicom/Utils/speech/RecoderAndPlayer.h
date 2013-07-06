//
//  RecoderAndPlayer.h
//  shareApp
//
//  Created by share02 on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

#define SpeechMaxTime 60

@protocol ViewControllerDelegate <NSObject>

//录制的音频文件名，大小，时长
-(void)recordAndSendAudioFile:(NSString *)fileName fileSize:(NSString *)fileSize duration:(NSString *)timelength;
//计时提醒
-(void)TimePromptAction:(int)sencond;

//播放完成回调
-(void)playingFinishWithBBS:(BOOL)isFinish;

@end

@interface RecoderAndPlayer : NSObject <AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
	AVAudioSession *session;
	NSTimer *timer;
    NSString *playpath;
    BOOL isPlay;
    id <ViewControllerDelegate> viewDelegate;
    NSString *recordAudioName;
}
@property (retain,nonatomic) AVAudioSession *session;
@property (retain,nonatomic) AVAudioRecorder *recorder;
@property (retain,nonatomic) AVAudioPlayer *player;
@property (retain,nonatomic) NSString *playpath;
@property (retain,nonatomic) NSString *recordAudioName;
@property (assign,nonatomic) BOOL isPlay;
@property int aSeconds;
@property (assign,nonatomic) id <ViewControllerDelegate> viewDelegate;
-(void)SpeechRecordStart;
-(void)SpeechRecordStop;
-(void)SpeechAMR2WAV:(NSString *)amrFile;
-(void) stopPlaying;
@end
