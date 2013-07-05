//
//  FavoriteListViewController.m
//  Chinaunicom
//
//  Created by LITK on 13-5-22.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "FavoriteListViewController.h"
#import "CustomFavoriteListCell.h"
#import "User.h"
@interface FavoriteListViewController ()
{
    NSMutableArray *dataSoure;
}
@end

@implementation FavoriteListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataSoure=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [self initLayout];
    [self initDataSource];
}
#pragma mark - initLayout
-(void)initLayout
{
    [_myTabelView setBackgroundView:nil];
    [_myTabelView setBackgroundColor:[UIColor clearColor]];
    [_myTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_myTabelView setSeparatorColor:[UIColor clearColor]];
}
#pragma mark - initDataSource
-(void)initDataSource
{
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: userid forKey:@"userId"];

    [[requestServiceHelper defaultService] FavoriteList:dictionary sucess:^(NSMutableArray *commentDictionary) {
        dataSoure=commentDictionary;
        [_myTabelView reloadData];
    } falid:^(NSString *errorMsg) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [dataSoure count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title=[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"reportTitle"];
    CGSize titleSize=[title sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(250, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return 8+titleSize.height+5+20+5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CustomFavoriteListCell";
    NSLog(@"aaa=%@",dataSoure);
    CustomFavoriteListCell *cell = (CustomFavoriteListCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];//复用cell
    
    if (cell == nil) {
        cell= [[CustomFavoriteListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(CustomFavoriteListCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title=[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"reportTitle"];
    CGSize titleSize=[title sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(250, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    cell.contentTitleLabel.frame=CGRectMake(10, 8, 250, titleSize.height);
    cell.contentTitleLabel.text=title;
    
    cell.dateTimeLabel.frame=CGRectMake(10, 8+cell.contentTitleLabel.frame.size.height+5, 200, 20);
    cell.dateTimeLabel.text=[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"ftime"];
    
    cell.bgImageView.frame=CGRectMake(3, 3, 314, cell.dateTimeLabel.frame.origin.y+cell.dateTimeLabel.frame.size.height+5);
}
//
//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    NSString *reportId = [[dictionayData objectAtIndex:indexPath.row]objectForKey:@"reportId"];
//    
//    ContextDetailController *contextDetailCtrl=[[ContextDetailController alloc] init];
//    Report *_report=[[Report alloc] init];
//    _report.reportId=reportId;
////    contextDetailCtrl.myReport=_report;
//    [self.navigationController pushViewController:contextDetailCtrl animated:YES];
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        delIndex=indexPath.item;
//        NSMutableDictionary *dir=[[NSMutableDictionary alloc] init];
//        NSDictionary *fav=[dictionayData objectAtIndex:delIndex];
//        [dir setValue:[fav objectForKey:@"favoriteId"] forKey:@"favoriteId"];
//        [HttpRequestHelper asyncGetRequest:delShoucang parameter:dir requestComplete:^(NSString *responseStr) {
//            if([responseStr isEqualToString:@"success"])
//            {
//                [dictionayData removeObjectAtIndex:delIndex];
//                [self.myTabelView reloadData];
//            }
//        } requestFailed:^(NSString *errorMsg) {
//        }];
//    }
//}

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

//-(void)ShowMessage
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                    message:@"确认删除"
//                                                   delegate:self
//                                          cancelButtonTitle:@"是"
//                                          otherButtonTitles:@"否", nil];
//    [alert show];
//     alert=nil;
//}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex==0){
//    NSMutableDictionary *dir=[[NSMutableDictionary alloc] init];
//    NSDictionary *fav=[dictionayData objectAtIndex:delIndex];
//    [dir setValue:[fav objectForKey:@"favoriteId"] forKey:@"favoriteId"];
//    [HttpRequestHelper asyncGetRequest:delShoucang parameter:dir requestComplete:^(NSString *responseStr) {
//      if([responseStr isEqualToString:@"success"])
//      {
//          [dictionayData removeObjectAtIndex:delIndex];
//          [self.myTabelView reloadData];
//      }
//    } requestFailed:^(NSString *errorMsg) {
//    }];
//    }
//}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
