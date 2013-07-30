//
//  GoodCommentsViewController.m
//  Chinaunicom
//
//  Created by YY on 13-7-5.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "GoodCommentsViewController.h"
#import "CustomWonderfulCommentsCell.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "HttpRequestHelper.h"
#import "GTMBase64.h"
#import "ASIHTTPRequest.h"
#import "Utility.h"
@interface GoodCommentsViewController ()
{
   NSMutableArray *dataSource;
    BOOL keyboardIsVisible;
    MBHUDView *hub;
}
@end

@implementation GoodCommentsViewController
-(void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    dataSource=[[NSMutableArray alloc]init];
    [self initTopView];
    [self initTableView];
    [self initBottomView];
    
}
-(void)initTopView
{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [topView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title@2x.png"]]];
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"new_arraw.png"] forState:UIControlStateNormal];
    backButton.frame=CGRectMake(0, 0, 57, 44);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    UIImageView *lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(58, 0, 2, 44)];
    [lineImageView setImage:[UIImage imageNamed:@"new_line.png"]];
    [topView addSubview:lineImageView];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 128, 44)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"精彩评论"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.center=topView.center;
    [topView addSubview:titleLabel];
    [self.view addSubview:topView];
}
-(void)initTableView
{
    _tableview=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44-44) pullingDelegate:self];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_tableview setBackgroundView:nil];
    [_tableview setBackgroundColor:[UIColor clearColor]];
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableview setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_tableview];
}
-(void)initBottomView
{
    inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-44, 320, 44)];
    inputToolbar.textView.returnKeyType=UIReturnKeySend;
    inputToolbar.delegate=self;
    inputToolbar.textView.placeholder=@"输入评论";
    [self.view addSubview:inputToolbar];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (page == 0)
    {
        [_tableview launchRefreshing];
    }
}
-(void)getReportList
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.reportId forKey:@"reportId"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    [dictionary setObject:[NSNumber numberWithInteger:page] forKey:@"pageIndex"];
    [[requestServiceHelper defaultService] getCommentsWithParamter:dictionary sucess:^(NSMutableArray *commentDictionary,NSInteger num) {
        self.pinglunNum=[NSString stringWithFormat:@"%d",num];
        if (page==1) {
            [dataSource removeAllObjects];
        }
        [dataSource addObjectsFromArray:commentDictionary];
        if ([dataSource count]==num) {
            [_tableview tableViewDidFinishedLoading];
            _tableview.reachedTheEnd  = YES;
            [_tableview reloadData];
        }else
        {
            [_tableview tableViewDidFinishedLoading];
            _tableview.reachedTheEnd  = NO;
            [_tableview reloadData];
        }

    } falid:^(NSString *errorMsg) {
        [_tableview tableViewDidFinishedLoading];
        _tableview.reachedTheEnd  = YES;
    }];

}
//判断是刷新还是加载更多
- (void)loadData
{
    page++;
    if (refreshing)
    {
        page = 1;
        refreshing = NO;
        [self getReportList];
    }
    else
    {
        [self getReportList];
    }
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *comment=[[[dataSource objectAtIndex:indexPath.row]objectForKey:@"commentContent"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CGSize commentSize=[comment sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(250, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return 10+20+5+commentSize.height+10+20+13;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"GoodComment";
    CustomWonderfulCommentsCell *cell = (CustomWonderfulCommentsCell*)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil)
    {
        cell=[[CustomWonderfulCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(CustomWonderfulCommentsCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *icon=[[[dataSource objectAtIndex:indexPath.row]objectForKey:@"icon"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *iconPath=[icon stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [cell.realHead setImageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:iconPath]]];
    
    cell.nameLabel.text=[[[dataSource objectAtIndex:indexPath.row]objectForKey:@"nickName"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *comment=[[[dataSource objectAtIndex:indexPath.row]objectForKey:@"commentContent"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CGSize commentSize=[comment sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(250, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    cell.commentLabel.frame=CGRectMake(60, 35, 250, commentSize.height);
    cell.commentLabel.text=comment;
    
    NSString *time=[[[dataSource objectAtIndex:indexPath.row]objectForKey:@"commentDate"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    cell.timeLabel.frame=CGRectMake(60, cell.commentLabel.frame.size.height+cell.commentLabel.frame.origin.y+10, 200, 20);
    cell.timeLabel.text=time;
    
    NSString *audioString=[[[dataSource objectAtIndex:indexPath.row]objectForKey:@"audioPath"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.soundButton addTarget:self action:@selector(playSoundFile:) forControlEvents:UIControlEventTouchUpInside];
    cell.soundButton.tag=1000+indexPath.row;
    if (audioString!=nil && ![audioString isEqualToString:@""]) {
        cell.soundButton.hidden=NO;
    }else
    {
        cell.soundButton.hidden=YES;
    }
    cell.bgImageView.frame=CGRectMake(3, 3, 314, cell.timeLabel.frame.size.height+cell.timeLabel.frame.origin.y+10);
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    NSDate *date=[NSDate date];
    return date;
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}
#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_tableview tableViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_tableview tableViewDidEndDragging:scrollView];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    /* Move the toolbar to above the keyboard */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect frame = inputToolbar.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height - kbSize.height;
	inputToolbar.frame = frame;
	[UIView commitAnimations];
    keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    /* Move the toolbar back to bottom of the screen */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect frame = inputToolbar.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
	inputToolbar.frame = frame;
	[UIView commitAnimations];
    keyboardIsVisible = NO;
}
-(void)startSpeak
{
    hub=[[MBHUDView alloc]init];
    UIImage *image=[UIImage imageNamed:@"recording.png"];
    hub.size=image.size;
    hub.backgroundColor=[UIColor colorWithPatternImage:image];
    [hub addToDisplayQueue];
    [recoderAndPlayer SpeechRecordStart];
}
-(void)endSpeak
{
    [hub dismiss];
    [recoderAndPlayer SpeechRecordStop];
}

-(void)downloadSoundFile:(NSMutableDictionary *)dir
{
    NSURL *baseUrl = [NSURL URLWithString:[ImageUrl stringByAppendingString:[dir objectForKey:@"file"]]];
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:baseUrl];
    __weak ASIHTTPRequest *request = _request;
    NSArray *fArray = [[dir objectForKey:@"file"] componentsSeparatedByString:@"/"];
    NSString *fileName=[fArray lastObject];
    [request setDownloadDestinationPath:[Utility getFilePath:fileName Dir:@"SpeechSoundDir"]];
    [request setCompletionBlock:^{
        [recoderAndPlayer SpeechAMR2WAV:fileName];
    }];
    [request setFailedBlock:^{
        [request clearDelegatesAndCancel];
    }];
    [request startAsynchronous];
}

-(void)playSoundFile:(UIButton *)sender{
    if (recoderAndPlayer.isPlay) {
        [recoderAndPlayer stopPlaying];
    }
    int index=[sender tag]-1000;
    NSString *soundpath=[[dataSource objectAtIndex:index] objectForKey:@"audioPath"];
    NSArray *fArray = [soundpath componentsSeparatedByString:@"/"];
    NSString *fileName=[fArray lastObject];
    //检查目录下是否存在此文件
    BOOL isExsit = [Utility checkFileExsit:fileName Dir:@"SpeechSoundDir"];
    if (isExsit) {
        [recoderAndPlayer SpeechAMR2WAV:fileName];
    }
    else{
        //下载
        NSMutableDictionary *dir=[[NSMutableDictionary alloc]init];
        [dir setValue:soundpath forKey:@"file"];
        [NSThread detachNewThreadSelector:@selector(downloadSoundFile:) toTarget:self withObject:dir];
    }
    
}

//录音时间
-(void)TimePromptAction:(int)sencond
{
}
-(void)playingFinishWithBBS:(BOOL)isFinish
{

}
-(void)recordAndSendAudioFile:(NSString *)fileName fileSize:(NSString *)fileSize duration:(NSString *)timelength{
//    [self performSelectorInBackground:@selector(sendSoundComment) withObject:nil];
//    if ([timelength intValue]<1) {
//        [MBHUDView hudWithBody:@"录音时间太短" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
//    }else
//    {
        [self sendSoundComment];
//    }
    
}
-(void)sendSoundComment
{
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.reportId forKey:@"reportId"];
    [dictionary setObject:userid forKey:@"userId"];
    [dictionary setObject:inputToolbar.textView.text forKey:@"content"];
    [dictionary setObject:@"amr" forKey:@"audioType"];
    
    NSString *filePath = [NSString stringWithFormat:@"%@",[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"SpeechSoundDir"] stringByAppendingPathComponent:@"alreadyEncoderData.amr"]];
    NSData *soundData = [NSData dataWithContentsOfFile:filePath];
    [dictionary setObject:[[NSString alloc] initWithData:[GTMBase64 encodeData:soundData] encoding:NSUTF8StringEncoding] forKey:@"audioStr"];

    [HttpRequestHelper asyncGetRequest:PublishComment parameter:dictionary requestComplete:^(NSString *responseStr) {
        if ([responseStr isEqualToString:@"success"]) {
            [MBHUDView dismissCurrentHUD];
            [MBHUDView hudWithBody:@"发表成功" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
            [_tableview launchRefreshing];
        }else
        {
            [MBHUDView hudWithBody:@"发表失败" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
        }

    } requestFailed:^(NSString *errorMsg) {
        [MBHUDView dismissCurrentHUD];
        [MBHUDView hudWithBody:@"发表失败" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
    }];
}
-(void)reTable
{
    
//    refreshing = YES;
//    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}
-(void)sendTheComment
{
    [self textComment];
}
-(void)textComment
{
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.reportId forKey:@"reportId"];
    [dictionary setObject:userid forKey:@"userId"];
    [dictionary setObject:inputToolbar.textView.text forKey:@"content"];
    [dictionary setObject:@"" forKey:@"audioType"];
    [dictionary setObject:@"" forKey:@"audioStr"];
    [HttpRequestHelper asyncGetRequest:PublishComment parameter:dictionary requestComplete:^(NSString *responseStr) {
        if ([responseStr isEqualToString:@"success"]) {
            [MBHUDView hudWithBody:@"发表成功" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
            [self performSelectorOnMainThread:@selector(reTable) withObject:nil waitUntilDone:NO];
            [_tableview launchRefreshing];
        }else
        {
            [MBHUDView hudWithBody:@"发表失败" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
        }
     
    } requestFailed:^(NSString *errorMsg) {
        [MBHUDView hudWithBody:@"发表失败" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
    }];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    recoderAndPlayer = [[RecoderAndPlayer alloc] init];
    [recoderAndPlayer setViewDelegate:self];
	// Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.pinglunNum!=nil) {
        [self.pinglunBt setTitle:[NSString stringWithFormat:@"查看精彩评论 共%@条",self.pinglunNum] forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if (recoderAndPlayer.isPlay) {
        [recoderAndPlayer stopPlaying];
    }
}
-(void)back
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
