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
        self.titleLabel.text=@"整点地域排名";
        //合约计划实时
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"hourData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_ESS sucess:^(NSArray *str) {
            
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"202"])
    {
        self.titleLabel.text=@"整点地域排名";
        //ecs实时
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"hourData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_ECS sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"203"])
    {
        self.titleLabel.text=@"整点地域排名";
        //商城订单实时
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"hourData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_STORE sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];
        
    }else if ([self.title isEqualToString:@"204"])
    {
        self.titleLabel.text=@"整点地域排名";
        //用户发展实时
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"hourData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_GUESS sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];
        
    }else if ([self.title isEqualToString:@"301"])
    {
        self.titleLabel.text=@"月地域排名";
        //合约计划月数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_ESS sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];

    }else if ([self.title isEqualToString:@"302"])
    {
        self.titleLabel.text=@"月地域排名";
        //ecs月数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_ECS sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];

    }else if ([self.title isEqualToString:@"303"])
    {
        self.titleLabel.text=@"月地域排名";
        //商城订单月数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_STORE sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"304"])
    {
        self.titleLabel.text=@"月地域排名";
        //用户发展月数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_GUESS sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"401"])
    {
        self.titleLabel.text=@"年地域排名";
        //合约计划年数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_ESS sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"402"])
    {
        self.titleLabel.text=@"年地域排名";
        //ecs年数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_ECS sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"403"])
    {
        self.titleLabel.text=@"年地域排名";
        //商城订单年数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_STORE sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];
    }else if ([self.title isEqualToString:@"404"])
    {
        self.titleLabel.text=@"年地域排名";
        //用户发展年数据
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getProvinceNum:dict url:GET_PROVINCE_GUESS sucess:^(NSArray *str) {
            [self drawImage:str];
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)drawImage : (NSArray *)array
{

    NSMutableArray *valueArray=[NSMutableArray arrayWithCapacity:[array count]];
    NSMutableArray *nameArray=[NSMutableArray arrayWithCapacity:[array count]];
    for (int i=0; i<[array count]; i++) {
        @autoreleasepool {
            NSString *str=[[array objectAtIndex:i]objectForKey:@"data"];
            NSString *value= [[array objectAtIndex:i]objectForKey:@"provinceName"];
            [valueArray addObject:str];
            [nameArray addObject:value];
        }
    }

    NSMutableArray *muArray=[Utility calculatePercentage:valueArray height:200.0];
    
    UIImage *leftImage= [UIImage imageNamed:@"left_area.png"];
    UIImage *rightImage=[UIImage imageNamed:@"right_area.png"];
    for (int i=0; i<[muArray count]; i++) {
        @autoreleasepool {
            UIImageView *leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, i*(rightImage.size.height+5), leftImage.size.width, rightImage.size.height)];
            leftImageView.image=leftImage;
            
            UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, leftImageView.frame.size.width, leftImageView.frame.size.height)];
            [textLabel setTextColor:[UIColor blueColor]];
            [textLabel setTextAlignment:NSTextAlignmentCenter];
            textLabel.adjustsFontSizeToFitWidth=YES;
            [textLabel setBackgroundColor:[UIColor clearColor]];
            textLabel.text=[nameArray objectAtIndex:i];
            
            UIImage *newRightImage=[rightImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
            UIImageView *rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10+leftImageView.frame.size.width, i*(rightImage.size.height+5), [[muArray objectAtIndex:i] floatValue], newRightImage.size.height)];
            rightImageView.image=newRightImage;
            
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(rightImageView.frame.origin.x+rightImageView.frame.size.width+5, i*(rightImage.size.height+5), 320-(rightImageView.frame.origin.x+rightImageView.frame.size.width), rightImage.size.height)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor whiteColor]];
            label.adjustsFontSizeToFitWidth=YES;
            if ([self.title isEqualToString:@"204"]||[self.title isEqualToString:@"304"]||[self.title isEqualToString:@"404"]||[self.title isEqualToString:@"201"]||[self.title isEqualToString:@"301"]||[self.title isEqualToString:@"401"]) {
                
                label.text=[Utility changeTohu:[valueArray objectAtIndex:i]];
                
            }else if ([self.title isEqualToString:@"203"]||[self.title isEqualToString:@"303"]||[self.title isEqualToString:@"403"])
            {
                label.text=[Utility changeTobi:[valueArray objectAtIndex:i]];
            }
            else
            {
                label.text=[Utility changeToyuan:[valueArray objectAtIndex:i]];
            }
            [leftImageView addSubview:textLabel];
            [self.myScrollView addSubview:leftImageView];
            [self.myScrollView addSubview:rightImageView];
            [self.myScrollView addSubview:label];
        }
    }
    float height=[muArray count]*(rightImage.size.height+5);
    [self.myScrollView setContentSize:CGSizeMake(320, height)];
}
- (void)viewDidUnload {
    [self setMyScrollView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}
@end
