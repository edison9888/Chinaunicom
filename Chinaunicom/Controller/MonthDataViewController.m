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
#import "MianView.h"
#import "CommonHelper.h"
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
        
        NSArray *sortarray=[self sortByKeys:nsdict];
        NSString *str=[Utility getTodayDate];
        NSArray *array=[sortarray subarrayWithRange:NSMakeRange(0, [str intValue]-1)];
        NSString *string=[array objectAtIndex:0];
        if (string.length==8) {
           NSString *monthString= [string substringWithRange:NSMakeRange(4, 2)];
           NSString *dateString= [string substringWithRange:NSMakeRange(6, 2)];
            NSString *money=[nsdict objectForKey:string];
            NSString *changeMoney=[Utility changeToyuan:money];
            self.bMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            //本月总数
            self.monthNumLabel.text=[NSString stringWithFormat:@"%@",changeMoney];
        }
        NSMutableArray *muArray=[self ratio:array dict:nsdict];
//      _yesterdayArray=muArray;
        MianView *line=[[MianView alloc]initWithFrame:CGRectMake(6, 6, 291, self.bgImageVIew.frame.size.height-17)];
        line.blueArray=muArray;

        UIColor *lineColor=[CommonHelper hexStringToColor:@"0x005aff"];
        UIColor *mianColor=[CommonHelper hexStringToColor:@"0x2c70c0"];
        line.colorArray=[NSArray arrayWithObjects:lineColor,mianColor, nil];
        [self.bgImageVIew addSubview:line];
        [self.bgImageVIew bringSubviewToFront:line];
        
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
        NSMutableArray *muArray=[self ratio:array dict:nsdict];
        //        _yesterdayArray=muArray;
        MianView *line=[[MianView alloc]initWithFrame:CGRectMake(6, 6, 291, self.bgImageVIew.frame.size.height-17)];
        line.blueArray=muArray;
        UIColor *lineColor=[CommonHelper hexStringToColor:@"0x25afff"];
        UIColor *mianColor=[CommonHelper hexStringToColor:@"0x2a91e1"];
        line.colorArray=[NSArray arrayWithObjects:lineColor,mianColor, nil];
        [self.bgImageVIew addSubview:line];
    } falid:^(NSString *errorMsg) {
    }];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.monthPointImageView.myDelegate=self;
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
    [self setBgImageVIew:nil];
    [self setMonthPointImageView:nil];
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
-(NSMutableArray *)ratio :(NSArray *)array  dict:(NSDictionary *)dt
{
    NSMutableArray *muArray=[NSMutableArray array];
    for (int i=0; i<[array count]; i++) {
        NSString* str=[dt objectForKey:[array objectAtIndex:i]];
        [muArray addObject:str];
    }
    float maxNum=[self maxNum:muArray];
    float minNum=[self minNum:muArray];
    if (minNum==0) {
        minNum=1;
    }
    float bei=maxNum/minNum;
    
    NSMutableArray *newArray=[NSMutableArray arrayWithCapacity:[muArray count]];
    for (int i=0; i<[muArray count]; i++) {
        float data = [[muArray objectAtIndex:i]floatValue];
        float bi =data/bei*180;
        [newArray addObject:[NSString stringWithFormat:@"%f",bi]];
    }
    return newArray;
}
//找最大值
-(float )maxNum : (NSMutableArray *)array
{
    int big=[[array objectAtIndex:0] floatValue];
    for (int i=0; i<[array count]; i++) {
        if (big<[[array objectAtIndex:i] floatValue]) {
            big=[[array objectAtIndex:i]floatValue];
        }
    }
    return big;
}
//找最小值
-(float)minNum:(NSMutableArray *)array
{
    float small=[[array objectAtIndex:0] floatValue];
    for (int i=0; i<[array count]; i++) {
        if ([[array objectAtIndex:i] floatValue]<small) {
            small=[[array objectAtIndex:i]floatValue];
        }
    }
    return small;
}
@end
