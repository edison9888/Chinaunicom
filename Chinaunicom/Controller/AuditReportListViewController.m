//
//  AuditedReportListViewController.m
//  Chinaunicom
//
//  Created by LITK on 13-5-16.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "AuditReportListViewController.h"
#import "User.h"
#import "CustomMainViewCell.h"
#import "CellImageView.h"
#import "UIImageView+WebCache.h"
#import "ContextDetailController.h"
#import "AudiReportDetail.h"
#import "ReportTypeViewController.h"
@interface AuditReportListViewController ()
{
    NSMutableArray *dataSoure;
    int page;
    int pageSize;
    NSString *state;
    BOOL refreshing;
}
@end

@implementation AuditReportListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataSoure=[[NSMutableArray alloc]init];
        pageSize=10;
        state=@"1";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MBHUDView hudWithBody:@"加载中..." type:MBAlertViewHUDTypeDefault hidesAfter:0 show:YES];
    [self.myTableView launchRefreshing];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [self initLayout];
}
-(void)initLayout
{
    [self.senHeButton setSelected:YES];
    self.myTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 88, 320, 460-44-44-44)pullingDelegate:self ];
    [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.myTableView setSeparatorColor:[UIColor clearColor]];
    [self.myTableView setBackgroundColor:[UIColor clearColor]];
    [self.myTableView setBackgroundView:nil];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    [self.view addSubview:self.myTableView];
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
    [[requestServiceHelper defaultService] getAduitingList:dictionary sucess:^(NSMutableArray *reportDictionary, NSInteger result) {
        [MBHUDView dismissCurrentHUD];
        if ([state isEqualToString:@"1"]) {
            [_headLabel setText:[NSString stringWithFormat:@"有%d待审核信息",result]];
        }else
        {
            [_headLabel setText:[NSString stringWithFormat:@"有%d已审核信息",result]];
        }

        if (page==1) {
            [dataSoure removeAllObjects];
        }
        [dataSoure addObjectsFromArray:reportDictionary];
        if ([dataSoure count]==result) {
            [self.myTableView tableViewDidFinishedLoading];
            self.myTableView.reachedTheEnd  = YES;
            [self.myTableView reloadData];
        }else
        {
            [self.myTableView tableViewDidFinishedLoading];
            self.myTableView.reachedTheEnd  = NO;
            [self.myTableView reloadData];
        }

    } falid:^(NSString *errorMsg) {
        [MBHUDView dismissCurrentHUD];
        [self.myTableView tableViewDidFinishedLoading];
        self.myTableView.reachedTheEnd  = YES;
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
        [self initDataSource];
    }
    else
    {
        [self initDataSource];
    }
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

//- (NSDate *)pullingTableViewRefreshingFinishedDate{
//    NSDate *date=[NSDate date];
//    return date;
//}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.myTableView tableViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.myTableView tableViewDidEndDragging:scrollView];
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
    return [dataSoure count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image=[UIImage imageNamed:@"qitalei.png"];
    NSString *titleStr=[[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"title"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CGSize titleSize;
    if ([[dataSoure objectAtIndex:indexPath.row]objectForKey:@"picPath"]!=nil) {
        NSString * path=[[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"picPath"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *imageArray=[path componentsSeparatedByString:@","];
        if ([imageArray count]>1) {
            titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            return 10+titleSize.height+5 +image.size.height+5 + 80 + 30;
        }else
        {
            titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(190, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            return 10+titleSize.height+5 +image.size.height+5 +25;
        }
        
    }else
    {
        titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        return 10+titleSize.height+5 +image.size.height+5 +25;
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
    NSString *titleStr=[[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"title"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CGSize titleSize;
    NSString * path=[[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"picPath"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *imageArray=[path componentsSeparatedByString:@","];
     UIImage *aqImage=[UIImage imageNamed:@"anquanlei.png"];
    if (path!=nil) {
        
        if ([imageArray count]>1) {
            titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            cell.pinlunLabel.frame=CGRectMake(150, 10+titleSize.height+5+30+5+80+5, 160, 20);
            
            for (int i=0; i<[imageArray count]; i++) {
                
                CellImageView *imageView=[[CellImageView alloc]initWithFrame:CGRectMake((i+1)*15+i*80, 10+titleSize.height+5+40, 80, 60)];
                NSString *picPath=[[[imageArray objectAtIndex:i]stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSData *data = [picPath dataUsingEncoding: NSUTF8StringEncoding];
                NSString *content=[[NSString alloc]initWithData:data encoding:1];
                [imageView setImageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:content]]];
                [cell.contentView addSubview:imageView];
            }
            
        }else
        {
            titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(190, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            NSString *picPath=[[[imageArray objectAtIndex:0]stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            cell.tupianImageView.frame=CGRectMake(220, 7, 80, 60);
            NSData *data = [picPath dataUsingEncoding: NSUTF8StringEncoding];
            NSString *content=[[NSString alloc]initWithData:data encoding:1];
            [cell.tupianImageView setImageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:content ]]];
           
            cell.pinlunLabel.frame=CGRectMake(150, 10+titleSize.height+5+aqImage.size.height+5, 160, 20);
        }
        
    }else
    {
        titleSize=[titleStr sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        cell.pinlunLabel.frame=CGRectMake(150, 10+titleSize.height+5+aqImage.size.height+5, 160, 20);
        cell.tupianImageView.frame=CGRectMake(0, 0, 0, 0);
        cell.tupianImageView.image=nil;
    }
    cell.titleLabel.frame=CGRectMake(15, 10, titleSize.width, titleSize.height);
    cell.titleLabel.text=titleStr;
    NSString *type=[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"reportTypeId"];
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
    
    NSString *commentNum=[[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"published"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    cell.pinlunLabel.text=commentNum;
    
    if ([[dataSoure objectAtIndex:indexPath.row]objectForKey:@"picPath"]!=nil) {
        if ([imageArray count]>1) {
            cell.bgImageView.frame=CGRectMake(3, 3, 320-6, cell.pinlunLabel.frame.origin.y+cell.pinlunLabel.frame.size.height+5);
        }else
        {
            cell.bgImageView.frame=CGRectMake(3, 3, 320-6, cell.pinlunLabel.frame.origin.y+cell.pinlunLabel.frame.size.height+5);
        }
        
    }else{
        cell.bgImageView.frame=CGRectMake(3, 3, 320-6, cell.pinlunLabel.frame.origin.y+cell.pinlunLabel.frame.size.height+5);
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reportId = [[dataSoure objectAtIndex:indexPath.row] objectForKey:@"reportId"];
    if ([state isEqualToString:@"1"]) {
        AudiReportDetail *audireport=[[AudiReportDetail alloc] initWithNibName:@"AudiReportDetail" bundle:nil];
        audireport.reportId=reportId;
        [self.navigationController pushViewController:audireport animated:YES];
    }
    else{

        ContextDetailController *contextDetailCtrl=[[ContextDetailController alloc] initWithNibName:@"ContextDetailController" bundle:nil];
        contextDetailCtrl.reportId=reportId;
        [self.navigationController pushViewController:contextDetailCtrl animated:YES];
    }
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setMyTableView:nil];
    [self setSenHeButton:nil];
    [self setPassButton:nil];
    [super viewDidUnload];
}
- (IBAction)auditNews:(UIButton *)sender {
    ReportTypeViewController *pubMessage = [[ReportTypeViewController alloc]initWithNibName:@"ReportTypeViewController" bundle:nil];
    [self.navigationController pushViewController:pubMessage animated:YES];
    
}
- (IBAction)pressPassButton:(UIButton *)sender {
    [MBHUDView hudWithBody:@"加载中..." type:MBAlertViewHUDTypeDefault hidesAfter:0 show:YES];
    [self.senHeButton setSelected:NO];
    [sender setSelected:YES];
    self.titleLabel.text=@"已审核";
    state=@"2";
    [self.myTableView launchRefreshing];
}

- (IBAction)pressSenHeButton:(UIButton *)sender {
    [MBHUDView hudWithBody:@"加载中..." type:MBAlertViewHUDTypeDefault hidesAfter:0 show:YES];
    [self.passButton setSelected:NO];
    [sender setSelected:YES];
    self.titleLabel.text=@"待审核";
    state=@"1";
    [self.myTableView launchRefreshing];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
