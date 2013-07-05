//
//  WonderfulCommentsViewController.m
//  Chinaunicom
//
//  Created by  on 13-5-5.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "WonderfulCommentsViewController.h"
#import "ASIHTTPRequest.h"
#import "CustomWonderfulCommentsCell.h"
#import "SysConfig.h"
#import "HttpRequestHelper.h"
#import "ASIFormDataRequest.h"
#import "Report.h"
#import "User.h"
#import "requestServiceHelper.h"
#import "GTMBase64.h"
#import "UIImageView+WebCache.h"
#import "Utility.h"
@interface WonderfulCommentsViewController ()
@property (nonatomic) CGRect theTableViewOriFrame;
@property (nonatomic) CGRect inputViewOriFrame;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
@end

@implementation WonderfulCommentsViewController
@synthesize myTableView,dataArray,recoderAndPlayer;

@synthesize textView=_textView;
@synthesize inputView = _inputView;
@synthesize theTableViewOriFrame = _theTableViewOriFrame;
@synthesize inputViewOriFrame = _inputViewOriFrame;
@synthesize isText = _isText;
@synthesize talkbutton = _talkButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"精彩评论";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.recodAlert = [[UIImageView alloc] initWithFrame:CGRectMake(95, 50, 130, 130)];
    //添加播放图片
    [self.recodAlert setImage:[UIImage imageNamed:@"record"]];
    [self.view.window  addSubview:self.recodAlert];
    
    recoderAndPlayer = [[RecoderAndPlayer alloc] init];
    [recoderAndPlayer setViewDelegate:self];
    [self.navigationController.navigationBar setHidden:NO];
    //返回按钮
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 32, 32);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    dataArray = [[NSMutableArray alloc] init];
    self.recodAlert.hidden=YES;
    _isText = YES;
    _talkButton.hidden = YES;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 5;
    _textview.delegate=self;
    
}

-(void)isOver
{
    [myTableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [recoderAndPlayer stopPlaying];
    UIImageView *rightDiv=(UIImageView*)[self.navigationController.navigationBar viewWithTag:102];
    [rightDiv setHidden:YES];
    
    _inputViewOriFrame = _inputView.frame;
    //_theTableViewOriFrame = self.view.frame;
    _theTableViewOriFrame = _theTableView.frame;
    
}

-(void)downloadSoundFile:(NSMutableDictionary *)dir
{
    
//    NSString *pcipath=[ImageUrl stringByAppendingString:[dir objectForKey:@"file"] objectForKey:@"icon"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    NSURL *baseUrl = [NSURL URLWithString:[ImageUrl stringByAppendingString:[dir objectForKey:@"file"]]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:baseUrl];
//    BOOL isExsit = [Utility checkFileExsit:[dir objectForKey:@"file"] Dir:@"SpeechSoundDir"];
    NSArray *fArray = [[dir objectForKey:@"file"] componentsSeparatedByString:@"/"];
    NSString *fileName=[fArray lastObject];
//        UIButton *b = [dir objectForKey:@"btn"];
//    if (isExsit) {
//    
//              b.hidden=NO;
//    }
    [request setDownloadDestinationPath:[Utility getFilePath:fileName Dir:@"SpeechSoundDir"]];
    [request setCompletionBlock:^{
//            BOOL exit = [Utility checkFileExsit:fileName Dir:@"SpeechSoundDir"];
//            if (exit) {
//                //UIButton *btn = (UIButton*)[self.view viewWithTag:[k intValue]];
//                b.hidden=NO;
//            }
//            else{
//                b.hidden=YES;
//            }
//        [self showLoadingActivityViewWithString:@"正在播放..."];
        [recoderAndPlayer SpeechAMR2WAV:fileName];
        
    }];
    [request setFailedBlock:^{
        
        [request clearDelegatesAndCancel];
        
    }];
    [request startAsynchronous];

}


- (IBAction)startRecord:(id)sender {
        [recoderAndPlayer setViewDelegate:self];
        [recoderAndPlayer SpeechRecordStart];
//        [self showLoadingActivityViewWithString:@"正在录音..."];
//     [self.recodAlert bringSubviewToFront:self.view];
}

- (IBAction)endRecord:(id)sender {
    [recoderAndPlayer SpeechRecordStop];
//    [self sendComments];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(myThreadMainMethod) userInfo:nil repeats:NO];
}

-(void)myThreadMainMethod{
    [self sendComments];
}
-(void)playSoundFile:(id)sender{
    
    self.view.userInteractionEnabled=NO;
    int index=[sender tag]-1000;
    NSString *soundpath=[[dataArray objectAtIndex:index] objectForKey:@"audioPath"];
    NSArray *fArray = [soundpath componentsSeparatedByString:@"/"];
    NSString *fileName=[fArray lastObject];
    //检查目录下是否存在此文件
    BOOL isExsit = [Utility checkFileExsit:fileName Dir:@"SpeechSoundDir"];
    if (isExsit) {
//        [self showLoadingActivityViewWithString:@"正在播放..."];
        [recoderAndPlayer SpeechAMR2WAV:fileName];
    }
    else{
        //下载
        NSMutableDictionary *dir=[[NSMutableDictionary alloc]init];
        [dir setValue:soundpath forKey:@"file"];
        
//            NSString *soundpath=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"audioPath"];
        [NSThread detachNewThreadSelector:@selector(downloadSoundFile:) toTarget:self withObject:dir];
        self.view.userInteractionEnabled=YES;
    }

}



//录音时间
-(void)TimePromptAction:(int)sencond
{
   
}
-(void)playingFinishWithBBS:(BOOL)isFinish
{
    self.view.userInteractionEnabled=YES;
}

- (IBAction)send:(id)sender {
    if ([self.textView.text isEqualToString: @""])
    {
//        [self showAlertViewWithString:@"请输入评论！" setDelegate:nil setTag:0];
        return;
    }
    [self sendComments];
   }
-(void) sendComments
{
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.reportId forKey:@"reportId"];
    [dictionary setObject:userid forKey:@"userId"];
    [dictionary setObject:self.textView.text forKey:@"content"];
    [dictionary setObject:@"nofile" forKey:@"audioType"];
    [dictionary setObject:@"" forKey:@"audioStr"];
    if(isRecord)
    {
         [dictionary setObject:@"语音评论" forKey:@"content"];
         [dictionary setObject:@"amr" forKey:@"audioType"];
        NSString *filePath = [NSString stringWithFormat:@"%@",[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"SpeechSoundDir"] stringByAppendingPathComponent:@"alreadyEncoderData.amr"]];
        NSData *soundData = [NSData dataWithContentsOfFile:filePath];
        [dictionary setObject:[[NSString alloc] initWithData:[GTMBase64 encodeData:soundData] encoding:NSUTF8StringEncoding] forKey:@"audioStr"];
       
    }
//    [self showLoadingActivityViewWithString:@"正在发布..."];
    self.view.userInteractionEnabled = NO;
    [self.textView resignFirstResponder];
    [HttpRequestHelper asyncGetRequest:PublishComment parameter:dictionary requestComplete:^(NSString *responseStr) {
      
    } requestFailed:^(NSString *errorMsg) {
        //        <#code#>
        self.view.userInteractionEnabled=YES;
    }];

}
-(IBAction)switchTextAndSpeecn:(id)sender{
    UIButton *button = (UIButton *)sender;
    if (_isText) {
        [_textView resignFirstResponder];
        [button setImage:[UIImage imageNamed:@"recordedit.png"] forState:UIControlStateNormal];
        _talkButton.hidden = NO;
        _textView.hidden = YES;
        _isText = NO;
    }else {
        [button setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
        _talkButton.hidden = YES;
        _textView.hidden = NO;
        _isText = YES;
        
    }

}
-(void)recordAndSendAudioFile:(NSString *)fileName fileSize:(NSString *)fileSize duration:(NSString *)timelength{
    isRecord=YES;
}
@end
