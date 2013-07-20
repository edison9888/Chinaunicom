//
//  SafetyViewController.m
//  Chinaunicom
//
//  Created by  on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "User.h"
#import "UIImageView+WebCache.h"
#import "CellImageView.h"
#import "MainViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "CustomMainViewCell.h"
#import "requestServiceHelper.h"
#import "ContextDetailController.h"
#import "GTMBase64.h"

@interface MainViewController ()
{
    int whichNum;
    int pagesize;
    NSInteger page;
    BOOL refreshing;
    NSMutableArray *dataSource;
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"电商头条";
        pagesize=10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataSource = [[NSMutableArray alloc] init];
    //初始化tableview
    [self initParmeter];
    //初始化导航条 和 搜索框
    [self initView];
    //请求全部数据列表
    [self initDataSource];
}

-(void)initView
{
    //多菜单按钮
    UIButton* listButton= [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *listImage=[UIImage imageNamed:@"menu.png"];
    listButton.frame = CGRectMake(0, 0, listImage.size.width, listImage.size.height);
    [listButton setBackgroundImage:listImage forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem= [[UIBarButtonItem alloc] initWithCustomView:listButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    /*分割线1*/
    UIImageView *imageViewTopDiv1=[[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 2, 44)];
    [imageViewTopDiv1 setImage:[UIImage imageNamed:@"new_line.png"]];
    [imageViewTopDiv1 setTag:101];
    [self.navigationController.navigationBar addSubview:imageViewTopDiv1];
    
    //个人中心按钮
    UIButton* personalButton= [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *userImage=[UIImage imageNamed:@"user.png"];
    personalButton.frame = CGRectMake(0, 0, userImage.size.width, userImage.size.height);
    [personalButton setBackgroundImage:userImage forState:UIControlStateNormal];
    [personalButton addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem= [[UIBarButtonItem alloc] initWithCustomView:personalButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    /*分割线2*/
    UIImageView *imageViewTopDiv2=[[UIImageView alloc] initWithFrame:CGRectMake(270, 0, 2, 44)];
    [imageViewTopDiv2 setImage:[UIImage imageNamed:@"new_line"]];
    [imageViewTopDiv2 setTag:102];
    [self.navigationController.navigationBar addSubview:imageViewTopDiv2];
    
    //背景图片
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    //搜索
    [self.mySearch setBackgroundImage:[UIImage imageNamed:@"searchbg.png"]];
    [self.mySearch setDelegate:self];

}
-(void) initParmeter{
    if (iPhone5) {
            myTableView =[[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, 320, 548-44-44) pullingDelegate:self];
    }else
    {
        myTableView =[[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44-44) pullingDelegate:self];
    }

    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    [myTableView setBackgroundView:nil];
    [myTableView setBackgroundColor:[UIColor clearColor]];
    [myTableView setSeparatorColor:[UIColor clearColor]];
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:myTableView];
    if (page==0) {
        whichNum=10;
        [myTableView launchRefreshing];
    }
}
-(void)initChangeSource:(int)reid
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: [NSString stringWithFormat:@"%d",page] forKey:@"index"];
    [dictionary setValue: [NSString stringWithFormat:@"%d",pagesize] forKey:@"pageNumber"];
    
    NSString  *url=ReportPath;
    
    if (reid==12)
    {
        [dictionary setValue:@"12" forKey:@"repTypeId"];
    }
    else if(reid==13)
    {
        [dictionary setValue:@"13" forKey:@"repTypeId"];
    }
    else if(reid==14)
    {
        [dictionary setValue:@"14" forKey:@"repTypeId"];
    }else
    {
        [dictionary setValue:@"15" forKey:@"repTypeId"];
    }
    [self getreportList:url parmeter:dictionary];

}
-(void)reloadSource:(int)num
{
     whichNum=num;
    [myTableView launchRefreshing];
}
-(void)initDataSource
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: [NSString stringWithFormat:@"%d",page] forKey:@"index"];
    [dictionary setValue: [NSString stringWithFormat:@"%d",pagesize] forKey:@"pageNumber"];
    
    NSString  *url=AllReportPath;
        
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];

    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    [dictionary setValue: userid forKey:@"userId"];
   
    [self getreportList:url parmeter:dictionary];
}
//获取报告列表
-(void)getreportList:(NSString *)url parmeter:(NSMutableDictionary *)dictionary
{
    [[requestServiceHelper defaultService]getReportList:url parmeter:dictionary sucess:^(NSMutableArray *reportDictionary, NSInteger result) {
        if (page==1) {
            [dataSource removeAllObjects];
        }
        [dataSource addObjectsFromArray:reportDictionary];
        if ([dataSource count]==result) {
            [myTableView reloadData];
            [myTableView tableViewDidFinishedLoading];
            myTableView.reachedTheEnd  = YES;
            
        }else
        {
             [myTableView reloadData];
            [myTableView tableViewDidFinishedLoading];
            myTableView.reachedTheEnd  = NO;
           
        }
    } falid:^(NSString *errorMsg) {
         [myTableView reloadData];
         [myTableView tableViewDidFinishedLoading];
         myTableView.reachedTheEnd  = YES;
    }];
    
    
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 25)];
//    UIImageView *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 25)];
//    headImageView.image=[UIImage imageNamed:@"toutiao_head.png"];
//    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 15)];
//    [label setFont:[UIFont systemFontOfSize:13.0f]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setTextColor:[UIColor blueColor]];
//    [label setText:@"11111"];
//    [headView addSubview:headImageView];
//    [headImageView addSubview:label];
//    return headView;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [dataSource count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIImage *image=[UIImage imageNamed:@"qitalei.png"];
    NSString *titleStr=[[[dataSource objectAtIndex:indexPath.row]objectForKey:@"reportTitle"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CGSize titleSize;
    if ([[dataSource objectAtIndex:indexPath.row]objectForKey:@"picPath"]!=nil) {
        NSString * path=[[[dataSource objectAtIndex:indexPath.row]objectForKey:@"picPath"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *imageArray=[path componentsSeparatedByString:@","];
        if ([imageArray count]>1) {
            titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            return 10+titleSize.height+5 +30+5 + 60+5+3;
        }else
        {
            titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(190, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            return 10+titleSize.height+5 +30+5+3;
        }

    }else
    {
        titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        return 10+titleSize.height+5 +30+5+3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellWithIdentifier = @"CustomMainViewCell";
    CustomMainViewCell *cell = (CustomMainViewCell*)[tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];//复用cell
    
    if (cell == nil) {
        cell=[[CustomMainViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    for (UIView *view in [cell.contentView subviews]) {
        if ([view isMemberOfClass:[CellImageView class]]) {
            [view removeFromSuperview];
        }
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(CustomMainViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleStr=[[dataSource objectAtIndex:indexPath.row]objectForKey:@"reportTitle"];
    CGSize titleSize;
    NSString * path=[[dataSource objectAtIndex:indexPath.row]objectForKey:@"picPath"];
    NSArray *imageArray=[path componentsSeparatedByString:@","];
    if ([[dataSource objectAtIndex:indexPath.row]objectForKey:@"picPath"]!=nil) {
        
        if ([imageArray count]>1) {
            titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            cell.pinlunLabel.frame=CGRectMake(320-3-80, 10+titleSize.height+5+15, 70, 20);
            
            for (int i=0; i<[imageArray count]; i++) {
                
                CellImageView *imageView=[[CellImageView alloc]initWithFrame:CGRectMake((i+1)*15+i*80, 10+titleSize.height+5+35, 80, 60)];
                NSString *picPath=[[imageArray objectAtIndex:i]stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                NSData *data = [picPath dataUsingEncoding: NSUTF8StringEncoding];
                NSString *content=[[NSString alloc]initWithData:data encoding:1];
                [imageView setImageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:content]]];
                [cell.contentView addSubview:imageView];
            }
            
        }else
        {
            titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(190, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            cell.pinlunLabel.frame=CGRectMake(15+100, 10+titleSize.height+5+10, 70, 20);
            NSString *picPath=[[imageArray objectAtIndex:0]stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            cell.tupianImageView.frame=CGRectMake(220, 7, 80, 60);
            NSData *data = [picPath dataUsingEncoding: NSUTF8StringEncoding];
            NSString *content=[[NSString alloc]initWithData:data encoding:1];
            [cell.tupianImageView setImageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:content]]];
        }
        
    }else
    {
        titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        cell.pinlunLabel.frame=CGRectMake(320-3-80, 10+titleSize.height+5+15, 70, 20);
        cell.tupianImageView.frame=CGRectMake(0, 0, 0, 0);
        cell.tupianImageView.image=nil;
    }
    cell.titleLabel.frame=CGRectMake(15, 10, titleSize.width, titleSize.height);
    cell.titleLabel.text=titleStr;
    NSString *type=[[[dataSource objectAtIndex:indexPath.row]objectForKey:@"reportType"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *tupianImage=nil;
    if ([type isEqualToString:@"12"]){
        
        tupianImage=[UIImage imageNamed:@"anquanlei.png"];
        
    }else if ([type isEqualToString:@"14"]) {
        tupianImage=[UIImage imageNamed:@"fenxilei.png"];
    }
    else if([type isEqualToString:@"13"]){
        tupianImage=[UIImage imageNamed:@"weihulei.png"];
    }
    else{
        tupianImage=[UIImage imageNamed:@"qitalei.png"];
    }
    cell.qitaImageView.image=tupianImage;
    cell.qitaImageView.frame=CGRectMake(15, 10+cell.titleLabel.frame.size.height+5, 30, 30);
    
    NSString *commentNum=[[[dataSource objectAtIndex:indexPath.row]objectForKey:@"commentsNumber"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    cell.pinlunLabel.text=[NSString stringWithFormat:@"评论 %@",commentNum];
    
    if ([[dataSource objectAtIndex:indexPath.row]objectForKey:@"picPath"]!=nil) {
        if ([imageArray count]>1) {
            cell.bgImageView.frame=CGRectMake(3, 0, 320-6, cell.qitaImageView.frame.origin.y+cell.qitaImageView.frame.size.height+5+60+5+3);
        }else
        {
            cell.bgImageView.frame=CGRectMake(3, 0, 320-6, cell.qitaImageView.frame.origin.y+cell.qitaImageView.frame.size.height+5+3);
        }
        
    }else{
        cell.bgImageView.frame=CGRectMake(3, 0, 320-6, cell.qitaImageView.frame.origin.y+cell.qitaImageView.frame.size.height+5+3);
    }
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.mySearch isFirstResponder]) {
        [self.mySearch resignFirstResponder];
    }else
    {
        NSString *str=[[dataSource objectAtIndex:indexPath.row]objectForKey:@"reportId"];
        ContextDetailController *contextDetailCtrl=[[ContextDetailController alloc] initWithNibName:@"ContextDetailController" bundle:nil];
        contextDetailCtrl.reportId=str;
        [self.navigationController pushViewController:contextDetailCtrl animated:YES];
    }

}
#pragma mark - viewWillAppear
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

#pragma mark - Button Handlers
-(void)showLeft
{
    [self.view endEditing:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void) showRight
{
    [self.view endEditing:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)dismissKeyboard {
    [self.mySearch resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
//判断是刷新还是加载更多
- (void)loadData
{
    page++;
    if (refreshing)
    {
        page = 1;
        refreshing = NO;
        if (whichNum==10)
        {
            [self initDataSource];
            
        }else if (whichNum==100)
        {
            [self searchBarMoreInfo];
        }
        else
        {
            [self initChangeSource:whichNum];
        }
    }
    else
    {
        if (whichNum==10) {
            
            [self initDataSource];
            
        }else if (whichNum==100)
        {
            [self searchBarMoreInfo];
        }
        else
        {
            [self initChangeSource:whichNum];
        }
    }
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
    [myTableView tableViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [myTableView tableViewDidEndDragging:scrollView];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    whichNum=100;
    [self dismissKeyboard];
    [myTableView launchRefreshing];
}

-(void)searchBarMoreInfo
{
    NSMutableDictionary *dir=[[NSMutableDictionary alloc]init];
    NSData *data = [[self.mySearch text] dataUsingEncoding: NSUTF8StringEncoding];
    NSString *content=[[NSString alloc]initWithData:data encoding:1];
    [dir setValue: [NSString stringWithFormat:@"%d",page] forKey:@"index"];
    [dir setValue: [NSString stringWithFormat:@"%d",pagesize] forKey:@"pageNumber"];
    [dir setValue: content forKey:@"title"];
    [self getreportList:SearchReport parmeter:dir];
}

@end
