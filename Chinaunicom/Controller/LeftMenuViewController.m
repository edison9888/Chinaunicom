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
#import "LeftButoon.h"
#import "BottomButton.h"
@interface LeftMenuViewController ()
{
    NSMutableArray *topArray;
    NSMutableArray *topBtArray;
    NSMutableArray *topLaterPicArray;
    
    NSMutableArray *bottomArray;
    NSMutableArray *bottomBtArray;
    NSMutableArray *bottomLaterPicArray;
    
    NSMutableArray *adminTopArray;
    NSMutableArray *adminBottomArray;
}
@end

@implementation LeftMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        topArray=[[NSMutableArray alloc]initWithCapacity:4];
        bottomArray=[[NSMutableArray alloc]initWithCapacity:5];
        adminTopArray=[[NSMutableArray alloc]init];
        adminBottomArray=[[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getAdmin];
}
-(void)getAdmin
{
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    
    [[requestServiceHelper defaultService] getAllReportType:userid sucess:^(NSArray *array) {
        for (int i=0; i<[array count]; i++) {
            NSString *string=[[array objectAtIndex:i]objectForKey:@"reportTypeId"];
            if ([string intValue]<100) {
                [adminTopArray addObject:[NSNumber numberWithInt:[string intValue]]];
            }else
            {
               [adminBottomArray addObject:[NSNumber numberWithInt:[string intValue]]];
            }
        }
        [self initTopBt];
        [self initLayOut];
        [self getDataSoure];
    } falid:^(NSString *errorMsg) {
        
    }];

}
-(void)initTopBt
{
    topBtArray = [[NSMutableArray alloc]initWithObjects:_b2,_b3,_b4,_b5, nil];
    bottomBtArray = [[NSMutableArray alloc]initWithObjects:_b6,_b7,_b8,_b9,_b10, nil];
    
}
-(void)initLayOut
{
    [_editButton setImage:[UIImage imageNamed:@"Createwrite.png"] forState:UIControlStateNormal];
    [_editButton setImage:[UIImage imageNamed:@"wancheng.png"] forState:UIControlStateSelected];
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
        [topArray removeAllObjects];
        [bottomArray removeAllObjects];
        for (int s=0; s<[array count]; s++) {
            
            int num=[[[array objectAtIndex:s] objectForKey:@"reportTypeId"] intValue];
            
            if (num<18) {
                
                [topArray addObject:[NSString stringWithFormat:@"%d",num]];
            }else
            {
                [bottomArray addObject:[NSString stringWithFormat:@"%d",num]];
            }
        }
        /********************************************上面按钮******************************************/
        topLaterPicArray =[[NSMutableArray alloc]initWithArray:adminTopArray];
        
        for (int i=0; i<[topArray count]; i++) {
            LeftButoon *bt =[topBtArray objectAtIndex:i];
            //获取哪张图片
            NSString *str=  [topArray objectAtIndex:i];
            bt.iamgeStr=str;
            for (int y = 0; y<[topLaterPicArray count]; y++) {
                NSNumber *picString=[topLaterPicArray objectAtIndex:y];
                if ([picString intValue] == [str intValue]) {
                    [topLaterPicArray removeObject:picString];
                    break;
                }
            }
            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",str]];
            //依次填入按钮
            [bt setBackgroundImage:image forState:UIControlStateNormal];
            bt.GuangZhu=YES;
            bt.enabled=YES;
        }
        _b1.enabled=YES;
         /********************************************上面按钮******************************************/
         /********************************************下面按钮******************************************/
        bottomLaterPicArray=[[NSMutableArray alloc]initWithArray:adminBottomArray];
        for (int i=0; i<[bottomArray count]; i++) {
            BottomButton *bt =[bottomBtArray objectAtIndex:i];
            //获取哪张图片
            NSString *str=  [bottomArray objectAtIndex:i];
            bt.iamgeStr=str;
            for (int y = 0; y<[bottomLaterPicArray count]; y++) {
                NSNumber *picString=[bottomLaterPicArray objectAtIndex:y];
                if ([picString intValue] == [str intValue]) {
                    [bottomLaterPicArray removeObject:picString];
                    break;
                }
            }
            UIImage *Bottomimage=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",str]];
            //依次填入按钮
            [bt setBackgroundImage:Bottomimage forState:UIControlStateNormal];
            bt.GuangZhu=YES;
            bt.enabled=YES;
        }

         /********************************************下面按钮******************************************/
     [MBHUDView dismissCurrentHUD];
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

- (IBAction)pressAll:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        UINavigationController *nav= (UINavigationController *)self.mm_drawerController.centerViewController;
        MainViewController *main=(MainViewController *)[nav topViewController];
        [main reloadSource :10];
    }];

}

-(IBAction)pushView:(id)sender
{
    UIButton *button=(UIButton *)sender;
    if ([button isMemberOfClass:[LeftButoon class]]) {
        LeftButoon *leftBt=(LeftButoon *)button;
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            UINavigationController *nav= (UINavigationController *)self.mm_drawerController.centerViewController;
            MainViewController *main=(MainViewController *)[nav topViewController];
            [main reloadSource :[leftBt.iamgeStr intValue]];
        }];
    }else
    {
        BottomButton *bt=(BottomButton *)button;
        BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
        if ([bt.iamgeStr intValue]==141) {
            
            bd.name=@"ESS实时看板";
            
        }else if ([bt.iamgeStr intValue]==142)
        {
            bd.name=@"ESS合约计划";
           
        }else if ([bt.iamgeStr intValue]==145)
        {
            bd.name=@"ECS交易额";
            
        }else if ([bt.iamgeStr intValue]==144)
        {
            bd.name=@"ECS商城订单";
        }else
        {
            bd.name=@"ECS用户发展";
        }
        [self.navigationController pushViewController:bd animated:YES];
    }
    

}
- (void)viewDidUnload {
    [self setEditButton:nil];
    [self setB1:nil];
    [self setB2:nil];
    [self setB3:nil];
    [self setB4:nil];
    [self setB5:nil];
    [self setB6:nil];
    [self setB7:nil];
    [self setB8:nil];
    [self setB9:nil];
    [self setB10:nil];
    [super viewDidUnload];
}
- (IBAction)pressEditButton:(UIButton *)sender {
    
    sender.selected=!sender.selected;
    if (sender.selected) {
        /********************************************上面按钮******************************************/
        [_b1 setEnabled:NO];
        for (int i= 0; i<[adminTopArray count]; i++) {
            LeftButoon *bt=[topBtArray objectAtIndex:i];
            bt.enabled=YES;
            
            UIImageView *addImage=[[UIImageView alloc]init];
            addImage.frame=CGRectMake(50, 0, 30, 30);
            addImage.tag=100;
            [bt addSubview:addImage];
            if (bt.GuangZhu==YES) {
                [addImage setImage:[UIImage imageNamed:@"delete.png"]];
            }else
            {
                 [addImage setImage:[UIImage imageNamed:@"plus.png"]];
            }
            [bt removeTarget:self action:@selector(pushView:) forControlEvents:UIControlEventTouchUpInside];
            [bt addTarget:self action:@selector(pressAddBt:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        for (int x=0; x<[topLaterPicArray count]; x++) {
            LeftButoon *bt=[topBtArray objectAtIndex:[topArray count]+x];
            NSNumber *str=[topLaterPicArray objectAtIndex:x];
            bt.iamgeStr=[NSString stringWithFormat:@"%d",[str intValue]];
            [bt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",str]] forState:UIControlStateNormal];
        }
        /********************************************上面按钮******************************************/
        /********************************************下面按钮******************************************/
        for (int i= 0; i<[adminBottomArray count]; i++) {
            BottomButton *bt=[bottomBtArray objectAtIndex:i];
            bt.enabled=YES;
            UIImageView *addImage=[[UIImageView alloc]init];
            addImage.frame=CGRectMake(50, 0, 30, 30);
            addImage.tag=100;
            [bt addSubview:addImage];
            if (bt.GuangZhu==YES) {
                [addImage setImage:[UIImage imageNamed:@"delete.png"]];
            }else
            {
                [addImage setImage:[UIImage imageNamed:@"plus.png"]];
            }
            [bt removeTarget:self action:@selector(pushView:) forControlEvents:UIControlEventTouchUpInside];
            [bt addTarget:self action:@selector(pressBottomAddBt:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        for (int x=0; x<[bottomLaterPicArray count]; x++) {
            BottomButton *bt=[bottomBtArray objectAtIndex:[bottomArray count]+x];
            NSNumber *str=[bottomLaterPicArray objectAtIndex:x];
            bt.iamgeStr=[NSString stringWithFormat:@"%d",[str intValue]];
            [bt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",str]] forState:UIControlStateNormal];
        }
        /********************************************下面按钮******************************************/
    }else
    {
        [MBHUDView dismissCurrentHUD];
        [MBHUDView hudWithBody:@"请稍等..." type:MBAlertViewHUDTypeDefault hidesAfter:0 show:YES];
        /********************************************上面按钮******************************************/
        [_b1 setEnabled:YES];
        for (int i=0; i<[topBtArray count]; i++) {
            LeftButoon *bt=[topBtArray objectAtIndex:i];
            [bt setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [bt setEnabled:NO];
            bt.GuangZhu=NO;
            [bt removeTarget:self action:@selector(pressAddBt:) forControlEvents:UIControlEventTouchUpInside];
            [bt addTarget:self action:@selector(pushView:) forControlEvents:UIControlEventTouchUpInside];
            for (UIView *view in bt.subviews) {
                if ([view isKindOfClass:[UIImageView class]]&& view.tag==100) {
                    [view removeFromSuperview];
                }
            }
        }
        /********************************************上面按钮******************************************/
        /********************************************下面按钮******************************************/
        for (int i=0; i<[bottomBtArray count]; i++) {
            BottomButton *bt=[bottomBtArray objectAtIndex:i];
            [bt setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [bt setEnabled:NO];
            bt.GuangZhu=NO;
            [bt removeTarget:self action:@selector(pressBottomAddBt:) forControlEvents:UIControlEventTouchUpInside];
            [bt addTarget:self action:@selector(pushView:) forControlEvents:UIControlEventTouchUpInside];
            for (UIView *view in bt.subviews) {
                if ([view isKindOfClass:[UIImageView class]]&& view.tag==100) {
                    [view removeFromSuperview];
                }
            }
        }
        /********************************************下面按钮******************************************/
        NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
        User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        [self getReportType:[NSString stringWithFormat:@"%d",[user.userId intValue]]];
    }
}
-(void)pressAddBt:(LeftButoon *)sender
{
    [MBHUDView dismissCurrentHUD];
    [MBHUDView hudWithBody:@"请求中..." type:MBAlertViewHUDTypeDefault hidesAfter:0 show:YES];
    sender.selected=!sender.selected;
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] init];
    [dictionary setValue:userid forKey:@"userId"];
    [dictionary setValue:sender.iamgeStr forKey:@"repTypeId"];
    if (sender.GuangZhu==YES) {

        [[requestServiceHelper defaultService]opreateReportType:DeleteReportType paramter:dictionary sucess:^(BOOL isSucess) {

            sender.GuangZhu=NO;
            for (UIView *view in sender.subviews) {
                if ([view isKindOfClass:[UIImageView class]]&& view.tag==100) {
                    UIImageView *imageview=(UIImageView *)view;
                    [imageview setImage:[UIImage imageNamed:@"plus.png"]];
                }
            }
            [MBHUDView dismissCurrentHUD];
            [MBHUDView hudWithBody:@"删除成功" type:MBAlertViewHUDTypeDefault hidesAfter:0.5 show:YES];
        } falid:^(NSString *errorMsg) {
            [MBHUDView dismissCurrentHUD];
        }];
    }else
    {
        [[requestServiceHelper defaultService]opreateReportType:AddReportType paramter:dictionary sucess:^(BOOL isSucess) {
            [MBHUDView dismissCurrentHUD];
            [MBHUDView hudWithBody:@"添加成功" type:MBAlertViewHUDTypeDefault hidesAfter:0.5 show:YES];
            sender.GuangZhu=YES;
            for (UIView *view in sender.subviews) {
                if ([view isKindOfClass:[UIImageView class]]&& view.tag==100) {
                    UIImageView *imageview=(UIImageView *)view;
                    [imageview setImage:[UIImage imageNamed:@"delete.png"]];
                }
            }
        } falid:^(NSString *errorMsg) {
            [MBHUDView dismissCurrentHUD];
        }];
    }
}
-(void)pressBottomAddBt:(BottomButton *)sender
{
    [MBHUDView dismissCurrentHUD];
    [MBHUDView hudWithBody:@"请求中..." type:MBAlertViewHUDTypeDefault hidesAfter:0 show:YES];
    sender.selected=!sender.selected;
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] init];
    [dictionary setValue:userid forKey:@"userId"];
    [dictionary setValue:sender.iamgeStr forKey:@"repTypeId"];
    if (sender.GuangZhu==YES) {
        
        [[requestServiceHelper defaultService]opreateReportType:DeleteReportType paramter:dictionary sucess:^(BOOL isSucess) {
            sender.GuangZhu=NO;
            for (UIView *view in sender.subviews) {
                if ([view isKindOfClass:[UIImageView class]]&& view.tag==100) {
                    UIImageView *imageview=(UIImageView *)view;
                    [imageview setImage:[UIImage imageNamed:@"plus.png"]];
                }
            }
            [MBHUDView dismissCurrentHUD];
            [MBHUDView hudWithBody:@"删除成功" type:MBAlertViewHUDTypeDefault hidesAfter:0.5 show:YES];
        } falid:^(NSString *errorMsg) {
            [MBHUDView dismissCurrentHUD];
        }];
        
    }else
    {
        [[requestServiceHelper defaultService]opreateReportType:AddReportType paramter:dictionary sucess:^(BOOL isSucess) {
            sender.GuangZhu=YES;
            for (UIView *view in sender.subviews) {
                if ([view isKindOfClass:[UIImageView class]]&& view.tag==100) {
                    UIImageView *imageview=(UIImageView *)view;
                    [imageview setImage:[UIImage imageNamed:@"delete.png"]];
                }
            }
            [MBHUDView dismissCurrentHUD];
            [MBHUDView hudWithBody:@"添加成功" type:MBAlertViewHUDTypeDefault hidesAfter:0.5 show:YES];
        } falid:^(NSString *errorMsg) {
            [MBHUDView dismissCurrentHUD];
        }];
    }
}

@end
