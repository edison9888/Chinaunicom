//
//  TimeViewController.m
//  Chinaunicom
//
//  Created by YY on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "TimeViewController.h"
#import "requestServiceHelper.h"
#import "Utility.h"
@interface TimeViewController ()

@end

@implementation TimeViewController

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
    if ([self.title isEqualToString:@"201"]) {
        //合约计划实时
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"wholeData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_ESS sucess:^(NSArray *str) {
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"202"])
    {
        //ecs实时
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"wholeData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_ECS sucess:^(NSArray *str) {
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"203"])
    {
        //商城订单实时
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"wholeData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_STORE sucess:^(NSArray *str) {
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
        }];
        
    }else if ([self.title isEqualToString:@"204"])
    {
        //用户发展实时
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"wholeData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_GUESS sucess:^(NSArray *str) {
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
        }];
        
    }else if ([self.title isEqualToString:@"301"])
    {
        //合约计划月数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_ESS sucess:^(NSArray *str) {
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
        }];

    }else if ([self.title isEqualToString:@"302"])
    {
        //ecs月数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_ECS sucess:^(NSArray *str) {
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
        }];

    }else if ([self.title isEqualToString:@"303"])
    {
        //商城订单月数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_STORE sucess:^(NSArray *str) {
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"304"])
    {
        //用户发展月数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_GUESS sucess:^(NSArray *str) {
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"401"])
    {
        //合约计划年数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_ESS sucess:^(NSArray *str) {
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"402"])
    {
        //ecs年数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_ECS sucess:^(NSArray *str) {
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"403"])
    {
        //商城订单年数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_STORE sucess:^(NSArray *str) {
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"404"])
    {
        //用户发展年数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_GUESS sucess:^(NSArray *str) {
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
        }];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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

@end
