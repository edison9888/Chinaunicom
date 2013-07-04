//
//  GoodCommentsViewController.m
//  Chinaunicom
//
//  Created by YY on 13-7-5.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "GoodCommentsViewController.h"

@interface GoodCommentsViewController ()

@end

@implementation GoodCommentsViewController
-(void)loadView
{
    [super loadView];

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
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, 320, 44)];
    [bottomView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_tableview];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (page == 0)
    {
        [_tableview launchRefreshing];
    }
    [_tableview tableViewDidFinishedLoading];
    [_tableview reloadData];
}
////判断是刷新还是加载更多
//- (void)loadData
//{
//    page++;
//    if (refreshing)
//    {
//        page = 1;
//        refreshing = NO;
//        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[ZDMyInfo shareInstance].userPin,@"tuserpin",
//                            [NSNumber numberWithInt:page],@"start",
//                            GROUP_LOAD_TOTAL,@"n",
//                            nil];
//        [[ZDHttpRequestController defaultController]sendZDYuebaYukuaiRequest:ZDYukuaiRequestType_dating_getlist
//                                                                   needLogin:YES
//                                                                postValueDic:dict
//                                                                      status:REQUEST_STATUS_ONE
//                                                                    delegate:self
//                                                           didFinishSelector:@selector(requestSuccess:)
//                                                             didFailSelector:@selector(requestFail:)];
//    }
//    else
//    {
//        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[ZDMyInfo shareInstance].userPin,@"tuserpin",
//                            [NSNumber numberWithInt:page],@"start",
//                            GROUP_LOAD_TOTAL,@"n",
//                            nil];
//        [[ZDHttpRequestController defaultController]sendZDYuebaYukuaiRequest:ZDYukuaiRequestType_dating_getlist
//                                                                   needLogin:YES
//                                                                postValueDic:dict
//                                                                      status:REQUEST_STATUS_TWO
//                                                                    delegate:self
//                                                           didFinishSelector:@selector(requestSuccess:)
//                                                             didFailSelector:@selector(requestFail:)];
//        
//    }
//}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"GoodComment";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];//复用cell
    
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;

}
#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
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
////请求成功 先删除本地数据库 重新插入数据
//-(void)requestSuccess :(ASIHTTPRequest *)request
//{
//    NSData *data=[request responseData];
//    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    int status=[[dict objectForKey:@"status"]intValue];
//    if (status!=STATUS_SUCCESS) {
//        NSDictionary *error=[dict objectForKey:@"error"];
//        NSString *message = [error objectForKey:@"msg"];
//        [[UINoticeTextUtil sharedInstance]showWithText:message stay:2 offset:-200];
//        [self.tableview tableViewDidFinishedLoading];
//        self.tableview.reachedTheEnd  = YES;
//        return;
//    }
//    if ([[request requestStatus]isEqualToString: REQUEST_STATUS_ONE])
//    {
//        [ZDInvitation deleteAllInInvitationTable];
//    }
//    
//    NSDictionary *josn=[dict objectForKey:@"data"];
//    if ([josn count]==0) {
//        [self.tableview tableViewDidFinishedLoading];
//        self.tableview.reachedTheEnd  = YES;
//        return;
//    }
//    int count=[[josn objectForKey:@"count"]intValue];
//    if (count!=0)
//    {
//        NSArray *list=[josn objectForKey:@"list"];
//        if ([list count]==0)
//        {
//            [self.tableview tableViewDidFinishedLoading];
//            self.tableview.reachedTheEnd  = YES;
//        }
//        else
//        {
//            for (NSDictionary *listDict in list)
//            {
//                ZDInvitation *invitation=[[ZDInvitation alloc]init];
//                [invitation setMemberVariables:listDict];
//                [invitation release];
//            }
//            _array=[[NSMutableArray alloc]initWithArray:[ZDInvitation getFromInvitationTable]];
//            [self.tableview tableViewDidFinishedLoading];
//            self.tableview.reachedTheEnd  = NO;
//            [self.tableview reloadData];
//        }
//        
//    }
//    else
//    {
//        [self.tableview tableViewDidFinishedLoading];
//        self.tableview.reachedTheEnd  = YES;
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

@end
