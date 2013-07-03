//
//  ToolsViewController.m
//  Chinaunicom
//
//  Created by LITK on 13-5-9.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "ToolsViewController.h"

@interface ToolsViewController ()
{
    int pageNumber;
}
@end

@implementation ToolsViewController

- (id)initWithPageNumber:(NSUInteger)page
{
    if (self = [super initWithNibName:@"ToolsViewController" bundle:nil])
    {
        pageNumber = page;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //背景图片
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    
    [self initMainPageMenu:pageNumber];
}

-(void) initMainPageMenu:(NSUInteger)page
{
    if (page==0) {
        
        //安全类
        UIButton* safeButton= [UIButton buttonWithType:UIButtonTypeCustom];
        safeButton.frame = CGRectMake(20, 30, 120, 120);
        [safeButton setBackgroundImage:[UIImage imageNamed:@"main_safety"] forState:UIControlStateNormal];
        [safeButton addTarget:self action:@selector(safetyTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:safeButton];
    
        //维护
        UIButton* maintainButton= [UIButton buttonWithType:UIButtonTypeCustom];
        maintainButton.frame = CGRectMake(181, 30, 120, 120);
        [maintainButton setBackgroundImage:[UIImage imageNamed:@"main_maintain"] forState:UIControlStateNormal];
        [self.view addSubview:maintainButton];
    
        //分析
        UIButton* analysisButton= [UIButton buttonWithType:UIButtonTypeCustom];
        analysisButton.frame = CGRectMake(20, 160, 120, 120);
        [analysisButton setBackgroundImage:[UIImage imageNamed:@"main_analysis"] forState:UIControlStateNormal];
        [self.view addSubview:analysisButton];
    
        //其它
        UIButton* otherButton= [UIButton buttonWithType:UIButtonTypeCustom];
        otherButton.frame = CGRectMake(181, 160, 120, 120);
        [otherButton setBackgroundImage:[UIImage imageNamed:@"main_other"] forState:UIControlStateNormal];
        [self.view addSubview:otherButton];
    
        //交易额
        UIButton* transButton= [UIButton buttonWithType:UIButtonTypeCustom];
        transButton.frame = CGRectMake(20, 290, 120, 120);
        [transButton setBackgroundImage:[UIImage imageNamed:@"main_transaction"] forState:UIControlStateNormal];
        [self.view addSubview:transButton];
    
        //用户发展
        UIButton* userButton= [UIButton buttonWithType:UIButtonTypeCustom];
        userButton.frame = CGRectMake(181, 290, 120, 120);
        [userButton setBackgroundImage:[UIImage imageNamed:@"main_users"] forState:UIControlStateNormal];
        [self.view addSubview:userButton];
    }
    if (page==1) {
        
        //合约计划
        UIButton* contractPlanButton= [UIButton buttonWithType:UIButtonTypeCustom];
        contractPlanButton.frame = CGRectMake(20, 30, 120, 120);
        [contractPlanButton setBackgroundImage:[UIImage imageNamed:@"main_contractPlan"] forState:UIControlStateNormal];
        [contractPlanButton addTarget:self action:@selector(safetyTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:contractPlanButton];
        
        //商城订单量
        UIButton* orderQuantityButton= [UIButton buttonWithType:UIButtonTypeCustom];
        orderQuantityButton.frame = CGRectMake(181, 30, 120, 120);
        [orderQuantityButton setBackgroundImage:[UIImage imageNamed:@"main_orderQuantity"] forState:UIControlStateNormal];
        [self.view addSubview:orderQuantityButton];

    }
}

- (IBAction)safetyTouch:(id)sender {
    
//    SafetyViewController *safetyCtrl=[[SafetyViewController alloc] init];
//    
//    [self.navigationController pushViewController:safetyCtrl animated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
   
}

- (void)viewDidUnload {

    [super viewDidUnload];
}
@end
