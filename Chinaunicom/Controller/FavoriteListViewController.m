//
//  FavoriteListViewController.m
//  Chinaunicom
//
//  Created by LITK on 13-5-22.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "FavoriteListViewController.h"
#import "User.h"
#import "ContextDetailController.h"
#import "CustomFavoriteListCell.h"
#import "HttpRequestHelper.h"
@interface FavoriteListViewController ()
{
    NSMutableArray *dataSoure;
    CustomFavoriteListCell *currentCell;
    NSIndexPath *path;
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
    NSString *title=[[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"reportTitle"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CGSize titleSize=[title sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(250, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return 8+titleSize.height+5+20+5+3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CustomFavoriteListCell";
    CustomFavoriteListCell *cell = (CustomFavoriteListCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];//复用cell
    
    if (cell == nil) {
        cell= [[CustomFavoriteListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate=self;
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(CustomFavoriteListCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title=[[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"reportTitle"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CGSize titleSize=[title sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(250, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    cell.contentTitleLabel.frame=CGRectMake(20, 8, 250, titleSize.height);
    cell.contentTitleLabel.text=title;
    
    cell.dateTimeLabel.frame=CGRectMake(20, 8+cell.contentTitleLabel.frame.size.height+5, 200, 20);
    cell.dateTimeLabel.text=[[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"ftime"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    cell.bgImageView.frame=CGRectMake(3, 3, 314, cell.dateTimeLabel.frame.origin.y+cell.dateTimeLabel.frame.size.height+5);

}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentCell.isUnShow==YES) {
        currentCell.isUnShow=NO;
        currentCell.deleteButton.hidden=YES;
        return;
    }
    NSString *str=[[dataSoure objectAtIndex:indexPath.row]objectForKey:@"reportId"];
    ContextDetailController *contextDetailCtrl=[[ContextDetailController alloc] initWithNibName:@"ContextDetailController" bundle:nil];
    contextDetailCtrl.reportId=str;
    [self.navigationController pushViewController:contextDetailCtrl animated:YES];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    currentCell.isUnShow=NO;
    currentCell.deleteButton.hidden=YES;
}
- (void)cellDidReveal:(CustomFavoriteListCell *)cell
{
    if(currentCell!=cell){
        currentCell.isUnShow=NO;
        currentCell.deleteButton.hidden=YES;
        currentCell=cell;
    }
}
-(void)cellForIndexPath:(CustomFavoriteListCell *)cell
{
    path=[_myTabelView indexPathForCell:cell];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"确认删除"
                                                   delegate:self
                                          cancelButtonTitle:@"是"
                                          otherButtonTitles:@"否", nil];
    [alert show];

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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [MBHUDView dismissCurrentHUD];
        [MBHUDView hudWithBody:@"正在删除" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0 show:YES];
        NSMutableDictionary *dir=[[NSMutableDictionary alloc] init];
        NSDictionary *fav=[dataSoure objectAtIndex:path.row];
        [dir setValue:[fav objectForKey:@"favoriteId"] forKey:@"favoriteId"];
        [HttpRequestHelper asyncGetRequest:delShoucang parameter:dir requestComplete:^(NSString *responseStr) {
            if([responseStr isEqualToString:@"success"])
            {
                [MBHUDView dismissCurrentHUD];
                [MBHUDView hudWithBody:@"删除成功" type:MBAlertViewHUDTypeDefault hidesAfter:2 show:YES];
                [dataSoure removeObjectAtIndex:path.row];
                [_myTabelView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
                currentCell.isUnShow=NO;
            }
        } requestFailed:^(NSString *errorMsg) {
            [MBHUDView dismissCurrentHUD];
            [MBHUDView hudWithBody:@"网络不稳定" type:MBAlertViewHUDTypeDefault hidesAfter:2 show:YES];
        }];
    }
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
