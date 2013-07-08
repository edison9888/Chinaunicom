//
//  LeftMenuViewController.m
//  Chinaunicom
//
//  Created by rock on 13-7-8.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MainViewController.h"
#import "BussinessDataViewController.h"
#import "User.h"
#import "requestServiceHelper.h"
#import "testLabel.h"
@interface LeftMenuViewController ()
{
    NSMutableArray *topArray;
    NSMutableArray *topBtArray;
    NSMutableArray *topFirstArray;
    NSMutableArray *topPicArray;
    NSMutableArray *topLaterBtArray;
    NSMutableArray *topLaterPicArray;
    
}
@end

@implementation LeftMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        topArray=[[NSMutableArray alloc]init];
        topFirstArray=[[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBHUDView hudWithBody:@"正在加载" type:MBAlertViewHUDTypeDefault hidesAfter:0 show:YES];
    [self initTopBt];
    [self initLayOut];
    [self getDataSoure];
    // Do any additional setup after loading the view from its nib.
}
-(void)initTopBt
{
    UIImage *image1=[UIImage imageNamed:@"12.png"];
    UIImage *image2=[UIImage imageNamed:@"13.png"];
    UIImage *image3=[UIImage imageNamed:@"14.png"];
    UIImage *image4=[UIImage imageNamed:@"15.png"];
    topBtArray = [[NSMutableArray alloc]initWithObjects:_b2,_b3,_b4,_b5, nil];
//    topPicArray=[[NSMutableArray alloc]initWithObjects:@"12",@"13"@"14",@"15", nil];
    topLaterBtArray = [[NSMutableArray alloc]initWithObjects:_b2,_b3,_b4,_b5, nil];
    topLaterPicArray=[[NSMutableArray alloc]initWithObjects:image1,image2,image3,image4, nil];
}
-(void)initLayOut
{
    [_editButton setImage:[UIImage imageNamed:@"Createwrite.png"] forState:UIControlStateNormal];
    [_editButton setImage:nil forState:UIControlStateSelected];
    [_editButton setTitle:nil forState:UIControlStateNormal];
    [_editButton setTitle:@"完成" forState:UIControlStateSelected];
}
-(void)getDataSoure
{
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    [self getReportType:[NSString stringWithFormat:@"%d",[user.userId intValue]]];
}
//获取我已关注的菜单分类
-(void)getReportType:(NSString*)userId
{
    [[requestServiceHelper defaultService] getMyMenuReportType:userId sucess:^(NSArray *array) {
        NSLog(@"array=%@",array);
        
        [MBHUDView dismissCurrentHUD];
        [topArray addObjectsFromArray:array];
        for (int i=0; i<[topArray count]; i++) {
            //获取哪张图片
          NSString *str=  [[topArray objectAtIndex:i]objectForKey:@"reportTypeId"];
            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",str]];
            //依次填入按钮
           UIButton *bt =[topBtArray objectAtIndex:i];
            bt.titleLabel.text=str;
            [bt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",str]] forState:UIControlStateNormal];
            [bt setEnabled:YES];
            [topFirstArray addObject:bt];
            //获得剩下的按钮跟图片
            [topLaterBtArray removeObject:bt];
            [topLaterPicArray removeObject:image];
        }
        
    } falid:^(NSString *errorMsg) {
        [MBHUDView dismissCurrentHUD];
        [MBHUDView hudWithBody:@"网络不稳定" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)b1:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        UINavigationController *nav= (UINavigationController *)self.mm_drawerController.centerViewController;
        MainViewController *main=(MainViewController *)[nav topViewController];
        [main reloadSource :10];
    }];

}

- (IBAction)b2:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        UINavigationController *nav= (UINavigationController *)self.mm_drawerController.centerViewController;
        MainViewController *main=(MainViewController *)[nav topViewController];
        [main reloadSource :12];
    }];
}

- (IBAction)b3:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        UINavigationController *nav= (UINavigationController *)self.mm_drawerController.centerViewController;
        MainViewController *main=(MainViewController *)[nav topViewController];
        [main reloadSource :14];
    }];
}

- (IBAction)b4:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        UINavigationController *nav= (UINavigationController *)self.mm_drawerController.centerViewController;
        MainViewController *main=(MainViewController *)[nav topViewController];
        [main reloadSource :13];
    }];
}

- (IBAction)b5:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        UINavigationController *nav= (UINavigationController *)self.mm_drawerController.centerViewController;
        MainViewController *main=(MainViewController *)[nav topViewController];
        [main reloadSource :15];
    }];
}

- (IBAction)b6:(UIButton *)sender {
    BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
    bd.name=@"ESS实时看板";
    [self.navigationController pushViewController:bd animated:YES];
}

- (IBAction)b7:(UIButton *)sender {
    BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
    bd.name=@"ESS合约计划";
    [self.navigationController pushViewController:bd animated:YES];
}

- (IBAction)b8:(UIButton *)sender {
    BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
    bd.name=@"ECS交易额";
    [self.navigationController pushViewController:bd animated:YES];
}

- (IBAction)b9:(id)sender {
    BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
    bd.name=@"ECS商城订单";
    [self.navigationController pushViewController:bd animated:YES];
}

- (IBAction)b10:(UIButton *)sender {
    BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
    bd.name=@"ECS用户发展";
    [self.navigationController pushViewController:bd animated:YES];
}
-(void)pushView:(UIButton *)sender
{
    
}
- (void)viewDidUnload {
    [self setEditButton:nil];
    [self setB1:nil];
    [self setB2:nil];
    [self setB3:nil];
    [self setB4:nil];
    [self setB5:nil];
    [super viewDidUnload];
}
- (IBAction)pressEditButton:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (sender.selected) {
        [_b1 setEnabled:NO];
        for (int i=0; i<[topFirstArray count]; i++) {
            UIButton *bt=[topFirstArray objectAtIndex:i];
            NSString *str=  [[topArray objectAtIndex:i]objectForKey:@"reportTypeId"];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateSelected];
            [button setFrame:CGRectMake(40, 0, 40, 40)];
            [bt removeTarget:self action:@selector(pushView:) forControlEvents:UIControlEventTouchUpInside];
            [bt addTarget:self action:@selector(pressAddBt:) forControlEvents:UIControlEventTouchUpInside];
            [bt setEnabled:YES];
            
            bt.tag=[str intValue];
            NSLog(@"bt.ta=%d",bt.tag);
            [bt addSubview:button];
        }
        NSLog(@"aaaaa=%@",topLaterBtArray);
        NSLog(@"bbbbb=%@",topLaterPicArray);
        for (int i=0; i<[topLaterBtArray count]; i++) {
          UIButton *bt= [topLaterBtArray objectAtIndex:i];
            UIImage *str=[topLaterPicArray objectAtIndex:i];
            [bt setBackgroundImage:str forState:UIControlStateDisabled];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateSelected];
            [button setFrame:CGRectMake(40, 0, 40, 40)];
            [button setSelected:YES];
            [bt removeTarget:self action:@selector(pushView:) forControlEvents:UIControlEventTouchUpInside];
            [bt addTarget:self action:@selector(pressAddBt:) forControlEvents:UIControlEventTouchUpInside];
            [bt setEnabled:YES];
            NSLog(@"bt.ta=%d",bt.tag);
            [bt addSubview:button];

        
        }

    }else
    {
        for (int i=0; i<[topBtArray count]; i++) {
            UIButton *bt=[topBtArray objectAtIndex:i];
        }
        
    }
}
-(void)pressAddBt:(UIButton *)sender
{
    [MBHUDView hudWithBody:@"请求中..." type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
    sender.selected=!sender.selected;
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] init];
    [dictionary setValue:userid forKey:@"userId"];
    [dictionary setValue:[NSString stringWithFormat:@"%d",sender.tag] forKey:@"repTypeId"];
    if (sender.selected) {

        [[requestServiceHelper defaultService]opreateReportType:DeleteReportType paramter:dictionary sucess:^(BOOL isSucess) {
            [MBHUDView hudWithBody:@"删除成功" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
            
        } falid:^(NSString *errorMsg) {
            
        }];

    }else
    {
        [[requestServiceHelper defaultService]opreateReportType:AddReportType paramter:dictionary sucess:^(BOOL isSucess) {
            [MBHUDView hudWithBody:@"添加成功" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
        } falid:^(NSString *errorMsg) {
            
        }];
    }
}
@end
