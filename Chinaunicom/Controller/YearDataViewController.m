//
//  YearDataViewController.m
//  Chinaunicom
//
//  Created by YY on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "YearDataViewController.h"
#import "requestServiceHelper.h"
#import "Utility.h"
@interface YearDataViewController ()
{
    NSMutableArray *yearDataArray;
}
@end

@implementation YearDataViewController
@synthesize yearStr=_yearStr;

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
    //年数据
    NSMutableDictionary *yearDict=[NSMutableDictionary dictionary];
    NSString *url=@"";
    if ([_yearStr isEqualToString:@"ESS合约计划年数据趋势图"])
    {
        url=GET_ESS_YEARDATA;
    }else if ([_yearStr isEqualToString:@"ECS交易额年数据趋势图"])
    {
        url=GET_ECS_YEARDATA;
    }else if ([_yearStr isEqualToString:@"ECS商城订单年数据趋势图"])
    {
        url=GET_STORE_YEARDATA;
    }else if ([_yearStr isEqualToString:@"ECS用户发展年数据趋势图"])
    {
        url=GET_GUESS_YEARDATA;
    }
    [[requestServiceHelper defaultService]getEssYearData:yearDict url:url  sucess:^(NSDictionary *nsdict) {
       
        NSArray *array=[self sortByKeys:nsdict];
        int x = [array count]-6;
        NSMutableArray *muArray=[NSMutableArray array];
        for (int i=x; i<[array count]; i++) {
           [muArray addObject:[array objectAtIndex:i]];
            if (i==x) {
                NSString *string=[array objectAtIndex:i];
                NSString *value=[nsdict objectForKey:string];
                NSString *changeValue=[Utility changeToyuan:value];
                if (string.length==6) {
                    NSString *yearString=[string substringWithRange:NSMakeRange(0, 4)];
                    self.yearLabel.text=[NSString stringWithFormat:@"%@年数据趋势图",yearString];
                    NSString *monthString=[string substringWithRange:NSMakeRange(4, 2)];
                    self.monthNumLabel.text=[NSString stringWithFormat:@"%d月 : %@",[monthString intValue],changeValue];
                }
            }
        }
        yearDataArray = [[NSMutableArray alloc]init];
        for (int i=0; i<[muArray count]; i++) {
            NSString *value= [nsdict objectForKey:[muArray objectAtIndex:i]];
            [yearDataArray addObject:value];
        }
        int sum=[self yearTotal:yearDataArray];
        NSMutableArray *yearMuArray=[self ratio:yearDataArray total:sum];
        [self drawView:yearMuArray];
        self.yearNumLabel.text=@"123.5";
        
    } falid:^(NSString *errorMsg) {
    }];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.yearPointImage.myDelegate=self;

    if ([_yearStr isEqualToString:@"ECS交易额年数据趋势图"]) {
        self.yearNameLable.text=@"ECS交易额年数据总数";
    }else if ([_yearStr isEqualToString:@"ESS合约计划年数据趋势图"])
    {
        self.yearNameLable.text=@"ESS合约计划年数据总数";
    }else if ([_yearStr isEqualToString:@"ECS商城订单年数据趋势图"])
    {
        self.yearNameLable.text=@"ECS商城订单年数据总数";
    }else if ([_yearStr isEqualToString:@"ECS用户发展年数据趋势图"])
    {
        self.yearNameLable.text=@"ECS用户发展年数据总数";
    }

    // Do any additional setup after loading the view from its nib.
}
-(IBAction)popToHigherLevel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)viewDidUnload {
    [self setMonthNumLabel:nil];
    [self setYearNameLable:nil];
    [self setBgImageView:nil];
    [self setYearPointImage:nil];
    [super viewDidUnload];
}
-(void)drawView : (NSMutableArray *)array
{
    UIImage *image = [UIImage imageNamed:@"new_ess_tu.png"];
    for (int i = 0 ; i<[array count];i++) {
        float y=[[array objectAtIndex:i]floatValue];
        UIView *newView=[[UIView alloc]initWithFrame:CGRectMake(7*(i*3.77 +1), 191-y, image.size.width-8, y)];
        [newView setBackgroundColor:[UIColor colorWithPatternImage:image]];
        newView.transform = CGAffineTransformRotate(newView.transform, 3.14);
        [self.bgImageView addSubview:newView];
    }

}
-(NSMutableArray *)ratio :(NSArray *)dataArray total:(int)num
{
    float new=0;
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:[dataArray count]];
    for (int i=0; i<[dataArray count]; i++) {
        int data = [[dataArray objectAtIndex:i]intValue];
        if (data==0) {
            new=0;
        }else
        {
            new =data*190/num;
        }
        
        [array addObject:[NSString stringWithFormat:@"%f",new]];
    }
    return array;
}
-(int)yearTotal : (NSArray *)array
{
    int sum=0;
    for (int i=0; i<[array count]; i++) {
        sum +=[[array objectAtIndex:i] intValue];
    }
    return sum;
}
#pragma YearPointImageViewDelegate
-(void)showTheData:(int)num
{
    if (num>[yearDataArray count]) {
        self.monthNumLabel.text=[NSString stringWithFormat:@"%d月 : 0元",num];
    }else
    {
        NSString *string=[Utility changeToyuan:[yearDataArray objectAtIndex:num-1]];
        self.monthNumLabel.text=[NSString stringWithFormat:@"%d月 : %@",num,string];
    }

}
    
@end
