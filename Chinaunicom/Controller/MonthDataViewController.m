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
{
    NSArray *shangMonthArray;
    NSArray *thisMonthArray;
    NSDictionary *shangMonthDict;
    NSDictionary *thisMonthDict;
}
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
 float height=[[UIScreen mainScreen]applicationFrame].size.height;
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
    //上月数据
    NSMutableDictionary *sMonthDict=[NSMutableDictionary dictionaryWithObject:@"prevMonth" forKey:@"timeStr"];
    [[requestServiceHelper defaultService]getEssMonthData:sMonthDict url:url sucess:^(NSDictionary *nsdict) {
        shangMonthDict=nsdict;
        NSArray *array=[self sortByKeys:nsdict];
        NSString *string=[array objectAtIndex:0];
        if (string.length==8) {
            NSString *monthString= [string substringWithRange:NSMakeRange(4, 2)];
            NSString *dateString= [string substringWithRange:NSMakeRange(6, 2)];
            NSString *money=[nsdict objectForKey:[array objectAtIndex:0]];
            if ([_str isEqualToString:@"ESS合约计划月数据趋势图"])
            {
                NSString *changeMoney=[Utility changeTohu:money];
                self.sMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            else if ([_str isEqualToString:@"ECS商城订单月数据趋势图"])
            {
                NSString *changeMoney=[Utility changeTobi:money];
                self.sMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            else if ([_str isEqualToString:@"ECS用户发展月数据趋势图"])
            {
                NSString *changeMoney=[Utility changeTohu:money];
                self.sMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            else
            {
                NSString *changeMoney=[Utility changeToyuan:money];
                self.sMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }

        }
        NSMutableArray *muArray=[self ratio:array dict:nsdict];
        shangMonthArray=muArray;
        MianView *line=[[MianView alloc]initWithFrame:CGRectMake(6, 3, 299, self.bgImageVIew.frame.size.height-12)];
        line.blueArray=muArray;
        UIColor *lineColor=[CommonHelper hexStringToColor:@"0x25afff"];
        UIColor *mianColor=[CommonHelper hexStringToColor:@"0x2a91e1"];
        line.colorArray=[NSArray arrayWithObjects:lineColor,mianColor, nil];
        [self.bgImageVIew addSubview:line];
        [self.bgImageVIew sendSubviewToBack:line];
        self.anotherBlue.frame=CGRectMake(5, height-82-[[muArray objectAtIndex:0] floatValue], self.anotherBlue.frame.size.width, self.anotherBlue.frame.size.height);
        self.anotherBlue.hidden=NO;
    } falid:^(NSString *errorMsg) {
    }];

    //本月数据
    NSMutableDictionary *tMonthDict=[NSMutableDictionary dictionaryWithObject:@"currMonth" forKey:@"timeStr"];
    [[requestServiceHelper defaultService]getEssMonthData:tMonthDict url:url  sucess:^(NSDictionary *nsdict) {
        thisMonthDict=nsdict;
        NSArray *sortarray=[self sortByKeys:nsdict];
        NSString *str=[Utility getTodayDate];
        NSArray *array=[sortarray subarrayWithRange:NSMakeRange(0, [str intValue]-1)];
        long long int total=0;
        for (int i=0; i<[array count]; i++) {
            long long int moneyNum=[[nsdict objectForKey:[array objectAtIndex:i]] intValue];
            total=total+moneyNum;
        }
        if ([_str isEqualToString:@"ESS合约计划月数据趋势图"])
        {
            NSString *totalMoney=[Utility changeTohu:[NSString stringWithFormat:@"%lld",total]];
            self.monthNumLabel.text=[NSString stringWithFormat:@"%@",totalMoney];
        }
        else if ([_str isEqualToString:@"ECS商城订单月数据趋势图"])
        {
            NSString *totalMoney=[Utility changeTobi:[NSString stringWithFormat:@"%lld",total]];
            self.monthNumLabel.text=[NSString stringWithFormat:@"%@",totalMoney];
        }
        else if ([_str isEqualToString:@"ECS用户发展月数据趋势图"])
        {
            NSString *totalMoney=[Utility changeTohu:[NSString stringWithFormat:@"%lld",total]];
            self.monthNumLabel.text=[NSString stringWithFormat:@"%@",totalMoney];
        }
        else
        {
            NSString *totalMoney=[Utility changeToyuan:[NSString stringWithFormat:@"%lld",total]];
            self.monthNumLabel.text=[NSString stringWithFormat:@"%@",totalMoney];
        }

        
        NSString *string=[array objectAtIndex:0];
        if (string.length==8) {
           NSString *monthString= [string substringWithRange:NSMakeRange(4, 2)];
           NSString *dateString= [string substringWithRange:NSMakeRange(6, 2)];
            NSString *money=[nsdict objectForKey:string];
            
            if ([_str isEqualToString:@"ECS交易额月数据趋势图"])
            {
                self.monthLabel.text=[NSString stringWithFormat:@"ECS交易额%d月数据总数",[monthString intValue]];
                
            }else if ([_str isEqualToString:@"ESS合约计划月数据趋势图"])
            {
                self.monthLabel.text=[NSString stringWithFormat:@"ESS合约计划%d月数据总数",[monthString intValue]];
                
            }else if ([_str isEqualToString:@"ECS商城订单月数据趋势图"])
            {
                self.monthLabel.text=[NSString stringWithFormat:@"ECS商城订单%d月数据总数",[monthString intValue]];
                
            }else if ([_str isEqualToString:@"ECS用户发展月数据趋势图"])
            {
                self.monthLabel.text=[NSString stringWithFormat:@"ECS用户发展%d月数据总数",[monthString intValue]];
            }
            if ([_str isEqualToString:@"ESS合约计划月数据趋势图"])
            {
                NSString *changeMoney=[Utility changeTohu:money];
                self.bMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            else if ([_str isEqualToString:@"ECS商城订单月数据趋势图"])
            {
                NSString *changeMoney=[Utility changeTobi:money];
                self.bMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            else if ([_str isEqualToString:@"ECS用户发展月数据趋势图"])
            {
                NSString *changeMoney=[Utility changeTohu:money];
                self.bMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            else
            {
                NSString *changeMoney=[Utility changeToyuan:money];
                self.bMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            
            //本月总数
        }
        NSMutableArray *muArray=[self ratio:array dict:nsdict];
        thisMonthArray=muArray;
        MianView *line=[[MianView alloc]initWithFrame:CGRectMake(6, 3, 299, self.bgImageVIew.frame.size.height-12)];
        line.blueArray=muArray;

        UIColor *lineColor=[CommonHelper hexStringToColor:@"0x005aff"];
        UIColor *mianColor=[CommonHelper hexStringToColor:@"0x2c70c0"];
        line.colorArray=[NSArray arrayWithObjects:lineColor,mianColor, nil];
        [self.bgImageVIew addSubview:line];
        [self.bgImageVIew bringSubviewToFront:line];
        self.bluedian.frame=CGRectMake(5, height-82-[[muArray objectAtIndex:0] floatValue], self.bluedian.frame.size.width, self.bluedian.frame.size.height);
        self.bluedian.hidden=NO;
    } falid:^(NSString *errorMsg) {
    }];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.monthPointImageView.myDelegate=self;
    self.monthPointImageView.blueDian=self.bluedian;
    self.monthPointImageView.anotherBlue=self.anotherBlue;
    [self.monthNumLabel setTextColor:[CommonHelper hexStringToColor:@"74d4fa"]];
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
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setBMonthLabel:nil];
    [self setSMonthLabel:nil];
    [self setBgImageVIew:nil];
    [self setMonthPointImageView:nil];
    [self setAnotherBlue:nil];
    [self setBluedian:nil];
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
    NSMutableArray *newArray=[Utility calculatePercentage:muArray height:200];
//    float maxNum=[self maxNum:muArray];
//    float minNum=[self minNum:muArray];
//    if (minNum==0) {
//        minNum=1;
//    }
//    float bei=maxNum/minNum;
//    
//    NSMutableArray *newArray=[NSMutableArray arrayWithCapacity:[muArray count]];
//    for (int i=0; i<[muArray count]; i++) {
//        float data = [[muArray objectAtIndex:i]floatValue];
//        float bi =data/bei*180;
//        [newArray addObject:[NSString stringWithFormat:@"%f",bi]];
//    }
    return newArray;
}

-(void)showTheData:(float)num num:(int)objcNum
{
    float height=[[UIScreen mainScreen]applicationFrame].size.height;
    if (objcNum>[shangMonthArray count]-1) {
        
        self.anotherBlue.hidden=YES;
    }else
    {
        NSArray *array=[self sortByKeys:shangMonthDict];
        NSString *string=[array objectAtIndex:objcNum];
        if (string.length==8) {
            NSString *monthString= [string substringWithRange:NSMakeRange(4, 2)];
            NSString *dateString= [string substringWithRange:NSMakeRange(6, 2)];
            NSString *money=[shangMonthDict objectForKey:string];
            
            if ([_str isEqualToString:@"ESS合约计划月数据趋势图"])
            {
                NSString *changeMoney=[Utility changeTohu:money];
                self.sMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            else if ([_str isEqualToString:@"ECS商城订单月数据趋势图"])
            {
                NSString *changeMoney=[Utility changeTobi:money];
                self.sMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            else if ([_str isEqualToString:@"ECS用户发展月数据趋势图"])
            {
                NSString *changeMoney=[Utility changeTohu:money];
                self.sMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            else
            {
                NSString *changeMoney=[Utility changeToyuan:money];
                self.sMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
        }
        self.anotherBlue.frame=CGRectMake(num-6, height-82-[[shangMonthArray objectAtIndex:objcNum] floatValue], self.bluedian.frame.size.width, self.bluedian.frame.size.height);
        self.anotherBlue.hidden=NO;
    }
    if (objcNum>[thisMonthArray count]-1) {
        self.bluedian.hidden=YES;
    }else
    {
        NSArray *sortarray=[self sortByKeys:thisMonthDict];
        NSString *str=[Utility getTodayDate];
        NSArray *array=[sortarray subarrayWithRange:NSMakeRange(0, [str intValue]-1)];
        NSString *string=[array objectAtIndex:objcNum];
        if (string.length==8) {
            NSString *monthString= [string substringWithRange:NSMakeRange(4, 2)];
            NSString *dateString= [string substringWithRange:NSMakeRange(6, 2)];
            NSString *money=[thisMonthDict objectForKey:string];
            if ([_str isEqualToString:@"ESS合约计划月数据趋势图"])
            {
                NSString *changeMoney=[Utility changeTohu:money];
                self.bMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            else if ([_str isEqualToString:@"ECS商城订单月数据趋势图"])
            {
                NSString *changeMoney=[Utility changeTobi:money];
                self.sMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            else if ([_str isEqualToString:@"ECS用户发展月数据趋势图"])
            {
                NSString *changeMoney=[Utility changeTohu:money];
                self.bMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
            else
            {
                NSString *changeMoney=[Utility changeToyuan:money];
                self.bMonthLabel.text=[NSString stringWithFormat:@"%d月%d日 : %@",[monthString intValue],[dateString intValue],changeMoney];
            }
        }
        self.bluedian.frame=CGRectMake(num-6, height-82-[[thisMonthArray objectAtIndex:objcNum] floatValue], self.bluedian.frame.size.width, self.bluedian.frame.size.height);
        self.bluedian.hidden=NO;
    }
}
@end
