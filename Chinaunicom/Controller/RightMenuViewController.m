//
//  PersonalCenterViewController.m
//  Chinaunicom
//
//  Created by  on 13-5-7.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "RightMenuViewController.h"
#import "AuditReportListViewController.h"
#import "FavoriteListViewController.h"
#import "SettingController.h"
#import "requestServiceHelper.h"
#import "User.h"
#import "SysConfig.h"
#import "UIImageView+WebCache.h"

#import "ASIHTTPRequest.h"
#import "Utility.h"
@interface RightMenuViewController ()

@end

@implementation RightMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLayout];
    [self initDataSource];
}

- (void) viewWillAppear:(BOOL)animated
{

}
#pragma  mark - initLayout
-(void)initLayout
{
    //背景图片
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"right_background.png"]];
    UINavigationBar *nav=self.navigationController.navigationBar;
    
    //个人主页
    UIImage *userHomeImage=[UIImage imageNamed:@"user_home"];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, userHomeImage.size.width, userHomeImage.size.height)];
    [imageView setImage:userHomeImage];
    [nav addSubview:imageView];
    
    UIButton* personalButton= [UIButton buttonWithType:UIButtonTypeCustom];
    personalButton.frame = CGRectMake(25, 15, 100, 20);
    [personalButton setTitle:@"个人主页" forState:UIControlStateNormal];
    [personalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [personalButton setTag:1];
    [personalButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:personalButton];
    
    /*分割线*/
    UIImageView *imageViewTopDiv=[[UIImageView alloc] initWithFrame:CGRectMake(225, 5, 2,34 )];
    [imageViewTopDiv setImage:[UIImage imageNamed:@"new_line.png"]];
    [nav addSubview:imageViewTopDiv];
    
    //权限功能
    UIButton* accessButton= [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *accessImage=[UIImage imageNamed:@"user_edit.png"];
    accessButton.frame = CGRectMake(243, 15, accessImage.size.width,accessImage.size.height);
    [accessButton setBackgroundImage:accessImage  forState:UIControlStateNormal];
    [accessButton setTag:2];
    [accessButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:accessButton];

    //添加底部navbar
    //UINavigationBar *bottomBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];
    UIImage *bottomImage=[UIImage imageNamed:@"title@2x.png"];
    UINavigationBar *bottomBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 372, bottomImage.size.width, bottomImage.size.height)];
    [bottomBar setBackgroundImage:bottomImage forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:bottomBar];
    //为nabar添加对应的items
    /*消息*/
//    UIButton* messageButton= [UIButton buttonWithType:UIButtonTypeCustom];
//    messageButton.frame = CGRectMake(190, 12, 25, 20);
//    [messageButton setBackgroundImage:[UIImage imageNamed:@"grzy_Letter"]  forState:UIControlStateNormal];
//    [messageButton setTag:3];
//    [messageButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomBar addSubview:messageButton];
//    /*分割线1*/
//    UIImageView *imageViewBottomDiv1=[[UIImageView alloc] initWithFrame:CGRectMake(210, 0, 30, 44)];
//    [imageViewBottomDiv1 setImage:[UIImage imageNamed:@"dividingLine"]];
//    [bottomBar addSubview:imageViewBottomDiv1];
    
    /*收藏*/
    UIButton* favoriteButton= [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *favoriteImage=[UIImage imageNamed:@"Star.png"];
    
    favoriteButton.frame = CGRectMake(180, 15, favoriteImage.size.width, favoriteImage.size.height);
    [favoriteButton setBackgroundImage:favoriteImage  forState:UIControlStateNormal];
    [favoriteButton setTag:4];
    [favoriteButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:favoriteButton];
    /*分割线2*/
    
    UIImageView *imageViewBottomDiv2=[[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 2, 28)];
    [imageViewBottomDiv2 setImage:[UIImage imageNamed:@"new_line.png"]];
    [bottomBar addSubview:imageViewBottomDiv2];
    
    /*设置*/
    UIButton* settingButton= [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingImage=[UIImage imageNamed:@"Setting.png"];
    settingButton.frame = CGRectMake(240, 15, settingImage.size.width,settingImage.size.height);
    [settingButton setBackgroundImage:settingImage  forState:UIControlStateNormal];
    [settingButton setTag:5];
    [settingButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];

    [bottomBar addSubview:settingButton];
    
}

#pragma  mark - initDataSource
-(void)initDataSource
{
 
    _mytableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 5, 320, self.view.frame.size.height-88-5) style:UITableViewStylePlain];
    _mytableView.dataSource=self;
    _mytableView.delegate=self;
    [_mytableView setBackgroundColor:[UIColor clearColor]];
    [_mytableView setBackgroundView:nil];
    [_mytableView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_mytableView];
    
   
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    NSString *icon=[user.icon stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    iconurl=[NSURL URLWithString:[ImageUrl stringByAppendingString:icon]];
    
     NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: userid forKey:@"userId"];
    [dictionary setValue: @"1" forKey:@"pageIndex"];
    [dictionary setValue: @"100" forKey:@"pageSize"];
    [self showLoadingActivityViewWithString:@"正在加载..."];
    [[requestServiceHelper defaultService] getMyCommentsWithParamter:dictionary sucess:^(NSArray *commentDictionary) {
        
        if (commentDictionary !=nil) {
             self.dictionayData=[commentDictionary objectAtIndex:1];
            [_mytableView reloadData];
        }
        
        [self hideLoadingActivityView];
    } falid:^(NSString *errorMsg) {
      
         [self hideLoadingActivityView];
    }];
    
}

#pragma mark - Table view data source

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 
     return [self.dictionayData count];
 
 }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //计算评论内容高度
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    NSString *commentStr=[[self.dictionayData  objectAtIndex:indexPath.row]objectForKey:@"commentContent"];
    CGSize commentSize=[commentStr sizeWithFont:font constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
 
    //计算新闻高度
    NSString *newsStr=[[self.dictionayData objectAtIndex:indexPath.row]objectForKey:@"reportTitle"];
    CGSize newsSize=[newsStr sizeWithFont:font constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return   5+20+5+commentSize.height+5+20+5+5 +newsSize.height +5 +20 +5;
}

 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     static NSString *simpleTableIdentifier = @"CustomRightMenuViewCell";
 
     CustomRightMenuViewCell *cell = (CustomRightMenuViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];//复用cell
     if (cell == nil) {
         cell=[[CustomRightMenuViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
     }
     UIFont *font = [UIFont systemFontOfSize:17.0f];
     NSLog(@"self.dc=%@",self.dictionayData);
     NSString *nameStr=[[self.dictionayData objectAtIndex:indexPath.row]objectForKey:@"commentPerson"];
     CGSize nameSize=[nameStr sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
     cell.nameLabel.frame=CGRectMake(60, 5, nameSize.width, nameSize.height);
     cell.nameLabel.text=nameStr;
    
     UIImage *soundImage=[UIImage imageNamed:@"Sound.png"];
     cell.soundButton.frame=CGRectMake(60+nameSize.width+5, 5, soundImage.size.width, soundImage.size.height);
     [cell.soundButton setTag:100+indexPath.row ];
     [cell.soundButton addTarget:self action:@selector(playSoundFile:) forControlEvents:UIControlEventTouchUpInside];
     
     NSString *soundPath=[[self.dictionayData objectAtIndex:indexPath.row]objectForKey:@"audiopath"];
     if (![soundPath isEqualToString:@""]  && soundPath !=nil) {
         cell.soundButton.hidden=NO;
     }else
     {
         cell.soundButton.hidden=YES;
     }
     
     NSString *commentStr=[[self.dictionayData objectAtIndex:indexPath.row]objectForKey:@"commentContent"];
     cell.contentLabel.text=commentStr;
     CGSize commentSize=[commentStr sizeWithFont:font constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
     cell.contentLabel.frame=CGRectMake(60, cell.nameLabel.frame.origin.y+cell.nameLabel.frame.size.height+5, 200, commentSize.height);
     cell.timeLabel.text=[[self.dictionayData objectAtIndex:indexPath.row]objectForKey:@"commentDate"];
     cell.timeLabel.frame=CGRectMake(60, cell.contentLabel.frame.origin.y+cell.contentLabel.frame.size.height+5, 200, 20);
     cell.topBgImageView.frame=CGRectMake(26, 0, 247, cell.timeLabel.frame.origin.y+cell.timeLabel.frame.size.height);
     
     NSString *newsStr=[[self.dictionayData objectAtIndex:indexPath.row]objectForKey:@"reportTitle"];
     CGSize newsSize=[newsStr sizeWithFont:font constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
     cell.newsLabel.text=newsStr;
     cell.newsLabel.frame=CGRectMake(60, cell.topBgImageView.frame.size.height+5, 200, newsSize.height);
     
     NSString *str=[[self.dictionayData objectAtIndex:indexPath.row]objectForKey:@"reportType"];
     cell.pinglunLabel.text=[NSString stringWithFormat:@"来自 %@",str];
     cell.pinglunLabel.frame=CGRectMake(60, cell.newsLabel.frame.origin.y+cell.newsLabel.frame.size.height +5, 130, 20);
     
     UIImage *image=[UIImage imageNamed:@"com_mes.png"];
     cell.messageImageView.frame=CGRectMake(185, cell.newsLabel.frame.origin.y+cell.newsLabel.frame.size.height +5+5, image.size.width, image.size.height);
  
     NSString *num=[[self.dictionayData objectAtIndex:indexPath.row]objectForKey:@"commentNumber"];
     cell.numLabel.text=[NSString stringWithFormat:@"评论 %@",num];
     cell.numLabel.frame=CGRectMake(205, cell.pinglunLabel.frame.origin.y, 60, 20);
     
     cell.bottomBgImageView.frame=CGRectMake(24.5, cell.topBgImageView.frame.size.height, 250.5, 35+newsSize.height);

     [cell.headImageView setImageWithURL:iconurl];

     return cell;
 
 }

-(void)doDone:(id)sender
{
   
    UIButton *btn=(UIButton*)sender;
    //权限功能
    if ([btn tag]==2) {
        AuditReportListViewController *auditCtrl=[[AuditReportListViewController alloc] initWithNibName:@"AuditedReportListViewController" bundle:Nil];
        auditCtrl.title=@"已审核";
//        BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:auditCtrl];
//        AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [myDelegate.revealSideViewController pushViewController:nav onDirection:PPRevealSideOptionsBounceAnimations withOffset:0 animated:YES forceToPopPush:YES completion:nil];

    }
    //收藏
    if ([btn tag]==4) {
        FavoriteListViewController *favCtrl=[[FavoriteListViewController alloc] init];
        favCtrl.title=@"收藏";
//        BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:favCtrl];
//        AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [myDelegate.revealSideViewController pushViewController:nav onDirection:PPRevealSideOptionsBounceAnimations withOffset:0 animated:NO forceToPopPush:YES completion:nil];
//        [self.navigationController pushViewController:favCtrl animated:YES];
        
    }
    //设置
    else if([btn tag]==5){
        
//        [btn setBackgroundImage:[UIImage imageNamed:@"grzy_Setting"] forState:UIControlStateNormal];
        SettingController *setCtrl=[[SettingController alloc] init];
        setCtrl.title=@"设置";
//        BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:setCtrl];
//        AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [myDelegate.revealSideViewController pushViewController:nav onDirection:PPRevealSideOptionsBounceAnimations withOffset:0 animated:YES forceToPopPush:YES completion:nil];
    }
        
    
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
        [recoderAndPlayer SpeechAMR2WAV:fileName];
        
    }];
    [request setFailedBlock:^{
        
        [request clearDelegatesAndCancel];
        
    }];
    [request startAsynchronous];
    
}

-(void)playSoundFile:(UIButton*)sender{
    
    int index=[sender tag]-100;
    NSString *soundpath=[[self.dictionayData objectAtIndex:index] objectForKey:@"audiopath"];
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
-(void)playingFinishWithBBS:(BOOL)isFinish
{
    NSLog(@"播放成功");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
