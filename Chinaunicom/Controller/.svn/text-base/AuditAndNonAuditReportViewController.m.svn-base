//
//  AuditAndNonAuditReportViewController.m
//  Chinaunicom
//
//  Created by LITK on 13-6-3.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "AuditAndNonAuditReportViewController.h"
#import "SysConfig.h"
#import "User.h"
#import "requestServiceHelper.h"
@interface AuditAndNonAuditReportViewController ()

@end

@implementation AuditAndNonAuditReportViewController
@synthesize myTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title=@"待审核";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLayout];
    [self initParmeter];
    [self initDataSource];
}
-(void) initParmeter{
    myTableView =  [[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, 320, 420+(iPhone5?88:0))];
    self.dataSource = [[NSMutableArray alloc] init];
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    [self.view addSubview:self.myTableView];
    myTableView.tableFooterView.hidden=YES;
    page=1;
    totalresult=0;
    pageSize=10;
    isfirst=YES;
}
- (void) initLayout
{
    //返回按钮
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 32, 32);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backItem;
    
    //添加底部navbar
    UINavigationBar *bottomBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 372, 320, 44)];
    [bottomBar setBackgroundImage:[UIImage imageNamed:@"bottomNav"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:bottomBar];
    
    //为nabar添加对应的items
    /*待审核*/
    UIButton* nonAuditButton= [UIButton buttonWithType:UIButtonTypeCustom];
    nonAuditButton.frame = CGRectMake(40, 3, 80, 40);
    [nonAuditButton setTitle:@"待审核" forState:UIControlStateNormal];
    [nonAuditButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nonAuditButton setTag:1];
    [nonAuditButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:nonAuditButton];
    /*分割线2*/
    UIImageView *imageViewBottomDiv2=[[UIImageView alloc] initWithFrame:CGRectMake(150, 0, 30, 44)];
    [imageViewBottomDiv2 setImage:[UIImage imageNamed:@"dividingLine"]];
    [bottomBar addSubview:imageViewBottomDiv2];
    
    /*已审核*/
    UIButton* auditedButton= [UIButton buttonWithType:UIButtonTypeCustom];
    auditedButton.frame = CGRectMake(200, 3, 80,40);
    [auditedButton setTitle:@"已审核" forState:UIControlStateNormal];
    [auditedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [auditedButton setTag:2];
    [auditedButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:auditedButton];

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
    [dictionary setValue: [NSString stringWithFormat:@"1"] forKey:@"status"];
    [dictionary setValue: userid forKey:@"userId"];
    [self showLoadingActivityViewWithString:@"数据加载中"];
    [[requestServiceHelper defaultService] getAduitingList:dictionary sucess:^(NSMutableArray *reportDictionary, NSInteger result) {
        totalresult =result;
        myTableView.tableFooterView.hidden=NO;
        [self hideLoadingActivityView];
        if (totalresult > 0) {
            //self.count.text=[[@"有" stringByAppendingString:[NSString stringWithFormat:@"%d",totalresult]] stringByAppendingString:@"条已审核消息"];
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
-(void)doDone:(UIButton*)sender
{
    if ([sender tag]==1) {
        self.title=@"待审核";
    }
    if ([sender tag]==2) {
        self.title=@"已审核";
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

- (void)viewDidUnload {

    [super viewDidUnload];
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
    NSInteger count=self.dataSource.count-1;
    if (cell.contextLabel==nil) {
        cell.contextLabel=[[UILabel alloc] initWithFrame:CGRectMake(14, 5, 180, 49)];
        cell.contextLabel.text=[[self.dataSource objectAtIndex:count-indexPath.row] objectForKey:@"title"];
        //[cell.contextLabel setTextAlignment:NSTextAlignmentLeft];
        [cell.contextLabel setTextAlignment:NSTextAlignmentLeft];
        [cell.contextLabel setBackgroundColor:[UIColor clearColor]];
        [cell.contextLabel setNumberOfLines:2];
        [cell addSubview:cell.contextLabel];
    }
    //评论
    if (cell.countLabel==nil) {
        cell.countLabel=[[UILabel alloc] init];
        [cell.countLabel setFrame:CGRectMake(160, 60, 120, 21)];
        cell.countLabel.text=[[self.dataSource objectAtIndex:count-indexPath.row ] objectForKey:@"published"];
        [cell.countLabel setBackgroundColor:[UIColor clearColor]];
        [cell.countLabel setTextColor:[CommonHelper hexStringToColor:@"#8D8D8E"]];
        [cell addSubview:cell.countLabel];
    }
}
-(void)isOver
{
    
    if (self.dataSource.count >= totalresult) {
        [myTableView reloadData:YES];
    }
}
@end
