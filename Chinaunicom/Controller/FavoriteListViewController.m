//
//  FavoriteListViewController.m
//  Chinaunicom
//
//  Created by LITK on 13-5-22.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "FavoriteListViewController.h"
#import "AppDelegate.h"
#import "SysConfig.h"
#import "User.h"
#import "requestServiceHelper.h"
#import "CustomFavoriteListCell.h"
#import "HttpRequestHelper.h"
#import "SysConfig.h"
@interface FavoriteListViewController ()

@end

@implementation FavoriteListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLayout];
    [self initDataSource];
}
#pragma mark - initLayout
-(void)initLayout
{
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
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
    //编辑
//    UIButton* editButton= [UIButton buttonWithType:UIButtonTypeCustom];
//    editButton.frame = CGRectMake(230, 8, 30, 30);
//    [editButton setBackgroundImage:[UIImage imageNamed:@"main_edit"] forState:UIControlStateNormal];
//    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
//    [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [editButton setTag:1];
//    [editButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:editButton];
//    self.navigationItem.rightBarButtonItem=item;
    
}

#pragma mark - initDataSource
-(void)initDataSource
{
    [self showLoadingActivityViewWithString:@"加载数据"];
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue: userid forKey:@"userId"];

    [[requestServiceHelper defaultService] FavoriteList:dictionary sucess:^(NSMutableArray *commentDictionary) {
        self.dictionayData=commentDictionary;
        [self performSelectorOnMainThread:@selector(isOver) withObject:nil waitUntilDone:NO];
    } falid:^(NSString *errorMsg) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}
-(IBAction)delete:(id)sender{

}
-(void)isOver
{
    
    [self.myTabelView reloadData];
    [self hideLoadingActivityView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dictionayData count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;//此处返回cell的高度
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CustomFavoriteListCell";
    
    CustomFavoriteListCell *cell = (CustomFavoriteListCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];//复用cell
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomFavoriteListCell" owner:self options:nil];//加载自定义cell的xib文件
        cell = [array objectAtIndex:0];
    }
    cell.contentTitleLabel.text=[[self.dictionayData objectAtIndex:indexPath.row]objectForKey:@"reportTitle"];
//    cell.dateTimeLabel.text=@"2013-06-05";
    cell.dateTimeLabel.text=[[self.dictionayData objectAtIndex:indexPath.row]objectForKey:@"ftime"];//[[dataArray objectAtIndex:indexPath.row] objectForKey:@"commentDate"];

    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *reportId = [[self.dictionayData objectAtIndex:indexPath.row]objectForKey:@"reportId"];
    
    ContextDetailController *contextDetailCtrl=[[ContextDetailController alloc] init];
    Report *_report=[[Report alloc] init];
    _report.reportId=reportId;
//    contextDetailCtrl.myReport=_report;
    [self.navigationController pushViewController:contextDetailCtrl animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        delIndex=indexPath.item;
        NSMutableDictionary *dir=[[NSMutableDictionary alloc] init];
        NSDictionary *fav=[self.dictionayData objectAtIndex:delIndex];
        [dir setValue:[fav objectForKey:@"favoriteId"] forKey:@"favoriteId"];
        [self showLoadingActivityViewWithString:@"正在删除"];
        [HttpRequestHelper asyncGetRequest:delShoucang parameter:dir requestComplete:^(NSString *responseStr) {
            [self hideLoadingActivityView];
            if([responseStr isEqualToString:@"success"])
            {
                [self.dictionayData removeObjectAtIndex:delIndex];
                [self.myTabelView reloadData];
            }
        } requestFailed:^(NSString *errorMsg) {

            [self hideLoadingActivityView];
        }];
    }
}

-(void)back
{
//    RightMenuViewController *right=[[RightMenuViewController alloc] init];
//    BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:right];
//    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [myDelegate.revealSideViewController pushViewController:nav onDirection:PPRevealSideDirectionRight withOffset:50 animated:YES forceToPopPush:YES completion:nil];
//     [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyTabelView:nil];
    [super viewDidUnload];
}

-(void)ShowMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"确认删除"
                                                   delegate:self
                                          cancelButtonTitle:@"是"
                                          otherButtonTitles:@"否", nil];
    [alert show];
     alert=nil;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
    NSMutableDictionary *dir=[[NSMutableDictionary alloc] init];
    NSDictionary *fav=[self.dictionayData objectAtIndex:delIndex];
    [dir setValue:[fav objectForKey:@"favoriteId"] forKey:@"favoriteId"];
    [self showLoadingActivityViewWithString:@"正在删除"];
    [HttpRequestHelper asyncGetRequest:delShoucang parameter:dir requestComplete:^(NSString *responseStr) {
        [self hideLoadingActivityView];
      if([responseStr isEqualToString:@"success"])
      {
          [self.dictionayData removeObjectAtIndex:delIndex];
          [self.myTabelView reloadData];
      }
    } requestFailed:^(NSString *errorMsg) {

            [self hideLoadingActivityView];
    }];
    }
}
@end
