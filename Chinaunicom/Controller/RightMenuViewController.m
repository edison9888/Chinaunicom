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
#import "AppDelegate.h"
#import "requestServiceHelper.h"
#import "User.h"
#import "SysConfig.h"
#import "UIImageView+WebCache.h"

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
    //隐藏导航栏
    //[self.navigationController.navigationBar setHidden:YES];
}
#pragma  mark - initLayout
-(void)initLayout
{
    
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
     NSString *icon=[user.icon stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    iconurl=[NSURL URLWithString:[ImageUrl stringByAppendingString:icon]];
    

    //背景图片
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    //创建navbar
    //UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //[nav setBackgroundImage:[UIImage imageNamed:@"title"] forBarMetrics:UIBarMetricsDefault];
    UINavigationBar *nav=self.navigationController.navigationBar;
    
    //个人主页
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(70, 10, 25, 22)];
    [imageView setImage:[UIImage imageNamed:@"user_home"]];
    [nav addSubview:imageView];
    
    UIButton* personalButton= [UIButton buttonWithType:UIButtonTypeCustom];
    personalButton.frame = CGRectMake(85, 7, 100, 30);
    [personalButton setTitle:@"个人主页" forState:UIControlStateNormal];
    [personalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [personalButton setTag:1];
    [personalButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:personalButton];
    
    /*分割线*/
    UIImageView *imageViewTopDiv=[[UIImageView alloc] initWithFrame:CGRectMake(245, 0, 30, 44)];
    [imageViewTopDiv setImage:[UIImage imageNamed:@"topDividingLine"]];
    [nav addSubview:imageViewTopDiv];
    
    //权限功能
    UIButton* accessButton= [UIButton buttonWithType:UIButtonTypeCustom];
    accessButton.frame = CGRectMake(280, 15, 23,17);
    [accessButton setBackgroundImage:[UIImage imageNamed:@"user_edit@2x"]  forState:UIControlStateNormal];  
    [accessButton setTag:2];
    [accessButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:accessButton];

    //[self.view addSubview:nav];
    //添加底部navbar
    //UINavigationBar *bottomBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];
    UINavigationBar *bottomBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 372, 320, 44)];
    [bottomBar setBackgroundImage:[UIImage imageNamed:@"bottomNav"] forBarMetrics:UIBarMetricsDefault];
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
    favoriteButton.frame = CGRectMake(235, 8, 25, 25);
    [favoriteButton setBackgroundImage:[UIImage imageNamed:@"grzy_Star"]  forState:UIControlStateNormal];
    [favoriteButton setTag:4];
    [favoriteButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:favoriteButton];
    /*分割线2*/
    UIImageView *imageViewBottomDiv2=[[UIImageView alloc] initWithFrame:CGRectMake(255, 0, 30, 44)];
    [imageViewBottomDiv2 setImage:[UIImage imageNamed:@"dividingLine"]];
    [bottomBar addSubview:imageViewBottomDiv2];
    
    /*设置*/
    UIButton* settingButton= [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(280, 9, 25,25);
    [settingButton setBackgroundImage:[UIImage imageNamed:@"grzy_Setting"]  forState:UIControlStateNormal];
    [settingButton setTag:5];
    [settingButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
//    [settingButton addTarget:self action:@selector(buttonUp:) forControlEvents:uicontroleventtouchup]
    [bottomBar addSubview:settingButton];
    
}

#pragma  mark - initDataSource
-(void)initDataSource
{
 
_mytableView=[[UITableView alloc] initWithFrame:CGRectMake(60, 11, 250, 350) style:UITableViewStylePlain];
    _mytableView.dataSource=self;
    _mytableView.delegate=self;
    //去掉边框和分割线
    [_mytableView setBackgroundColor:[UIColor clearColor]];
    [_mytableView setSeparatorColor:[UIColor clearColor]];
//
    [self.view addSubview:_mytableView];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    
    // NSLog(@"USERID %@",userid);
    
    [dictionary setValue: userid forKey:@"userId"];

    [dictionary setValue: @"1" forKey:@"pageIndex"];
    [dictionary setValue: @"100" forKey:@"pageSize"];
    [self showLoadingActivityViewWithString:@"正在加载..."];
    [[requestServiceHelper defaultService] getMyCommentsWithParamter:dictionary sucess:^(NSMutableDictionary *commentDictionary) {
        
        self.dictionayData=commentDictionary;
        [_mytableView reloadData];
         [self hideLoadingActivityView];
    } falid:^(NSString *errorMsg) {
        NSLog(@"%@",errorMsg);
         [self hideLoadingActivityView];
    }];
    
}

#pragma mark - Table view data source

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 
     return [self.dictionayData count];//[self.dataSource count];
 
 }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;//此处返回cell的高度
}

 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     static NSString *simpleTableIdentifier = @"CustomRightMenuViewCell";
 
     CustomRightMenuViewCell *cell = (CustomRightMenuViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];//复用cell
     if (cell == nil) {
         cell= [[[NSBundle mainBundle] loadNibNamed:@"CustomRightMenuViewCell" owner:self options:nil]lastObject];//加载自定义cell的xib文件
     }
     cell.formContextLabel.text=[[[self.dictionayData allValues] objectAtIndex:indexPath.row] objectForKey:@"reportTitle"];//[self.dataSource objectAtIndex:indexPath.row];
     cell.userImage.image=[UIImage imageNamed:@"user_icon"];
     cell.userNameLabel.text=[[[self.dictionayData allValues] objectAtIndex:indexPath.row] objectForKey:@"commentPerson"];
     cell.commentLabel.text=[[[self.dictionayData allValues] objectAtIndex:indexPath.row] objectForKey:@"commentContent"];
     cell.dateTimeLabel.text=[[[self.dictionayData allValues] objectAtIndex:indexPath.row] objectForKey:@"commentDate"];
     //
     [cell.userImage setImageWithURL:iconurl];
     
     cell.comeFromLabel.text=[[[self.dictionayData allValues] objectAtIndex:indexPath.row] objectForKey:@"reportType"];;
     cell.messageImage.image=[UIImage imageNamed:@"com_mes"];
     cell.totalMessageLabel.text=[[[self.dictionayData allValues] objectAtIndex:indexPath.row] objectForKey:@"commentNumber"];;
     
     [cell.accessoryView setFrame:CGRectMake(0, 0, 0, 0)];
     return cell;
 
 }

-(IBAction)doDone:(id)sender
{
   
    UIButton *btn=(UIButton*)sender;
    //权限功能
    if ([btn tag]==2) {
        AuditReportListViewController *auditCtrl=[[AuditReportListViewController alloc] initWithNibName:@"AuditedReportListViewController" bundle:Nil];
        auditCtrl.title=@"已审核";
        BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:auditCtrl];
        AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [myDelegate.revealSideViewController pushViewController:nav onDirection:PPRevealSideOptionsBounceAnimations withOffset:0 animated:YES forceToPopPush:YES completion:nil];

    }
    //收藏
    if ([btn tag]==4) {
        FavoriteListViewController *favCtrl=[[FavoriteListViewController alloc] init];
        favCtrl.title=@"收藏";
        BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:favCtrl];
        AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [myDelegate.revealSideViewController pushViewController:nav onDirection:PPRevealSideOptionsBounceAnimations withOffset:0 animated:NO forceToPopPush:YES completion:nil];
//        [self.navigationController pushViewController:favCtrl animated:YES];
        
    }
    //设置
    else if([btn tag]==5){
        
        [btn setBackgroundImage:[UIImage imageNamed:@"grzy_Setting"] forState:UIControlStateNormal];
        SettingController *setCtrl=[[SettingController alloc] init];
        setCtrl.title=@"设置";
        BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:setCtrl];
        AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [myDelegate.revealSideViewController pushViewController:nav onDirection:PPRevealSideOptionsBounceAnimations withOffset:0 animated:YES forceToPopPush:YES completion:nil];
    }
        
    
}
-(IBAction)buttonDown:(id)sender
{
    NSLog(@"----------111111");
     UIButton *btn=(UIButton*)sender;
    if ([btn tag]==2) {}
    else if([btn tag]==4){}
    else if([btn tag]==5){
        [btn setBackgroundImage:[UIImage imageNamed:@"setting@2x"] forState:UIControlStateNormal];
    }
}
-(IBAction)buttonUp:(id)sender{
    UIButton *btn=(UIButton*)sender;
    if ([btn tag]==2) {}
    else if([btn tag]==4){}
    else if([btn tag]==5){
        [btn setBackgroundImage:[UIImage imageNamed:@"grzy_Setting"] forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
