//
//  RecoderAndPlayer.m
//  shareApp
//
//  Created by share02 on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecoderAndPlayer.h"
#include <stdio.h>
#include <stdlib.h>
#import "amrFileCodec.h"
#import "HttpRequestHelper.h"
#define DOCUMENTS_FOLDER [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"SpeechSoundDir"]
#define FILEPATH [DOCUMENTS_FOLDER stringByAppendingPathComponent:[self fileNameString]]

#define documentsDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"SpeechSoundDir"]
@implementation RecoderAndPlayer

@synthesize recorder,session;
@synthesize playpath,player;
@synthesize recordAudioName;
@synthesize viewDelegate;
@synthesize aSeconds;
@synthesize isPlay;

//录音完成回调方法
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (self.aSeconds>0) {
        // NSLog(@"%d",self.aSeconds);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:DOCUMENTS_FOLDER]) {
            [fileManager createDirectoryAtPath:DOCUMENTS_FOLDER
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
        }
        NSData *adata = [NSData dataWithContentsOfFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:recordAudioName]];
        //pct to amr
        [self encodePcm:adata];
        //NSLog(@"amrData len :%d \n",[adata length]);
        //已经生成amr的文件
        NSString *fileName = [NSString stringWithFormat:@"%@",[DOCUMENTS_FOLDER stringByAppendingPathComponent:@"alreadyEncoderData.amr"]];
        
        //获取文件大小 并且移除临时生成的wav文件
        NSString *fileSize = [NSString stringWithFormat:@"%d",[[self fetchRecordAudioFileSize:fileName]intValue]/1000];
        [viewDelegate recordAndSendAudioFile:fileName fileSize:fileSize duration:[NSString stringWithFormat:@"%d",self.aSeconds>60?60:self.aSeconds]];
    }
    
}
//格式化录制文件名称 距离1970的毫秒数 10位整数
- (NSString *) fileNameString
{
    double seconds = [[NSDate date] timeIntervalSince1970];
    NSString *mircoSeconds = [[[NSString stringWithFormat:@"%f",seconds] componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@.%@",mircoSeconds,@"wav"];
    recordAudioName = fileName;
    return fileName;
}
//停止录音
- (void) stopRecording
{
//    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
//    NSString *url=@"http://rock.sinaapp.com/app/wificar/version.json";
//    [HttpRequestHelper asyncGetRequest:url parameter:dictionary requestComplete:^(NSString *responseStr) {
//        
//        NSData *data = [responseStr dataUsingEncoding: NSUTF8StringEncoding];
//        //NSMutableDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        
//        NSMutableDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
//        bool temp=[result objectForKey:@"isupdate"];
//        NSLog(@"%@",result);
//        if(!temp)
//        {
//          
//        }
//        else{
//            UIAlertView *coll=[[UIAlertView alloc] initWithTitle:@""
//                                                    message:@"软件有新版本"
//                                                    delegate:self
//                                                    cancelButtonTitle:@"更新" otherButtonTitles:nil];
//                                     [coll show];
//        }
//    } requestFailed:^(NSString *errorMsg) {
//        
//    }];
	[self.recorder stop];
}



-(void) stopPlaying{
    if (player) {
        [player stop];
    }
}
//录音
-(BOOL)record
{

	NSError *error;
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
	[settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
	[settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    NSURL *urlPath = [NSURL fileURLWithPath:FILEPATH];
	self.recorder = [[[AVAudioRecorder alloc] initWithURL:urlPath settings:settings error:&error] autorelease];
	if (!self.recorder)
	{
		return NO;
	}
	self.recorder.delegate = self;
	if (![self.recorder prepareToRecord])
	{
		return NO;
	}
	if (![self.recorder record])
	{
		return NO;
	}
    [self LoudSpeakerRecorder:YES];
	return YES;
}

//获取文件大小 并且移除临时生成的wav文件
-(NSString*)fetchRecordAudioFileSize:(NSString*)fileName{
    NSNumber *fileSize = [NSNumber numberWithInt:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSDictionary *fileAttibutes = [fileManager fileAttributesAtPath:fileName traverseLink:YES];
    NSError *error = nil;
    NSDictionary *fileAttibutes = [fileManager attributesOfItemAtPath:fileName error:&error];
    if (fileAttibutes != nil) {
        
        if ([fileAttibutes objectForKey:NSFileSize]) {
            fileSize = [fileAttibutes objectForKey:NSFileSize];
        }
    }
    //移除生成的临时文件  recordAudioName
    NSString *tempFile = [documentsDirectory stringByAppendingPathComponent:recordAudioName];
    [fileManager removeItemAtPath:tempFile error:nil];
    return [[[NSString alloc] initWithFormat:@"%@",fileSize] autorelease];
}

//录音计时
-(void)countTime{
    if (self.aSeconds>=60) {
        self.aSeconds = 100;
        //[self stopRecording];
        [self SpeechRecordStop];
    }else {
        aSeconds++;
//        [viewDelegate TimePromptAction:self.aSeconds];
    }
    NSLog(@"录音记时%d",aSeconds);
}

- (BOOL) startAudioSession
{
	NSError *error;
	self.session = [AVAudioSession sharedInstance];
	if (![self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
	{
		return NO;
	}
	if (![self.session setActive:YES error:&error])
	{
		return NO;
	}
	return self.session.inputIsAvailable;
}

- (void) play
{
    isPlay=YES;
	if (self.player) [self.player play];
    
}

- (BOOL) prepAudio
{
	NSError *error;
	if (![[NSFileManager defaultManager] fileExistsAtPath:self.playpath]) return NO;
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.playpath] error:&error];
	if (!self.player)
	{
		return NO;
	}
	
	[self.player prepareToPlay];
	self.player.meteringEnabled = YES;
	self.player.delegate = self;
    [self performSelectorOnMainThread:@selector(play) withObject:nil waitUntilDone:NO];
	return YES;
}

//播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    isPlay = NO;
    //播放完成回调
    [viewDelegate playingFinishWithBBS:YES];
}

-(NSData *)decodeAmr:(NSData *)data{
    if (!data) {
        return data;
    }
    return DecodeAMRToWAVE(data);
}

-(NSData*)encodePcm:(NSData*)data{
    if (!data) {
        return data;
    }
    return EncodeWAVEToAMR(data, 1, 16);
}

-(void)SpeechRecordStart{
    //录制
    isPlay = NO;
    if ([self startAudioSession]) {
        self.aSeconds=0;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countTime) userInfo:nil repeats:YES];
        [self record];
    }
}
//松开录音按钮触发事件
-(void)SpeechRecordStop{
    [self stopRecording];
    [timer invalidate];
    [viewDelegate TimePromptAction:self.aSeconds];
}

-(void)SpeechAMR2WAV:(NSString *)amrFile{
    NSData *amrData = [NSData dataWithContentsOfFile:[DOCUMENTS_FOLDER stringByAppendingPathComponent:amrFile]];
    NSData *wavData = [self decodeAmr:amrData];
    if (!wavData) {
        NSLog(@"wavdata is empty");
        return;
    }
    [self LoudSpeakerPlay:YES];
    player= [[AVAudioPlayer alloc] initWithData:wavData error:nil];
    [player stop];
    player.delegate =self;
    [player prepareToPlay];
    [player setVolume:1.0];
    [self performSelectorOnMainThread:@selector(play) withObject:nil waitUntilDone:NO];
}

//打开扬声器--录音
-(bool) LoudSpeakerRecorder:(bool)bOpen
{
	//播放的时候设置play ，录音时候设置recorder
	
    //return false;
    UInt32 route;
    // OSStatus error;
    UInt32 sessionCategory =  kAudioSessionCategory_PlayAndRecord;////kAudioSessionCategory_PlayAndRecord;    // 1
    
    AudioSessionSetProperty (
                             kAudioSessionProperty_AudioCategory,                        // 2
                             sizeof (sessionCategory),                                   // 3
                             &sessionCategory                                            // 4
                             );
    
    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    return true;
}

//打开扬声器--播放
-(bool) LoudSpeakerPlay:(bool)bOpen
{
	//播放的时候设置play ，录音时候设置recorder
	
	//return false;
    UInt32 route;
    //OSStatus error;
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;// kAudioSessionCategory_PlayAndRecord;//kAudioSessionCategory_RecordAudio;//kAudioSessionCategory_PlayAndRecord;    // 1
    
    AudioSessionSetProperty (
                             kAudioSessionProperty_AudioCategory,                        // 2
                             sizeof (sessionCategory),                                   // 3
                             &sessionCategory                                            // 4
                             );
    
    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    return true;
}
-(void)dealloc{
    if ([session retainCount]>0) {
        [session release];
    }
    if ([recorder retainCount]>0) {
        [recorder stop];
        [recorder release];
    }
    if ([player retainCount]>0) {
        [player stop];
        [player release];
    }
    [playpath release];
    if ([recordAudioName retainCount]>0) {
        [recordAudioName release];
    }
    [super dealloc];
}

@end
