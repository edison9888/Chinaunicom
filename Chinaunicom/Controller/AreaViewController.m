//
//  AreaViewController.m
//  Chinaunicom
//
//  Created by YY on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "AreaViewController.h"
#import "requestServiceHelper.h"
#import "Utility.h"
@interface AreaViewController ()

@end

@implementation AreaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    if ([_vpString isEqualToString:@"3G用户实时开户数量 :"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
        }];
        [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_3GNUM sucess:^(NSArray *str) {
            //画图
            [self drawImage:str];
            
        } falid:^(NSString *errorMsg) {
            
        }];
        
    }else if ([_vpString isEqualToString:@"3G用户月开户数量 :"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
            
        }];
         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_3GNUM sucess:^(NSArray *str) {
            //画图
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
            
        }];
        
    }else if ([_vpString isEqualToString:@"3G用户年开户数量 :"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
            
        }];
         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_3GNUM sucess:^(NSArray *str) {
            //画图
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
            
        }];

        
    }else if ([_vpString isEqualToString:@"iPhone4S实时开户数量 :"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaIphoneFsNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
          
        }];

         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_FOURSNUM sucess:^(NSArray *str) {
            //画图
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
            
        }];

        
    }else if ([_vpString isEqualToString:@"iPhone4S月开户数量 :"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaIphoneFsNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
            
        }];

         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_FOURSNUM sucess:^(NSArray *str) {
            //画图
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
            
        }];
        
    }else if ([_vpString isEqualToString:@"iPhone4S年开户数量 :"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaIphoneFsNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
           
        }];
         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_FOURSNUM sucess:^(NSArray *str) {
            //画图
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
            
        }];

    }else if ([_vpString isEqualToString:@"iPhone5实时开户数量 :"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaIphoneFiveNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
            
        }];
         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_FIVENUM sucess:^(NSArray *str) {
            //画图
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
            
        }];
        
    }else if ([_vpString isEqualToString:@"iPhone5月开户数量 :"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaIphoneFiveNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
          
        }];
         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_FIVENUM sucess:^(NSArray *str) {
            //画图
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
            
        }];
        
    }else if ([_vpString isEqualToString:@"iPhone5年开户数量 :"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaIphoneFiveNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
         
        }];
         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_FIVENUM sucess:^(NSArray *str) {
            //画图
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
            
        }];
        
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text=self.title;
    self.vpLabel.text=_vpString;
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

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setVpLabel:nil];
    [self setNumLabel:nil];
    [self setMyScrollView:nil];
    [super viewDidUnload];
}
-(void)getNumForCode : (NSArray *)array
{
    if ([self.title isEqualToString:@"华东地区"]) {
        self.numLabel.text=[Utility changeTohu:[array objectAtIndex:3]];
    }else if ([self.title isEqualToString:@"华南地区"])
    {
        self.numLabel.text=[Utility changeTohu:[array objectAtIndex:5]];
    }else if ([self.title isEqualToString:@"华北地区"])
    {
        self.numLabel.text=[Utility changeTohu:[array objectAtIndex:0]];
    }else if ([self.title isEqualToString:@"华中地区"])
    {
        self.numLabel.text=[Utility changeTohu:[array objectAtIndex:6]];
    }else if ([self.title isEqualToString:@"西北地区"])
    {
        self.numLabel.text=[Utility changeTohu:[array objectAtIndex:1]];
    }else if ([self.title isEqualToString:@"西南地区"])
    {
        self.numLabel.text=[Utility changeTohu:[array objectAtIndex:2]];
    }else if ([self.title isEqualToString:@"东北地区"])
    {
        self.numLabel.text=[Utility changeTohu:[array objectAtIndex:4]];
    }
}
-(NSString *)getCode
{
    NSString *string=nil;
    if ([self.title isEqualToString:@"华东地区"]) {
        string =@"huadong";
    }else if ([self.title isEqualToString:@"华南地区"])
    {
        string =@"huanan";
    }else if ([self.title isEqualToString:@"华北地区"])
    {
        string =@"huabei";
    }else if ([self.title isEqualToString:@"华中地区"])
    {
        string =@"huazhong";
    }else if ([self.title isEqualToString:@"西北地区"])
    {
        string =@"xibei";
    }else if ([self.title isEqualToString:@"西南地区"])
    {
        string =@"xinan";
    }else if ([self.title isEqualToString:@"东北地区"])
    {
        string =@"dongbei";
    }
    return string;
}
-(void)drawImage : (NSArray *)array
{
   
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Province" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSMutableArray *valueArray=[NSMutableArray arrayWithCapacity:[array count]];
    NSMutableArray *keysArray=[NSMutableArray arrayWithCapacity:[array count]];
    for (int i=0; i<[array count]; i++) {
        @autoreleasepool {
            NSString *str=[[array objectAtIndex:i]objectForKey:@"value"];
            NSString *key=[[array objectAtIndex:i]objectForKey:@"code"];
            NSString *value= [dict objectForKey:key];
            [valueArray addObject:str];
            [keysArray addObject:value];
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
            textLabel.text=[keysArray objectAtIndex:i];
            
            UIImage *newRightImage=[rightImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
            UIImageView *rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10+leftImageView.frame.size.width, i*(rightImage.size.height+5), [[muArray objectAtIndex:i] floatValue], rightImage.size.height)];
            rightImageView.image=newRightImage;
            
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(rightImageView.frame.origin.x+rightImageView.frame.size.width+5, i*(rightImage.size.height+5), 320-(rightImageView.frame.origin.x+rightImageView.frame.size.width), rightImage.size.height)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor whiteColor]];
            label.adjustsFontSizeToFitWidth=YES;

            label.text=[Utility changeTohu:[valueArray objectAtIndex:i]];
            [leftImageView addSubview:textLabel];
            [self.myScrollView addSubview:leftImageView];
            [self.myScrollView addSubview:rightImageView];
            [self.myScrollView addSubview:label];
        }
        
    }
    float height=[muArray count]*(rightImage.size.height+5);
    [self.myScrollView setContentSize:CGSizeMake(320, height)];
    
}

@end
