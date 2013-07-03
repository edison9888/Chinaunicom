//
//  AuditedReportListViewController.m
//  Chinaunicom
//
//  Created by LITK on 13-5-16.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "AuditReportListViewController.h"
#import "AppDelegate.h"
#import "RightMenuViewController.h"
#import "MessageTypeViewController.h"
#import "AuditAndNonAuditReportViewController.h"
#import "SysConfig.h"
#import "User.h"
#import "requestServiceHelper.h"
#import "AudiReportDetail.h"
@interface AuditReportListViewController ()

@end

@implementation AuditReportListViewController
@synthesize myTableView,state;
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
    [self initParmeter];
    [self initLayout];
    [self initDataSource];
    
}

-(void)initLayout
{
    
    //返回按钮
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 32, 32);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backItem;
    
    /*分割线1*/
    UIImageView *imageViewTopDiv1=[[UIImageView alloc] initWithFrame:CGRectMake(40, -10, 30, 63)];
    [imageViewTopDiv1 setImage:[UIImage imageNamed:@"topDividingLine"]];
    [imageViewTopDiv1 setTag:101];
    [self.navigationController.navigationBar addSubview:imageViewTopDiv1];
    
    //添加底部navbar
    UINavigationBar *bottomBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 372, 320, 44)];
    [bottomBar setBackgroundImage:[UIImage imageNamed:@"bottomNav"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:bottomBar];
    
    //为nabar添加对应的items
    /*发布消息*/
    UIButton* messageButton= [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(20, 3, 80, 40);
    [messageButton setTitle:@"发布消息" forState:UIControlStateNormal];
    [messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [messageButton setTag:1];
    //[messageButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:messageButton];
    /*分割线1*/
    UIImageView *imageViewBottomDiv1=[[UIImageView alloc] initWithFrame:CGRectMake(105, 0, 30, 44)];
    [imageViewBottomDiv1 setImage:[UIImage imageNamed:@"dividingLine"]];
    [bottomBar addSubview:imageViewBottomDiv1];
    
    /*待审核*/
    UIButton* nonAuditButton= [UIButton buttonWithType:UIButtonTypeCustom];
    nonAuditButton.frame = CGRectMake(133, 3, 80, 40);
    [nonAuditButton setTitle:@"待审核" forState:UIControlStateNormal];
    [nonAuditButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nonAuditButton setTag:2];
    [nonAuditButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:nonAuditButton];
    /*分割线2*/
    UIImageView *imageViewBottomDiv2=[[UIImageView alloc] initWithFrame:CGRectMake(210, 0, 30, 44)];
    [imageViewBottomDiv2 setImage:[UIImage imageNamed:@"dividingLine"]];
    [bottomBar addSubview:imageViewBottomDiv2];
    
    /*已审核*/
    UIButton* auditedButton= [UIButton buttonWithType:UIButtonTypeCustom];
    auditedButton.frame = CGRectMake(230, 3, 80,40);
    [auditedButton setTitle:@"已审核" forState:UIControlStateNormal];
    [auditedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [auditedButton setTag:3];
    [auditedButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:auditedButton];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    //显示导航栏
     [self.navigationController.navigationBar setHidden:NO];
//    [self upDataAgain];
}



-(void)back
{
//    RightMenuViewController *right=[[RightMenuViewController alloc] init];
//    BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:right];
//    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [myDelegate.revealSideViewController pushViewController:nav onDirection:PPRevealSideDirectionRight withOffset:50 animated:YES forceToPopPush:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void) initParmeter{
    myTableView =  [[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, 320, 372+(iPhone5?88:0))];
    self.dataSource = [[NSMutableArray alloc] init];
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    [self.view addSubview:self.myTableView];
    myTableView.tableFooterView.hidden=YES;
    page=1;
    totalresult=0;
    pageSize=10;
    state=@"2";
    //    isfirst=YES;
}

//初始化数据
-(void)initDataSource
{
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: [NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [dictionary setValue: [NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    [dictionary setValue: state forKey:@"status"];
    [dictionary setValue: userid forKey:@"userId"];
    [self showLoadingActivityViewWithString:@"数据加载中"];
    [[requestServiceHelper defaultService] getAduitingList:dictionary sucess:^(NSMutableArray *reportDictionary, NSInteger result) {
        totalresult =result;
        myTableView.tableFooterView.hidden=NO;
       
        [self hideLoadingActivityView];
        if (totalresult > 0) {
            NSString *msg=@"";
            if ([state isEqualToString:@"2"]) {
                msg=@"条已审核消息";
            }
            else{
                msg=@"条待审核消息";
            }
            self.count.text=[[@"有" stringByAppendingString:[NSString stringWithFormat:@"%d",totalresult]] stringByAppendingString:msg];
            if (self.dataSource.count >=totalresult) {
                [myTableView reloadData:YES];
                return;
            }
            
            if (page == 1) {
                [self.dataSource removeAllObjects];
            }
            
            [self.dataSource addObjectsFromArray:reportDictionary];
            
            [myTableView reloadData:NO];
        }else {
            [myTableView reloadData:NO];
            return;
        }
        
        [self performSelectorOnMainThread:@selector(isOver) withObject:nil waitUntilDone:NO];
        
        
    } falid:^(NSString *errorMsg) {
        [self hideLoadingActivityView];
    }];
    
    
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger returnKey = [myTableView tableViewDidEndDragging];
    if (returnKey != k_RETURN_DO_NOTHING) {
        switch (returnKey) {
            case k_RETURN_REFRESH:{
                [self upDataAgain];
            }break;
            case k_RETURN_LOADMORE:{
                [self moreInfor];
            }break;
            default:break;
        }
    }
    
}
-(void)upDataAgain{
    page = 1;
    [self initDataSource];
}
-(void)moreInfor{
    page = [self.dataSource count]/pageSize + 1;
    [self initDataSource];
}





-(void)doDone:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    if([btn tag]==1){
        
        MessageTypeViewController *mesCtr=[[MessageTypeViewController alloc] init];
        [self.navigationController pushViewController:mesCtr animated:YES];
    }
    //待审核
    if ([btn tag]==2) {
        self.title=@"待审核";
        state=@"1";
        page=1;
        [self.dataSource removeAllObjects];
        totalresult=0;
         [myTableView reloadData:YES];
        [self initDataSource];
    }
    if ([btn tag]==3) {
        self.title=@"已审核";
        state=@"2";
        [self.dataSource removeAllObjects];
         [myTableView reloadData:YES];
        page=1;
        totalresult=0;
        [self initDataSource];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataSource count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"CustomMainViewCell";
    CustomMainViewCell *cell = (CustomMainViewCell*)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];//复用cell
    //通过XIB将cell添加上去
    //    if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomMainViewCell" owner:self options:nil]lastObject];
    //            cell = [array objectAtIndex:0];
    //    }
    [self initCustomTableCell:cell IndexPath:indexPath];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;//此处返回cell的高度
}
#pragma mark - Table view data source
-(void)initCustomTableCell:(CustomMainViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    //内容摘要
    if (cell.contextLabel==nil) {
        cell.contextLabel=[[UILabel alloc] initWithFrame:CGRectMake(14, 5, 180, 49)];
        cell.contextLabel.text=[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"title"];
        //[cell.contextLabel setTextAlignment:NSTextAlignmentLeft];
        [cell.contextLabel setTextAlignment:NSTextAlignmentLeft];
        [cell.contextLabel setBackgroundColor:[UIColor clearColor]];
        [cell.contextLabel setNumberOfLines:2];
        [cell addSubview:cell.contextLabel];
    }
    //评论
    if (cell.countLabel==nil) {
        cell.countLabel=[[UILabel alloc] init];
        [cell.countLabel setFrame:CGRectMake(160, 60, 160, 21)];
        cell.countLabel.text=[[self.dataSource objectAtIndex:indexPath.row ] objectForKey:@"published"];
        [cell.countLabel setBackgroundColor:[UIColor clearColor]];
        [cell.countLabel setTextColor:[CommonHelper hexStringToColor:@"#8D8D8E"]];
        [cell addSubview:cell.countLabel];
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([state isEqualToString:@"1"]) {
        NSString *reportId = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"reportId"];
        AudiReportDetail *contextDetailCtrl=[[AudiReportDetail alloc] init];
        Report *_report=[[Report alloc] init];
        _report.reportId=reportId;
        contextDetailCtrl.myReport=_report;
        [self.navigationController pushViewController:contextDetailCtrl animated:YES];
    }
    else{
        NSString *reportId = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"reportId"];
        ContextDetailController *contextDetailCtrl=[[ContextDetailController alloc] init];
        Report *_report=[[Report alloc] init];
        _report.reportId=reportId;
        contextDetailCtrl.myReport=_report;
        [self.navigationController pushViewController:contextDetailCtrl animated:YES];

    }
    
}

-(void)isOver
{
    
    if (self.dataSource.count >= totalresult) {
        [myTableView reloadData:YES];
    }
}

@end
