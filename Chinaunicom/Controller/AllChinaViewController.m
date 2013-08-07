//
//  AllChinaViewController.m
//  Chinaunicom
//
//  Created by rock on 13-8-7.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "AllChinaViewController.h"
#import "Utility.h"
@interface AllChinaViewController ()
{
    NSTimer *myTimer;
}
@property (nonatomic,strong) UIImageView *lineImageView;
@end

@implementation AllChinaViewController

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
    [self sendRequest];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(3, 86, 102, 2)];
    [self.lineImageView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.lineImageView];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)pressThreeGbutton:(UIButton *)sender {
    [myTimer invalidate];
    [self isInTheRect:sender];
    //获取ESS实时3G用户发展总数
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    if ([_titleStr isEqualToString:@"ESS实时数据趋势图"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        
        myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFire:) userInfo:dict repeats:YES];
        
    }else if ([_titleStr isEqualToString:@"ESS月数据趋势图"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];

        myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
        
    }else if ([_titleStr isEqualToString:@"ESS年数据趋势图"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];

        myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
    }
    
}

- (IBAction)pressIphoneFiveButton:(UIButton *)sender {
    [myTimer invalidate];
    [self isInTheRect:sender];
    
    //获取ESS实时Iphone5用户发展总数
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    if ([_titleStr isEqualToString:@"ESS实时数据趋势图"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];

        myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFire:) userInfo:dict repeats:YES];
        
    }else if ([_titleStr isEqualToString:@"ESS月数据趋势图"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];

        myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
        
    }else if ([_titleStr isEqualToString:@"ESS年数据趋势图"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];

        myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
    }
}

- (IBAction)pressIphoneFour:(UIButton *)sender {
    [myTimer invalidate];
    
    [self isInTheRect:sender];
    
    //获取ESS实时iphone4s用户发展总数
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    if ([_titleStr isEqualToString:@"ESS实时数据趋势图"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        
        myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFire:) userInfo:dict repeats:YES];
        
    }else if ([_titleStr isEqualToString:@"ESS月数据趋势图"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];

        myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
    }else if ([_titleStr isEqualToString:@"ESS年数据趋势图"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];

        myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
    }
    
}

-(void)isInTheRect : (UIButton *)bt
{
    CGPoint point=CGPointMake(self.lineImageView.frame.origin.x, self.lineImageView.frame.origin.y);
    BOOL isIn= CGRectContainsPoint(bt.frame,point);
    if (!isIn) {
        
        [self.threeGButton.titleLabel setTextColor:[UIColor darkGrayColor]];
        [self.iphoneFiveButton.titleLabel setTextColor:[UIColor darkGrayColor]];
        [self.iphone4SButton.titleLabel setTextColor:[UIColor darkGrayColor]];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3f animations:^{
            self.lineImageView.frame=CGRectMake(bt.frame.origin.x+3, self.lineImageView.frame.origin.y, self.lineImageView.frame.size.width, self.lineImageView.frame.size.height);
        }];
        
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [myTimer invalidate];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)sendRequest
{
    //获取ESS实时3G用户发展总数
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    if ([_titleStr isEqualToString:@"ESS实时数据趋势图"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFire:) userInfo:dict repeats:YES];
        [myTimer fire];
    }else if ([_titleStr isEqualToString:@"ESS月数据趋势图"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
        myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
    }else if ([_titleStr isEqualToString:@"ESS年数据趋势图"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
        myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
    }

}
-(void)timeFire : (NSTimer *)timer
{
    if (self.lineImageView.frame.origin.x <106)
    {
        [[requestServiceHelper defaultService]getChinaNum:timer.userInfo url:GET_CHINA_3G sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
            
        }];
    }else if (self.lineImageView.frame.origin.x >106 && self.lineImageView.frame.origin.x<212)
    {
        [[requestServiceHelper defaultService]getChinaNum:timer.userInfo url:GET_CHINA_IPHONE5 sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];
        
    }else
    {
        [[requestServiceHelper defaultService]getChinaNum:timer.userInfo url:GET_CHINA_IPHONE4S sucess:^(NSArray *str) {
            [self drawImage:str];
        } falid:^(NSString *errorMsg) {
        }];
    }
}
-(void)removeSubView
{
    for (UIView *view in self.myScrollView.subviews) {
        [view removeFromSuperview];
    }
}
-(void)drawImage : (NSArray *)array
{
    [self removeSubView];
    NSMutableArray *valueArray=[NSMutableArray arrayWithCapacity:[array count]];
    NSMutableArray *nameArray=[NSMutableArray arrayWithCapacity:[array count]];
    for (int i=0; i<[array count]; i++) {
        @autoreleasepool {
            NSString *str=[[array objectAtIndex:i]objectForKey:@"value"];
            NSString *value= [[array objectAtIndex:i]objectForKey:@"code"];
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
-(IBAction)popToHigherLevel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
