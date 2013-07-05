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
#import "NSString+NSString_Extended.h"
@interface MainViewController ()

@end

@implementation MainViewController

//-(void)pushToMainPage:(int)tag title:(NSString *)str
//{
//    self.title =str;
//    self.reportid=[NSString stringWithFormat:@"%d",tag];
//    [self initDataSource];
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"电商头条";
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
    
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    [self getReportType:[NSString stringWithFormat:@"%d",[user.userId intValue]]];

}
//获取我已关注的菜单分类
-(void)getReportType:(NSString*)userId
{
    
    [[requestServiceHelper defaultService] getMyMenuReportType:userId sucess:^(NSArray *array) {
        
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:KEY_LEFTMENU_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } falid:^(NSString *errorMsg) {
        
    }];
    
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
    myTableView =  [[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, 320, 412+(iPhone5?88:0))];
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    [myTableView setBackgroundView:nil];
    [myTableView setBackgroundColor:[UIColor clearColor]];
    //去掉分割线
    [myTableView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:myTableView];
    myTableView.tableFooterView.hidden=YES;
    page=1;
    totalresult=0;
    pagesize=10;
    isfirst=YES;
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
    //测试
    [[requestServiceHelper defaultService]getReportList:url parmeter:dictionary sucess:^(NSMutableArray *reportDictionary, NSInteger result) {
        totalresult =result;
        [myTableView.footerView setHidden:NO];
        if (totalresult > 0) {
            
            if (page == 1) {
                [dataSource removeAllObjects];
            }
            
            [dataSource addObjectsFromArray:reportDictionary];
            
        }else {
            return;
        }
        
        [self performSelectorOnMainThread:@selector(isOver) withObject:nil waitUntilDone:NO];

        
    } falid:^(NSString *errorMsg) {
        
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
    NSLog(@"aaaaaa=%@",dataSource);
    UIImage *image=[UIImage imageNamed:@"qitalei.png"];
    NSString *titleStr=[[dataSource objectAtIndex:indexPath.row]objectForKey:@"reportTitle"];
    CGSize titleSize;
    if ([[dataSource objectAtIndex:indexPath.row]objectForKey:@"picPath"]!=nil) {
        NSString * path=[[dataSource objectAtIndex:indexPath.row]objectForKey:@"picPath"];
        NSArray *imageArray=[path componentsSeparatedByString:@","];
        if ([imageArray count]>1) {
            titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            return 10+titleSize.height+5 +image.size.height+5 + 80;
        }else
        {
            titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(190, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            return 10+titleSize.height+5 +image.size.height+5;
        }

    }else
    {
        titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        return 10+titleSize.height+5 +image.size.height+5;
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
            cell.pinlunLabel.frame=CGRectMake(320-3-70, 10+titleSize.height+5+10, 70, 20);
            
            for (int i=0; i<[imageArray count]; i++) {
                
                CellImageView *imageView=[[CellImageView alloc]initWithFrame:CGRectMake((i+1)*15+i*80, 10+titleSize.height+5+40, 80, 60)];
                NSString *picPath=[[imageArray objectAtIndex:i]stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                NSString *test=[ImageUrl stringByAppendingString:picPath];
                NSString *sUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)test, nil, nil, kCFStringEncodingUTF8));
                [imageView setImageWithURL:[NSURL URLWithString:sUrl]];
                [cell.contentView addSubview:imageView];
            }
            
        }else
        {
            titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(190, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            cell.pinlunLabel.frame=CGRectMake(15+100, 10+titleSize.height+5+5, 70, 20);
            NSString *picPath=[[imageArray objectAtIndex:0]stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            cell.tupianImageView.frame=CGRectMake(220, 7, 80, 60);
            NSData *data = [picPath dataUsingEncoding: NSUTF8StringEncoding];
            NSString *content=[[NSString alloc]initWithData:data encoding:1];
            [cell.tupianImageView setImageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:content ]]];
        }
        
    }else
    {
        titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        cell.pinlunLabel.frame=CGRectMake(320-3-70, 10+titleSize.height+5+10, 70, 20);
        cell.tupianImageView.frame=CGRectMake(0, 0, 0, 0);
        cell.tupianImageView.image=nil;
    }
    cell.titleLabel.frame=CGRectMake(15, 10, titleSize.width, titleSize.height);
    cell.titleLabel.text=titleStr;
    NSString *type=[[dataSource objectAtIndex:indexPath.row]objectForKey:@"reportType"];
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
    cell.qitaImageView.frame=CGRectMake(15, 10+cell.titleLabel.frame.size.height+5, tupianImage.size.width, tupianImage.size.height);
    
    NSString *commentNum=[[dataSource objectAtIndex:indexPath.row]objectForKey:@"commentsNumber"];
    cell.pinlunLabel.text=[NSString stringWithFormat:@"评论 %@",commentNum];
    
    if ([[dataSource objectAtIndex:indexPath.row]objectForKey:@"picPath"]!=nil) {
        if ([imageArray count]>1) {
            cell.bgImageView.frame=CGRectMake(3, 3, 320-6, cell.qitaImageView.frame.origin.y+cell.qitaImageView.frame.size.height+5+80);
        }else
        {
            cell.bgImageView.frame=CGRectMake(3, 3, 320-6, cell.qitaImageView.frame.origin.y+cell.qitaImageView.frame.size.height+5);
        }
        
    }else{
        cell.bgImageView.frame=CGRectMake(3, 3, 320-6, cell.qitaImageView.frame.origin.y+cell.qitaImageView.frame.size.height+5);
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
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void) showRight
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)dismissKeyboard {
    [self.mySearch resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {


    [super viewDidUnload];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [myTableView tableViewDidDragging];
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
    if (isSearchBar) {
        [self searchBarMoreInfo];
    }else
    {
        [self initDataSource];
    }
    
}
-(void)moreInfor{
    page = [dataSource count]/pagesize + 1;
    if (isSearchBar) {
        [self searchBarMoreInfo];
    }else
    {
        [self initDataSource];
    }

}
-(void)isOver
{
    if (dataSource.count >= totalresult) {
        [myTableView reloadData:YES];
    }else
    {
        [myTableView reloadData:NO];
    }
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    isSearchBar=YES;
    page=1;
    NSMutableDictionary *dir=[[NSMutableDictionary alloc]init];
    NSData *data = [[self.mySearch text] dataUsingEncoding: NSUTF8StringEncoding];
    NSString *content=[[NSString alloc]initWithData:data encoding:1];
    [dir setValue: [NSString stringWithFormat:@"%d",page] forKey:@"index"];
    [dir setValue: [NSString stringWithFormat:@"%d",pagesize] forKey:@"pageNumber"];
    [dir setValue: content forKey:@"title"];
    [self getreportList:SearchReport parmeter:dir];
    [self dismissKeyboard];
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
