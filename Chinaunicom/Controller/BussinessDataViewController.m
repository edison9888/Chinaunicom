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
#import "CommonHelper.h"
#import "UIViewController+MMDrawerController.h"
@interface BussinessDataViewController ()
{
     NSTimer *myTimer;
}
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
    
    myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFire:) userInfo:nil repeats:YES];
    [myTimer fire];
}
-(void)timeFire : (NSTimer *)timer
{
    if ([_name isEqualToString:@"ESS实时看板"]) {
        NSMutableDictionary *dict= [NSMutableDictionary dictionaryWithObjectsAndKeys:@"currData",@"timeStr", nil];
        [[requestServiceHelper defaultService]getESStotleNum:dict sucess:^(NSString *str) {
//            NSString *num=[Utility changeTohu:str];
            self.moneyLabel.text=[NSString stringWithFormat:@"%@户",str];
        } falid:^(NSString *errorMsg) {
        }];
        
    }else if ([_name isEqualToString:@"ESS合约计划"]){
        [[requestServiceHelper defaultService]getEsscontractNum:[NSMutableDictionary dictionary] sucess:^(NSString *str) {
//            NSString *num=[Utility changeTohu:str];
            self.moneyLabel.text=[NSString stringWithFormat:@"%@户",str];
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([_name isEqualToString:@"ECS交易额"]){
        [[requestServiceHelper defaultService]getEcstradeNum:[NSMutableDictionary dictionary] sucess:^(NSString *str) {
//            NSString *num=[Utility changeToyuan:str];
            self.moneyLabel.text=[NSString stringWithFormat:@"%@元",str];
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([_name isEqualToString:@"ECS商城订单"]){
        [[requestServiceHelper defaultService]getEssstoreNum:[NSMutableDictionary dictionary] sucess:^(NSString *str) {
            NSString *num=[Utility changeTobi:str];
            self.moneyLabel.text=num;
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([_name isEqualToString:@"ECS用户发展"]){
        [[requestServiceHelper defaultService]getEssGuessNum:[NSMutableDictionary dictionary] sucess:^(NSString *str) {
            NSString *num=[Utility changeTohu:str];
            self.moneyLabel.text=num;
        } falid:^(NSString *errorMsg) {
        }];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameLabel.text=_name;
    [self.moneyLabel setTextColor:[CommonHelper hexStringToColor:@"74d4fa"]];
    if ([_name isEqualToString:@"ESS实时看板"]) {
        [self.payButton setTitle:@"ESS实时数据趋势图" forState:UIControlStateNormal];
        [self.monthButton setTitle:@"ESS月数据趋势图" forState:UIControlStateNormal];
        [self.yearButton setTitle:@"ESS年数据趋势图" forState:UIControlStateNormal];
    }else {
        [self.payButton setTitle:[NSString stringWithFormat:@"%@整点趋势图",_name] forState:UIControlStateNormal];
        [self.monthButton setTitle:[NSString stringWithFormat:@"%@月数据趋势图",_name] forState:UIControlStateNormal];
        [self.yearButton setTitle:[NSString stringWithFormat:@"%@年数据趋势图",_name] forState:UIControlStateNormal];
        if ([_name isEqualToString:@"ECS用户发展"]) {
            self.qianImageView.hidden=YES;
            self.backImageView.hidden=NO;
            [self.payButton setHidden:YES];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [myTimer invalidate];
}
-(IBAction)pressPayButton:(UIButton *)sender
{
    if ([_name isEqualToString:@"ESS实时看板"])
    {
        ESSTimeViewController *viewController=[[ESSTimeViewController alloc]initWithNibName:@"ESSTimeViewController" bundle:nil];
        viewController.titleStr=sender.titleLabel.text;
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
        viewController.titleStr=sender.titleLabel.text;
        [self bottomViewanimation:viewController];
        
    }else{
        
        MonthDataViewController *viewController=[[MonthDataViewController alloc]initWithNibName:@"MonthDataViewController" bundle:nil];
        
        viewController.str=sender.titleLabel.text;
        [self bottomViewanimation:viewController];
    }

}
-(IBAction)pressYearButton:(UIButton *)sender
{
    if ([_name isEqualToString:@"ESS实时看板"]) {
        
        ESSTimeViewController *viewController=[[ESSTimeViewController alloc]initWithNibName:@"ESSTimeViewController" bundle:nil];
        viewController.titleStr=sender.titleLabel.text;
        [self bottomViewanimation:viewController];
        
    }else{
        
        YearDataViewController *viewController=[[YearDataViewController alloc]initWithNibName:@"YearDataViewController" bundle:nil];
        viewController.yearStr=sender.titleLabel.text;
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
    [UIView animateWithDuration:0.5 animations:^{
        [self.bottomView setFrame:CGRectMake(0, self.view.frame.size.height, 320, self.bottomView.frame.size.height)];
        [self.nameLabel setAlpha:0];
        [self.moneyLabel setAlpha:0];
    } completion:^(BOOL finished) {
        [self.bottomView setAlpha:0];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:viewController];
        nav.navigationBarHidden=YES;
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            [self.navigationController presentViewController:nav animated:YES completion:^{
                [self.bottomView setFrame:CGRectMake(0, 315, 320, self.bottomView.frame.size.height)];
                [self.bottomView setAlpha:1];
                [self.nameLabel setAlpha:1];
                [self.moneyLabel setAlpha:1];
                
            }];
        }else{
            [self.navigationController presentModalViewController:nav animated:YES];
            [self.bottomView setFrame:CGRectMake(0, 315, 320, self.bottomView.frame.size.height)];
            [self.bottomView setAlpha:1];
            [self.nameLabel setAlpha:1];
            [self.moneyLabel setAlpha:1];
        }
    }];
}
-(void)viewDidUnload
{
    [self setBackImageView:nil];
    [self setQianImageView:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
