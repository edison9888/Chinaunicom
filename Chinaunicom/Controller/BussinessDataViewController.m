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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.nameLabel.text=_name;
    self.nameLabel.text=@"31231231231231";
    NSLog(@"aaaaaa");
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)pressPayButton:(UIButton *)sender
{
    PayViewController *viewController=[[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
    [self bottomViewanimation:viewController];
}
-(IBAction)pressMonthButton:(UIButton *)sender
{
    MonthDataViewController *viewController=[[MonthDataViewController alloc]initWithNibName:@"MonthDataViewController" bundle:nil];
    
    viewController.str=[self everyName];
    [self bottomViewanimation:viewController];
}
-(IBAction)pressYearButton:(UIButton *)sender
{
    YearDataViewController *viewController=[[YearDataViewController alloc]initWithNibName:@"YearDataViewController" bundle:nil];
    viewController.yearStr=[self everyName];
    [self bottomViewanimation:viewController];
    
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
        //        [self presentModalViewController:viewController animated:YES];
        [self presentViewController:viewController animated:YES completion:^{
            [self.bottomView setFrame:CGRectMake(0, 315, 320, self.bottomView.frame.size.height)];
            [self.bottomView setAlpha:1];
            [self.nameLabel setAlpha:1];
            [self.moneyLabel setAlpha:1];
        }];
    }];
}
-(NSString *)everyName
{
    if ([_name isEqualToString:@"实时ESS合约计划"]) {
        return @"ESS合约计划";
    }
    else if ([_name isEqualToString:@"实时ECS交易总额"])
    {
        return @"ECS交易总额";
    }
    else if ([_name isEqualToString:@"实时ECS商城订单"])
    {
        return @"ECS商城订单";
    }
    else if ([_name isEqualToString:@"实时ECS用户发展"])
    {
        return @"ECS用户发展";
    }
    return @"";
}
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
