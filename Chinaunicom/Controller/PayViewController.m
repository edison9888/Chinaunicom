//
//  PayViewController.m
//  Chinaunicom
//
//  Created by YY on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "PayViewController.h"
#import "requestServiceHelper.h"
#import "Utility.h"
#import "LineImageView.h"
#import "TimeViewController.h"
@interface PayViewController ()
{
    int t;
    NSString *string;
    float henx;
    float dijige;
}
@end

@implementation PayViewController
@synthesize str=_str;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//今日数据
-(void)todayData : (BOOL)isPress
{
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"today" forKey:@"timeStr"];
    NSString *url=@"";
    if ([_str isEqualToString:@"ESS合约计划整点趋势图"])
    {
        url=GET_ESS_HOURTREND;
    }else if ([_str isEqualToString:@"ECS交易额整点趋势图"])
    {
        url=GET_ECS_HOURTREND;
    }else if ([_str isEqualToString:@"ECS商城订单整点趋势图"])
    {
        url=GET_STORE_HOURTREND;
    }else if ([_str isEqualToString:@"ECS用户发展整点趋势图"])
    {
        url=GET_GUESS_HOURTREND;
    }
    [[requestServiceHelper defaultService]getEssHourTrend:dict ulr:url sucess:^(NSDictionary *nsdict) {
        if (isPress) {
            if ([nsdict count]>0) {
                NSString *num=[Utility changeToyuan:[nsdict objectForKey:@"00"]];
                self.numLabel.text=[NSString stringWithFormat:@"00点 : %@",num];
            }
        }
        _todayDict = [NSDictionary dictionaryWithDictionary:nsdict];
        NSMutableArray *muArray=[self ratio:nsdict];
        _todayArray=muArray;
        LineImageView *line=[[LineImageView alloc]initWithFrame:CGRectMake(6, 4, 304, self.bgImageView.frame.size.height-15)];
        line.blueArray=muArray;
        line.colorArray=[NSArray arrayWithObjects:@"1.0",@"1.0",@"1.0",@"1.0", nil];
        [self.bgImageView addSubview:line];
        self.blueDian.hidden=NO;
        
    } falid:^(NSString *errorMsg) {
    }];
}
//昨日数据
-(void)yesterdayData:(BOOL)isPress
{
    //昨日数据
    NSMutableDictionary *ytDict=[NSMutableDictionary dictionaryWithObject:@"yesterday" forKey:@"timeStr"];
    NSString *url=@"";
    if ([_str isEqualToString:@"ESS合约计划整点趋势图"])
    {
        url=GET_ESS_HOURTREND;
    }else if ([_str isEqualToString:@"ECS交易额整点趋势图"])
    {
        url=GET_ECS_HOURTREND;
    }else if ([_str isEqualToString:@"ECS商城订单整点趋势图"])
    {
        url=GET_STORE_HOURTREND;
    }else if ([_str isEqualToString:@"ECS用户发展整点趋势图"])
    {
        url=GET_GUESS_HOURTREND;
    }
    [[requestServiceHelper defaultService]getEssHourTrend:ytDict ulr:url sucess:^(NSDictionary *nsdict) {
            
        _yesterdayDict = [NSDictionary dictionaryWithDictionary:nsdict];
        NSMutableArray *muArray=[self ratio:nsdict];
        _yesterdayArray=muArray;
        LineImageView *line=[[LineImageView alloc]initWithFrame:CGRectMake(6, 4, 304, self.bgImageView.frame.size.height-15)];
        line.blueArray=muArray;
        line.colorArray=[NSArray arrayWithObjects:@"0.5",@"0.7",@"1.0",@"1.0", nil];
        [self.bgImageView addSubview:line];
            
    } falid:^(NSString *errorMsg) {
    }];
    

}
//均值数据
-(void)avgData:(BOOL)isPress
{
    //均值数据
    NSMutableDictionary *avgDict=[NSMutableDictionary dictionaryWithObject:@"avg" forKey:@"timeStr"];
    NSString *url=@"";
    if ([_str isEqualToString:@"ESS合约计划整点趋势图"])
    {
        url=GET_ESS_HOURTREND;
    }else if ([_str isEqualToString:@"ECS交易额整点趋势图"])
    {
        url=GET_ECS_HOURTREND;
    }else if ([_str isEqualToString:@"ECS商城订单整点趋势图"])
    {
        url=GET_STORE_HOURTREND;
    }else if ([_str isEqualToString:@"ECS用户发展整点趋势图"])
    {
        url=GET_GUESS_HOURTREND;
    }
    [[requestServiceHelper defaultService]getEssHourTrend:avgDict ulr:url sucess:^(NSDictionary *nsdict) {
            _avgDict = [NSDictionary dictionaryWithDictionary:nsdict];
            NSMutableArray *muArray=[self ratio:nsdict];
            _avgArray=muArray;
            LineImageView *line=[[LineImageView alloc]initWithFrame:CGRectMake(6, 4, 304, self.bgImageView.frame.size.height-15)];
            line.blueArray=muArray;
            line.colorArray=[NSArray arrayWithObjects:@"1.0",@"0.7",@"0.3",@"1.0", nil];
            [self.bgImageView addSubview:line];
            
        } falid:^(NSString *errorMsg) {
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self todayData:YES];
    [self yesterdayData:NO];
    [self avgData:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text=_str;
    [self getLocalData];
    string=@"00";
    henx=16;
    self.pointImageView.myDelegate=self;
    self.pointImageView.blueDianImage=self.blueDian;
}

- (IBAction)pressTodayButton:(id)sender {
    
    [self getLocalData];
    [self isInTheRect:sender];
    t=0;
    [self showTheData:string x:henx num:dijige];
}

- (IBAction)pressAvgButton:(id)sender {

    [self isInTheRect:sender];
    t=2;
    [self showTheData:string x:henx num:dijige];
}

- (IBAction)pressYesterdayButton:(id)sender {
    
    [self isInTheRect:sender];
    t=1;
    [self showTheData:string x:henx num:dijige];
}
-(void)isInTheRect : (UIButton *)bt
{
    CGPoint point=CGPointMake(self.lineImageView.frame.origin.x, self.lineImageView.frame.origin.y);
    BOOL isIn= CGRectContainsPoint(bt.frame,point);
    if (!isIn) {

        [UIView animateWithDuration:0.3f animations:^{
            self.lineImageView.frame=CGRectMake(bt.frame.origin.x+27, self.lineImageView.frame.origin.y, self.lineImageView.frame.size.width, self.lineImageView.frame.size.height);
            
        }];
    }
}
-(IBAction)popToHigherLevel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)pressMapButton:(id)sender {
    
    TimeViewController *time=[[TimeViewController alloc]initWithNibName:@"TimeViewController" bundle:nil];
    if ([_str isEqualToString:@"ESS合约计划整点趋势图"])
    {
        time.title=@"201";
    }else if ([_str isEqualToString:@"ECS交易额整点趋势图"])
    {
        time.title=@"202";
    }else if ([_str isEqualToString:@"ECS商城订单整点趋势图"])
    {
        time.title=@"203";
    }else if ([_str isEqualToString:@"ECS用户发展整点趋势图"])
    {
        time.title=@"204";
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
    [self setNumLabel:nil];
    [self setYesterdayButton:nil];
    [self setTodayButton:nil];
    [self setAvgButton:nil];
    [self setLineImageView:nil];
    [self setLocalTimeLabel:nil];
    [self setBgImageView:nil];
    [self setPointImageView:nil];
    [self setBlueDian:nil];
    [super viewDidUnload];
}
-(void)getLocalData 
{
    NSString *str=[Utility getTodayDate];
    self.localTimeLabel.text=[NSString stringWithFormat:@"%@日整点数据",str];
}

-(NSMutableArray *)ratio :(NSDictionary *)dict 
{
    NSString *str=nil;
    NSMutableArray *muArray=[NSMutableArray array];
    for (int i=0; i<[dict count]; i++) {
        if (i==0) {
            str =[dict objectForKey:@"00"];
        } else if (i==1) {
            str =[dict objectForKey:@"01"];
            
        } else if (i==2) {
            str =[dict objectForKey:@"02"];
          
        } else if (i==3) {
            str =[dict objectForKey:@"03"];
            
        } else if (i==4) {
            str =[dict objectForKey:@"04"];
          
        } else if (i==5) {
            str =[dict objectForKey:@"05"];
           
        } else if (i==6) {
            str =[dict objectForKey:@"06"];
          
        } else if (i==7) {
            str =[dict objectForKey:@"07"];
           
        } else if (i==8) {
            str =[dict objectForKey:@"08"];
         
        } else if (i==9) {
            str =[dict objectForKey:@"09"];
          
        } else if (i==10) {
            str =[dict objectForKey:@"10"];
            
        } else if (i==11) {
            str =[dict objectForKey:@"11"];
         
        } else if (i==12) {
            str =[dict objectForKey:@"12"];
          
        } else if (i==13) {
            str =[dict objectForKey:@"13"];
          
        } else if (i==14) {
            str =[dict objectForKey:@"14"];
            
        } else if (i==15) {
            str =[dict objectForKey:@"15"];
          
        }else if (i==16) {
            str =[dict objectForKey:@"16"];
            
        }else if (i==17) {
            str =[dict objectForKey:@"17"];
            
        }else if (i==18) {
            str =[dict objectForKey:@"18"];
            
        }else if (i==19) {
            str =[dict objectForKey:@"19"];
            
        }else if (i==20) {
            str =[dict objectForKey:@"20"];
            
        }else if (i==21) {
            str =[dict objectForKey:@"21"];
            
        }else if (i==22) {
            str =[dict objectForKey:@"22"];
            
        }else if (i==23) {
            str =[dict objectForKey:@"23"];
            
        }else if (i==24) {
            str =[dict objectForKey:@"24"];
            
        }
        [muArray addObject:str];
    }
    NSMutableArray *array=[Utility calculatePercentage:muArray height:200];
//    float maxNum=[self maxNum:muArray];
//    float minNum=[self minNum:muArray];
//    if (minNum==0) {
//        minNum=1;
//    }
//    float bei=maxNum/minNum;
//    
//    NSMutableArray *array=[NSMutableArray arrayWithCapacity:[muArray count]];
//    for (int i=0; i<[muArray count]; i++) {
//        float data = [[muArray objectAtIndex:i]floatValue];
//        float bi =data/bei*180;
//        [array addObject:[NSString stringWithFormat:@"%f",bi]];
//    }
    return array;
}

#pragma PointImageviewDelegate
-(void)showTheData:(NSString *)key x:(float)hx num:(int)num
{
    float height=[[UIScreen mainScreen]applicationFrame].size.height;
    NSString *value=nil;
    if (t==0) {
       value= [_todayDict objectForKey:key];
        if (value !=nil) {
            self.blueDian.frame=CGRectMake(hx-6, height-84-[[_todayArray objectAtIndex:num]floatValue], self.blueDian.frame.size.width, self.blueDian.frame.size.height);
        }

    }else if (t==1){
        value= [_yesterdayDict objectForKey:key];
        if (value!=nil) {
            self.blueDian.frame=CGRectMake(hx-6, height-84-[[_yesterdayArray objectAtIndex:num]floatValue], self.blueDian.frame.size.width, self.blueDian.frame.size.height);
        }

    }else if (t==2){
       value= [_avgDict objectForKey:key];
        if (value !=nil) {
                    self.blueDian.frame=CGRectMake(hx-6, height-84-[[_avgArray objectAtIndex:num]floatValue], self.blueDian.frame.size.width, self.blueDian.frame.size.height);
        }
    }
    
    if (value==nil) {
        [self.numLabel setText:[NSString stringWithFormat:@"%@点 : 0元",key]];
        self.blueDian.hidden=YES;
    }else
    {
        value= [Utility changeToyuan:value];
        [self.numLabel setText:[NSString stringWithFormat:@"%@点 : %@",key,value]];
        self.blueDian.hidden=NO;
    }
    string=key;
    henx=hx;
    dijige=num;
}
@end
