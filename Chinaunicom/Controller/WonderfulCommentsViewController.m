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
@synthesize myTableView,dataArray,recoderAndPlayer,myReport;

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
    [self fetchData];
    _isText = YES;
    _talkButton.hidden = YES;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 5;
    _textview.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
}

-(void)fetchData
{
    [self showLoadingActivityViewWithString:@"加载数据"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    //115
    [dictionary setObject:self.myReport.reportId forKey:@"reportId"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    [dictionary setObject:@"1" forKey:@"pageIndex"];
    self.view.userInteractionEnabled=NO;
    [[requestServiceHelper defaultService] getCommentsWithParamter:dictionary sucess:^(NSMutableArray *commentDictionary) {
        self.dataArray=commentDictionary;
        [self performSelectorOnMainThread:@selector(isOver) withObject:nil waitUntilDone:NO];
        self.view.userInteractionEnabled=YES;
        [self hideLoadingActivityView];
    } falid:^(NSString *errorMsg) {
        self.view.userInteractionEnabled=YES;
        [self hideLoadingActivityView];
    }];
}

-(void)isOver
{
    
    [myTableView reloadData];
    [self hideLoadingActivityView];
    
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

#pragma mark - Rotation control
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardCoViewWillRotateNotification object:nil];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardCoViewDidRotateNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}


#pragma mark - IBActions
- (IBAction)backgroundTouchDown:(id)sender {
    //[self.texField resignFirstResponder];

}



#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"da ------------ %@",dataArray);
    return [self.dataArray count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;//此处返回cell的高度
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CustomWonderfulCommentsCell";
    
    CustomWonderfulCommentsCell *cell = (CustomWonderfulCommentsCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];//复用cell
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomWonderfulCommentsCell" owner:self options:nil];//加载自定义cell的xib文件
        cell = [array objectAtIndex:0];
    }
    cell.userNameLabel.text=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"nickName"];
    cell.contextLabel.text=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"commentContent"];
    NSString *pcipath=[ImageUrl stringByAppendingString:[[[dataArray objectAtIndex:indexPath.row] objectForKey:@"icon"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    NSString *soundpath=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"audioPath"];
    if(soundpath!=NULL&&![soundpath isEqualToString:@""])
    {
        cell.play.hidden=YES;
        [cell.play setTag:1000+indexPath.row];
        [cell.play addTarget:self action:@selector(playSoundFile:) forControlEvents:UIControlEventTouchUpInside];
              //下载
        NSMutableDictionary *dir=[[NSMutableDictionary alloc]init];
        [dir setValue:cell.play forKey:@"btn"];
        [dir setValue:soundpath forKey:@"file"];
       [NSThread detachNewThreadSelector:@selector(downloadSoundFile:) toTarget:self withObject:dir];
    }
    else{
        cell.play.hidden=YES;
    }
    NSURL *tturl=[NSURL URLWithString:pcipath];
    [cell.headPic setImageWithURL:tturl] ;
    cell.dateTimeLabel.text=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"commentDate"];
    //[cell.image addTarget:self action:@selector(zan) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
-(void)downloadSoundFile:(NSMutableDictionary *)dir
{
    
    NSURL *baseUrl = [NSURL URLWithString:[ImageUrl stringByAppendingString:[dir objectForKey:@"file"]]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:baseUrl];
    BOOL isExsit = [Utility checkFileExsit:[dir objectForKey:@"file"] Dir:@"SpeechSoundDir"];
       NSArray *fArray = [[dir objectForKey:@"file"] componentsSeparatedByString:@"/"];
    NSString *fileName=[fArray lastObject];
        UIButton *b = [dir objectForKey:@"btn"];
    if (isExsit) {
    
              b.hidden=NO;
    }
    [request setDownloadDestinationPath:[Utility getFilePath:fileName Dir:@"SpeechSoundDir"]];
    [request setCompletionBlock:^{
            BOOL exit = [Utility checkFileExsit:fileName Dir:@"SpeechSoundDir"];
            if (exit) {
                //UIButton *btn = (UIButton*)[self.view viewWithTag:[k intValue]];
                b.hidden=NO;
            }
            else{
                b.hidden=YES;
            }
        
    }];
    [request setFailedBlock:^{
        
        [request clearDelegatesAndCancel];
        
    }];
    [request startAsynchronous];

}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (nil == self.view.superview)
        return;
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue: &animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: animationDuration];
    
    if ([_textView isFirstResponder])
    {
        _theTableView.frame = CGRectMake(_theTableViewOriFrame.origin.x, _theTableViewOriFrame.origin.y, _theTableViewOriFrame.size.width, _theTableViewOriFrame.size.height - keyboardHeight);
        
        _inputView.frame = CGRectMake(_inputViewOriFrame.origin.x, _inputViewOriFrame.origin.y-keyboardHeight, _inputViewOriFrame.size.width,_inputViewOriFrame.size.height);
    }

    
    [UIView commitAnimations];

}
- (void)keyboardWillHide:(NSNotification *)notification
{
    if (nil == self.view.superview)
        return;
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    if ([_textView isFirstResponder])
    {
        _theTableView.frame = _theTableViewOriFrame;
        _inputView.frame = _inputViewOriFrame;
    }
    
    [UIView commitAnimations];
    
    
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    [self setInputView:nil];
    [self setTalkbutton:nil];
    [self setTheTableView:nil];
    [self setTextView:nil];
    [self setTalkbutton:nil];
    [super viewDidUnload];
}
- (IBAction)startRecord:(id)sender {
        [recoderAndPlayer setViewDelegate:self];
        [recoderAndPlayer SpeechRecordStart];
        [self showLoadingActivityViewWithString:@"正在录音..."];
//     [self.recodAlert bringSubviewToFront:self.view];
}

- (IBAction)endRecord:(id)sender {
    [recoderAndPlayer SpeechRecordStop];
    [self hideLoadingActivityView];
    self.recodAlert.hidden=YES;
//    [self sendComments];
       NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(myThreadMainMethod) userInfo:nil repeats:NO];
}

-(void)myThreadMainMethod{
    [self sendComments];
}
-(IBAction)playSoundFile:(id)sender{
    [self showLoadingActivityViewWithString:@"正在播放..."];
    self.view.userInteractionEnabled=NO;
    int index=[sender tag]-1000;
    NSString *soundpath=[[dataArray objectAtIndex:index] objectForKey:@"audioPath"];
    NSArray *fArray = [soundpath componentsSeparatedByString:@"/"];
    NSString *fileName=[fArray lastObject];
    //检查目录下是否存在此文件
    BOOL isExsit = [Utility checkFileExsit:fileName Dir:@"SpeechSoundDir"];
    if (isExsit) {
        [recoderAndPlayer SpeechAMR2WAV:fileName];
    }
    else{
        [self hideLoadingActivityView];
        self.view.userInteractionEnabled=YES;
    }

}



//录音时间
-(void)TimePromptAction:(int)sencond
{
   
}
-(void)playingFinishWithBBS:(BOOL)isFinish
{
    [self hideLoadingActivityView];
    self.view.userInteractionEnabled=YES;
}

- (IBAction)send:(id)sender {
    if ([self.textView.text isEqualToString: @""])
    {
        [self showAlertViewWithString:@"请输入评论！" setDelegate:nil setTag:0];
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
    [dictionary setObject:self.myReport.reportId forKey:@"reportId"];
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
    [self showLoadingActivityViewWithString:@"正在发布..."];
    self.view.userInteractionEnabled = NO;
    [self.textView resignFirstResponder];
    [HttpRequestHelper asyncGetRequest:PublishComment parameter:dictionary requestComplete:^(NSString *responseStr) {
        [self hideLoadingActivityView];
        [self fetchData];
    } requestFailed:^(NSString *errorMsg) {
        //        <#code#>
        self.view.userInteractionEnabled=YES;
        [self hideLoadingActivityView];
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
