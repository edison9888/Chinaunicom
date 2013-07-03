//
//  SafetyViewController.m
//  Chinaunicom
//
//  Created by  on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "MainViewController.h"
#import "SysConfig.h"
#import "requestServiceHelper.h"
#import "Report.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+MMDrawerController.h"
#import "LeftMenuViewController.h"
#define KEY_LOAD 201316
#define AnnimationTime 0.5

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize myTableView,page,totalresult,pagesize,df;

-(void)pushToMainPage:(int)tag title:(NSString *)str
{
    self.title =str;
    self.reportid=[NSString stringWithFormat:@"%d",tag];
    [self initDataSource];
}

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
    
    self.dataSource = [[NSMutableArray alloc] init];
   LeftMenuViewController *viewc= (LeftMenuViewController *)self.mm_drawerController.leftDrawerViewController;
    viewc.leftMenudelegate=self;
    //初始化tableview
    [self initParmeter];
    [self initView];
    [self initDataSource];
    for (UIView *view in self.mySearch.subviews){
        if ([view isKindOfClass: [UITextField class]]) {
             df = (UITextField *)view;
            df.delegate = self;
            break;
        }
    }
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
    [self.mySearch setBackgroundImage:[UIImage imageNamed:@"searchbg"]];
    [self.mySearch setDelegate:self];
    if (self.myTableView) {
        [self.myTableView setBackgroundView:nil];
        [self.myTableView setBackgroundColor:[UIColor clearColor]];
    }
    //去掉分割线
    [self.myTableView setSeparatorColor:[UIColor clearColor]];
//    
//    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.navigationController.navigationBar addGestureRecognizer:singleTouch];

}
-(void) initParmeter{
    myTableView =  [[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, 320, 420+(iPhone5?88:0))];
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    [self.view addSubview:self.myTableView];
    myTableView.tableFooterView.hidden=YES;
    page=1;
    totalresult=0;
    pagesize=10;
    self.isfirst=YES;
}

-(void)initDataSource
{
   
    NSString *url=ReportPath;
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: [NSString stringWithFormat:@"%d",page] forKey:@"index"];
    [dictionary setValue: [NSString stringWithFormat:@"%d",pagesize] forKey:@"pageNumber"];
    
    if(self.reportid==nil|| [self.reportid isEqualToString:@"0"]||[self.reportid isEqualToString:@""])
    {
        url=AllReportPath;
        
        NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
        User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        
        NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
        [dictionary setValue: userid forKey:@"userId"];
    }
    else
    {
        [dictionary setValue:self.reportid forKey:@"repTypeId"];
        url=ReportPath;
    }
   
    [self getreportList:url parmeter:dictionary];
}
//获取报告列表
-(void)getreportList:(NSString *)url parmeter:(NSMutableDictionary *)dictionary
{
    
    [self showLoadingActivityViewWithString:@"数据加载中"];
    [[requestServiceHelper defaultService]getReportList:url parmeter:dictionary sucess:^(NSMutableArray *reportDictionary, NSInteger result) {
        totalresult =result;
         myTableView.tableFooterView.hidden=NO;
        [self hideLoadingActivityView];
        if (totalresult > 0) {
            
            if (page == 1) {
                [self.dataSource removeAllObjects];
            }
            
            [self.dataSource addObjectsFromArray:reportDictionary];
            [myTableView reloadData:YES];
        }else {
            [myTableView reloadData:NO];
            return;
        }
        
        [self performSelectorOnMainThread:@selector(isOver) withObject:nil waitUntilDone:NO];

        
    } falid:^(NSString *errorMsg) {
        [self hideLoadingActivityView];
    }];
    
    
}
#pragma mark - Table view data source
-(void)initCustomTableCell:(CustomMainViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
        //内容摘要
        if (cell.contextLabel==nil) {
            cell.contextLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 180, 49)];
            cell.contextLabel.text=[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"reportTitle"];
            //[cell.contextLabel setTextAlignment:NSTextAlignmentLeft];
            [cell.contextLabel setTextAlignment:NSTextAlignmentLeft];
            [cell.contextLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contextLabel setNumberOfLines:2];
            [cell addSubview:cell.contextLabel];
        }
        //评论
        if (cell.countLabel==nil) {
            cell.countLabel=[[UILabel alloc] init];
            [cell.countLabel setFrame:CGRectMake(120, 68, 80, 21)];
            cell.countLabel.text=[[@"评论" stringByAppendingString:[[self.dataSource  objectAtIndex:indexPath.row] objectForKey:@"commentsNumber"]]stringByAppendingString:@"条"];
            [cell.countLabel setBackgroundColor:[UIColor clearColor]];
            [cell.countLabel setTextColor:[CommonHelper hexStringToColor:@"#8D8D8E"]];
            [cell addSubview:cell.countLabel];
        }
        //内容分类
        if (cell.typeImage==nil) {
            cell.typeImage=[[UIImageView alloc] init];
            [cell.typeImage setFrame:CGRectMake(5, 55, 34, 34)];
            [cell addSubview:cell.typeImage];
            //分类图标
            NSString *type=[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"reportType"];
            if ([type isEqualToString:@"12"]){
                
                cell.typeImage.image=[UIImage imageNamed:@"type_safe"];
                
            }else if ([type isEqualToString:@"14"]) {
                cell.typeImage.image=[UIImage imageNamed:@"type2"];
            }
            else if([type isEqualToString:@"13"]){
                 cell.typeImage.image=[UIImage imageNamed:@"dstt_icon4"];
            }
//            else if([type isEqualToString:@"15"]){
//                cell.typeImage.image=[UIImage imageNamed:@"dstt_icon6"];
//            }
            else{
                cell.typeImage.image=[UIImage imageNamed:@"type_other"];
            }
        }
    NSString *picpath=[[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"picPath"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    

//    UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 190)];
//    [bgView setImage:[UIImage imageNamed:@"cell_bg.png"]];
//    cell.backgroundView=bgView;
    
    if (picpath!=NULL&&![picpath isEqualToString:@""]) {

        if([picpath rangeOfString:@","].length>0){
            NSArray *picarray=[picpath componentsSeparatedByString:@","];
            for(int i=0;i<(picarray.count>3?3:picarray.count);i++){
            UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mesImage"]];
            [image setFrame:CGRectMake(5+2*i+101.5*i, 100, 101.5, 79)];
            [image setImageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:[picarray objectAtIndex:i]]]];
                [cell addSubview:image];
            }
             [cell.countLabel setFrame:CGRectMake(215, 68, 80, 21)];
//            [cell.backgroundView setFrame:CGRectMake(0, 0, 320, 190)];
        }
        else{
        cell.contextImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mesImage"]];
        [cell.contextImage setFrame:CGRectMake(215, 10, 95, 79)];
        [cell.contextImage setImageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:picpath]]];
            [cell addSubview:cell.contextImage];
//            [cell.backgroundView setFrame:CGRectMake(0, 0, 320, 100)];
        }
    }
    else{
        [cell.countLabel setFrame:CGRectMake(215, 68, 80, 21)];
    }
}

//添加标题和脚本信息
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    int week=[comps weekday];
    NSString *weekStr;
    if(week==1)
    {
        weekStr=@"   星期天";
    }else if(week==2){
        weekStr=@"   星期一";
        
    }else if(week==3){
        weekStr=@"   星期二";
        
    }else if(week==4){
        weekStr=@"   星期三";
        
    }else if(week==5){
        weekStr=@"   星期四";
        
    }else if(week==6){
        weekStr=@"   星期五";
        
    }else if(week==7){
        weekStr=@"   星期六";
        
    }  
    return [locationString stringByAppendingString:weekStr];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataSource count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 100;//此处返回cell的高度
    NSString *picpath=[[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"picPath"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    
    if (picpath!=NULL&&![picpath isEqualToString:@""]) {
        if([picpath rangeOfString:@","].length>0){
            
            return 190;
            
        } else{
            
            return 100;
        }
        
    }else{
        return 100;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell;
        
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
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"title:%@",[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"reportTitle"]);
    NSString *reportId = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"reportId"];
      ContextDetailController *contextDetailCtrl=[[ContextDetailController alloc] initWithNibName:@"ContextDetailController" bundle:nil];
    Report *_report=[[Report alloc] init];
    _report.reportId=reportId;
    contextDetailCtrl.myReport=_report;
    [self.navigationController pushViewController:contextDetailCtrl animated:YES];
}
#pragma mark - viewWillAppear
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    //左边菜单
//    LeftMenuViewController *left = [[LeftMenuViewController alloc] init];
//    //BaseNavigationController *leftBaseNav=[[BaseNavigationController alloc] initWithRootViewController:left];
//    [self.revealSideViewController preloadViewController:left forSide:PPRevealSideDirectionLeft];
//    //右边菜单
//    RightMenuViewController *right = [[RightMenuViewController alloc] init];
//    BaseNavigationController *rightBaseNav=[[BaseNavigationController alloc] initWithRootViewController:right];
//    [self.revealSideViewController preloadViewController: rightBaseNav forSide:PPRevealSideDirectionRight];
    
//    [self.navigationController.navigationBar setHidden:NO];
    
//    if (!self.isfirst) {
//        [myTableView reloadData];
//        self.isfirst = YES;
//    }
//    self.isfirst = NO;
//    self.revealSideViewController.panInteractionsWhenClosed = 6;
//    self.revealSideViewController.tapInteractionsWhenOpened=YES;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
//- (void) showLeft
//{
//    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
//    [self dismissKeyboard];
//}
//
//- (void) showRight
//{
//    [self dismissKeyboard];
//    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionRight animated:YES];
//}

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
    [self initDataSource];
}
-(void)moreInfor{
    page = [self.dataSource count]/pagesize + 1;
    [self initDataSource];
}
-(void)isOver
{
    
    if (self.dataSource.count >= totalresult) {
        [myTableView reloadData:YES];
    }
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
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
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self dismissKeyboard];
    df.text=@"";
    return NO;
}
@end
