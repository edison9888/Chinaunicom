//
//  BussinessDataViewController.m
//  Chinaunicom
//
//  Created by rock on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "BussinessDataViewController.h"
#import "PayViewController.h"
#import "MonthDataViewController.h"
#import "YearDataViewController.h"
#import "ESSTimeViewController.h"
#import "requestServiceHelper.h"
#import "Utility.h"
@interface BussinessDataViewController ()

@end

@implementation BussinessDataViewController
@synthesize name=_name;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([_name isEqualToString:@"ESS实时看板"]) {
        NSMutableDictionary *dict= [NSMutableDictionary dictionaryWithObjectsAndKeys:@"currData",@"timeStr", nil];
        [[requestServiceHelper defaultService]getESStotleNum:dict sucess:^(NSString *str) {
            NSString *num=[Utility changeTohu:str];
            self.moneyLabel.text=num;
        } falid:^(NSString *errorMsg) {
        }];

    }else if ([_name isEqualToString:@"ESS合约计划"]){
        [[requestServiceHelper defaultService]getEsscontractNum:[NSMutableDictionary dictionary] sucess:^(NSString *str) {
            NSString *num=[Utility changeToyuan:str];
            self.moneyLabel.text=num;
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([_name isEqualToString:@"ECS交易额"]){
        [[requestServiceHelper defaultService]getEcstradeNum:[NSMutableDictionary dictionary] sucess:^(NSString *str) {
            NSString *num=[Utility changeToyuan:str];
            self.moneyLabel.text=num;
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([_name isEqualToString:@"ECS商城订单"]){
        [[requestServiceHelper defaultService]getEssstoreNum:[NSMutableDictionary dictionary] sucess:^(NSString *str) {
            NSString *num=[Utility changeToyuan:str];
            self.moneyLabel.text=num;
        } falid:^(NSString *errorMsg) {
        }];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text=_name;
    
    if ([_name isEqualToString:@"ESS实时看板"]) {
        [self.payButton setTitle:@"ESS实时趋势图" forState:UIControlStateNormal];
    }else {
        [self.payButton setTitle:[NSString stringWithFormat:@"%@实时趋势图",_name] forState:UIControlStateNormal];
    }
    
}
-(IBAction)pressPayButton:(UIButton *)sender
{
    if ([_name isEqualToString:@"ESS实时看板"])
    {
        ESSTimeViewController *viewController=[[ESSTimeViewController alloc]initWithNibName:@"ESSTimeViewController" bundle:nil];
        viewController.titleStr=@"实时ESS用户发展总数";
        [self bottomViewanimation:viewController];
    }
    else
    {
        PayViewController *viewController=[[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
        viewController.str=sender.titleLabel.text;
        [self bottomViewanimation:viewController];
    }
}
-(IBAction)pressMonthButton:(UIButton *)sender
{
    if ([_name isEqualToString:@"ESS实时看板"]) {
        
        ESSTimeViewController *viewController=[[ESSTimeViewController alloc]initWithNibName:@"ESSTimeViewController" bundle:nil];
        viewController.titleStr=@"ESS月数据总数";
        [self bottomViewanimation:viewController];
        
    }else{
        
        MonthDataViewController *viewController=[[MonthDataViewController alloc]initWithNibName:@"MonthDataViewController" bundle:nil];
        
        viewController.str=self.nameLabel.text;
        [self bottomViewanimation:viewController];
    }

}
-(IBAction)pressYearButton:(UIButton *)sender
{
    if ([_name isEqualToString:@"ESS实时看板"]) {
        
        ESSTimeViewController *viewController=[[ESSTimeViewController alloc]initWithNibName:@"ESSTimeViewController" bundle:nil];
        viewController.titleStr=@"ESS年数据总数";
        [self bottomViewanimation:viewController];
        
    }else{
        
        YearDataViewController *viewController=[[YearDataViewController alloc]initWithNibName:@"YearDataViewController" bundle:nil];
        viewController.yearStr=self.nameLabel.text;
        [self bottomViewanimation:viewController];
    }
}
-(IBAction)backToLeftMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//底部View动画 和 中间label动画
-(void)bottomViewanimation : (UIViewController *)viewController
{
    [UIView animateWithDuration:2 animations:^{
        [self.bottomView setFrame:CGRectMake(0, self.view.frame.size.height, 320, self.bottomView.frame.size.height)];
        [self.nameLabel setAlpha:0];
        [self.moneyLabel setAlpha:0];
    } completion:^(BOOL finished) {
        [self.bottomView setAlpha:0];
        //[self presentModalViewController:viewController animated:YES];
        [self presentViewController:viewController animated:YES completion:^{
            [self.bottomView setFrame:CGRectMake(0, 315, 320, self.bottomView.frame.size.height)];
            [self.bottomView setAlpha:1];
            [self.nameLabel setAlpha:1];
            [self.moneyLabel setAlpha:1];
        }];
    }];
}
//-(NSString *)everyName
//{
//     if ([_name isEqualToString:@"实时ESS合约计划"]) {
//        return @"ESS合约计划";
//    }
//    else if ([_name isEqualToString:@"实时ECS交易总额"])
//    {
//        return @"ECS交易总额";
//    }
//    else if ([_name isEqualToString:@"实时ECS商城订单"])
//    {
//        return @"ECS商城订单";
//    }
//    else if ([_name isEqualToString:@"实时ECS用户发展"])
//    {
//        return @"ECS用户发展";
//    }
//    return @"";
//}
-(void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
