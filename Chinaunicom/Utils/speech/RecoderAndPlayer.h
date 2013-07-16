//
//  RecoderAndPlayer.h
//  shareApp
//
//  Created by share02 on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

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
//	AVAudioSession *session;
	NSTimer *timer;
    NSString *playpath;
    BOOL isPlay;
    __weak id <ViewControllerDelegate> viewDelegate;
    NSString *recordAudioName;
}
//@property (strong,nonatomic) AVAudioSession *session;
//@property (strong,nonatomic) AVAudioRecorder *recorder;
@property (strong,nonatomic) AVAudioPlayer *player;
@property (strong,nonatomic) NSString *playpath;
@property (strong,nonatomic) NSString *recordAudioName;
@property (assign,nonatomic) BOOL isPlay;
@property int aSeconds;
@property (weak,nonatomic) id <ViewControllerDelegate> viewDelegate;
-(void)SpeechRecordStart;
-(void)SpeechRecordStop;
-(void)SpeechAMR2WAV:(NSString *)amrFile;
-(void) stopPlaying;
@end
