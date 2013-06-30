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
            NSLog(@"err=%@",errorMsg);
        }];
        [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_3GNUM sucess:^(NSArray *str) {
            //画图
            NSLog(@"str=%@",str);
            [self drawImage:str];
            
        } falid:^(NSString *errorMsg) {
            
        }];
        
    }else if ([_vpString isEqualToString:@"3G用户月开户数量 :"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
            NSLog(@"err=%@",errorMsg);
        }];
         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_3GNUM sucess:^(NSArray *str) {
            //画图
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
            
        }];
        
    }else if ([_vpString isEqualToString:@"3G用户年开户数量 :"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
            NSLog(@"err=%@",errorMsg);
        }];
         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_3GNUM sucess:^(NSArray *str) {
            //画图
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
            
        }];

        
    }else if ([_vpString isEqualToString:@"iPhone4S实时开户数量 :"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaIphoneFsNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
            NSLog(@"err=%@",errorMsg);
        }];

         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_FOURSNUM sucess:^(NSArray *str) {
            //画图
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
            
        }];

        
    }else if ([_vpString isEqualToString:@"iPhone4S月开户数量 :"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaIphoneFsNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
            NSLog(@"err=%@",errorMsg);
        }];

         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_FOURSNUM sucess:^(NSArray *str) {
            //画图
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
            
        }];
        
    }else if ([_vpString isEqualToString:@"iPhone4S年开户数量 :"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaIphoneFsNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
            NSLog(@"err=%@",errorMsg);
        }];
         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_FOURSNUM sucess:^(NSArray *str) {
            //画图
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
            
        }];

    }else if ([_vpString isEqualToString:@"iPhone5实时开户数量 :"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaIphoneFiveNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
            NSLog(@"err=%@",errorMsg);
        }];
         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_FIVENUM sucess:^(NSArray *str) {
            //画图
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
            
        }];
        
    }else if ([_vpString isEqualToString:@"iPhone5月开户数量 :"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaIphoneFiveNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
            NSLog(@"err=%@",errorMsg);
        }];
         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_FIVENUM sucess:^(NSArray *str) {
            //画图
            NSLog(@"str=%@",str);
        } falid:^(NSString *errorMsg) {
            
        }];
        
    }else if ([_vpString isEqualToString:@"iPhone5年开户数量 :"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
        [[requestServiceHelper defaultService]getEssAreaIphoneFiveNum:dict sucess:^(NSArray *array) {
            [self getNumForCode:array];
        } falid:^(NSString *errorMsg) {
            NSLog(@"err=%@",errorMsg);
        }];
         [dict setValue:[self getCode] forKey:@"areaCode"];
        [[requestServiceHelper defaultService]getEssProvinceNum:dict url:GET_ESS_PROVINCE_FIVENUM sucess:^(NSArray *str) {
            //画图
            NSLog(@"str=%@",str);
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
   
    int sum=[self numTotal:array];
    NSMutableArray *muArray=[self ratio:array total:sum];
    
    //test
    NSMutableArray *aaaaa=[NSMutableArray arrayWithObjects:@"5",@"10",@"20",@"30",@"40",@"70", nil];
    for (int i =0; i<[aaaaa count]; i++) {
        UIImage *image=[UIImage imageNamed:@"new_area_bg_bg.png"];
        NSLog(@"11111=%@",NSStringFromCGSize(image.size));
       UIImage *newImage= [image stretchableImageWithLeftCapWidth:70 topCapHeight:35];
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, i*50, image.size.width+[[aaaaa objectAtIndex:i] floatValue], image.size.height)];
        imageview.image=newImage;
        [self.myScrollView addSubview:imageview];
    }
    
//    for (int i=0; i<[aaaaa count]; i++) {
//        UIImage *leftImage= [UIImage imageNamed:@"left_area"];
//        NSLog(@"ri=%@",NSStringFromCGSize(leftImage.size));
//        UIImageView *leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, i*(53+5), leftImage.size.width, 38)];
//        leftImageView.image=leftImage;
//        
//        
//        UIImage *rightImage=[UIImage imageNamed:@"right_area"];
//        NSLog(@"ri=%@",NSStringFromCGSize(rightImage.size));
//        UIImage *newRightImage=[rightImage resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 3)];
//        UIImageView *rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10+leftImageView.frame.size.width, i*(53+4), [[aaaaa objectAtIndex:i] floatValue], rightImage.size.height-8)];
////        [rightImageView setBackgroundColor:[UIColor redColor]];
//        rightImageView.image=newRightImage;
//        [self.myScrollView addSubview:leftImageView];
//        [self.myScrollView addSubview:rightImageView];
//    }
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
            new =data*300/num;
        }
        
        [array addObject:[NSString stringWithFormat:@"%f",new]];
    }
    return array;
}
-(int)numTotal : (NSArray *)array
{
    int sum=0;
    for (int i=0; i<[array count]; i++) {
        sum +=[[array objectAtIndex:i] intValue];
    }
    return sum;
}

@end
