//
//  MonthDataViewController.m
//  Chinaunicom
//
//  Created by YY on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "MonthDataViewController.h"
#import "requestServiceHelper.h"
#import "Utility.h"
#import "TimeViewController.h"
@interface MonthDataViewController ()

@end

@implementation MonthDataViewController
@synthesize str=_str;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//获取月数据
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *url=@"";
    if ([_str isEqualToString:@"ESS合约计划月数据趋势图"])
    {
        url=GET_ESS_MONTHDATA;
    }else if ([_str isEqualToString:@"ECS交易额月数据趋势图"])
    {
        url=GET_ECS_MONTHDATA;
    }else if ([_str isEqualToString:@"ECS商城订单月数据趋势图"])
    {
        url=GET_STORE_MONTHDATA;
    }else if ([_str isEqualToString:@"ECS用户发展月数据趋势图"])
    {
        url=GET_GUESS_MONTHDATA;
    }
    //本月数据
    NSMutableDictionary *tMonthDict=[NSMutableDictionary dictionaryWithObject:@"currMonth" forKey:@"timeStr"];
    [[requestServiceHelper defaultService]getEssMonthData:tMonthDict url:url  sucess:^(NSDictionary *nsdict) {
        
        NSArray *array=[self sortByKeys:nsdict];
        NSString *string=[array objectAtIndex:0];
        if (string.length==8) {
           NSString *monthString= [string substringWithRange:NSMakeRange(4, 2)];
           NSString *dateString= [string substringWithRange:NSMakeRange(6, 2)];
            NSString *money=[nsdict objectForKey:[array objectAtIndex:0]];
            NSString *changeMoney=[Utility changeToyuan:money];
            self.bMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
        }
        //本月总数
        self.monthNumLabel.text=[NSString stringWithFormat:@"1000.23户"];
        
    } falid:^(NSString *errorMsg) {
    }];
    
    //上月数据
    NSMutableDictionary *sMonthDict=[NSMutableDictionary dictionaryWithObject:@"prevMonth" forKey:@"timeStr"];
    [[requestServiceHelper defaultService]getEssMonthData:sMonthDict url:url sucess:^(NSDictionary *nsdict) {
        NSArray *array=[self sortByKeys:nsdict];
        NSString *string=[array objectAtIndex:0];
        if (string.length==8) {
            NSString *monthString= [string substringWithRange:NSMakeRange(4, 2)];
            NSString *dateString= [string substringWithRange:NSMakeRange(6, 2)];
            NSString *money=[nsdict objectForKey:[array objectAtIndex:0]];
            NSString *changeMoney=[Utility changeToyuan:money];
            self.sMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
        }
    } falid:^(NSString *errorMsg) {
    }];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([_str isEqualToString:@"ECS交易额月数据趋势图"])
    {
        self.monthLabel.text=@"ECS交易额月数据总数";
        
    }else if ([_str isEqualToString:@"ESS合约计划月数据趋势图"])
    {
        self.monthLabel.text=@"ESS合约计划月数据总数";
        
    }else if ([_str isEqualToString:@"ECS商城订单月数据趋势图"])
    {
        self.monthLabel.text=@"ECS商城订单月数据总数";
        
    }else if ([_str isEqualToString:@"ECS用户发展月数据趋势图"])
    {
        self.monthLabel.text=@"ECS用户发展月数据总数";
    }
}
-(IBAction)popToHigherLevel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)pressMapButton:(id)sender {
    TimeViewController *time=[[TimeViewController alloc]initWithNibName:@"TimeViewController" bundle:nil];
    if ([_str isEqualToString:@"ESS合约计划月数据趋势图"]) {
        time.title=@"301";
    }else if ([_str isEqualToString:@"ECS交易额月数据趋势图"])
    {
        time.title=@"302";
    }else if ([_str isEqualToString:@"ECS商城订单月数据趋势图"])
    {
        time.title=@"303";
    }else if ([_str isEqualToString:@"ECS用户发展月数据趋势图"])
    {
        time.title=@"304";
    }
    [self.navigationController pushViewController:time animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setBMonthLabel:nil];
    [self setSMonthLabel:nil];
    [super viewDidUnload];
}
//对字典按KEY进行排序
-(NSArray *)sortByKeys:(NSDictionary*)dict
{
    NSArray* arr = [dict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    return arr;
}
@end
