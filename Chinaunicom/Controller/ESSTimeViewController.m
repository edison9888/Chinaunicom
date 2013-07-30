//
//  ESSTimeViewController.m
//  Chinaunicom
//
//  Created by rock on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "ESSTimeViewController.h"
#import "requestServiceHelper.h"
#import "Utility.h"
#import "AreaViewController.h"
@interface ESSTimeViewController ()
{
    NSTimer *myTimer;
}
@end

@implementation ESSTimeViewController
@synthesize titleStr=_titleStr;
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

    
//    [myTimer setFireDate:[NSDate distantPast]];
}
-(void)timeFire : (NSTimer *)timer
{
    if (self.lineImageView.frame.origin.x <106) {
        [[requestServiceHelper defaultService]getESStotleNum:timer.userInfo sucess:^(NSString *str) {
            NSString *num=[Utility changeTohu:str];
            self.numLabel.text=num;
        } falid:^(NSString *errorMsg) {
        }];
        
        [[requestServiceHelper defaultService]getEssAreaNum:timer.userInfo sucess:^(NSArray *array) {
            self.hdLabel.text=[array objectAtIndex:3];
            self.hnLabel.text=[array objectAtIndex:5];
            self.hbLabel.text=[array objectAtIndex:0];
            self.hzLabel.text=[array objectAtIndex:6];
            self.xbLabel.text=[array objectAtIndex:1];
            self.xnLabel.text=[array objectAtIndex:2];
            self.dbLabel.text=[array objectAtIndex:4];
            [self numForLabel];
        } falid:^(NSString *errorMsg) {
        }];
    }else if (self.lineImageView.frame.origin.x >106 && self.lineImageView.frame.origin.x<212)
    {
        [[requestServiceHelper defaultService]getESSIphoneFiveNum:timer.userInfo sucess:^(NSString *str) {
            NSString *num=[Utility changeTohu:str];
            self.numLabel.text=num;
        } falid:^(NSString *errorMsg) {
        }];
        
        [[requestServiceHelper defaultService]getEssAreaIphoneFiveNum:timer.userInfo sucess:^(NSArray *array) {
            self.hdLabel.text=[array objectAtIndex:3];
            self.hnLabel.text=[array objectAtIndex:5];
            self.hbLabel.text=[array objectAtIndex:0];
            self.hzLabel.text=[array objectAtIndex:6];
            self.xbLabel.text=[array objectAtIndex:1];
            self.xnLabel.text=[array objectAtIndex:2];
            self.dbLabel.text=[array objectAtIndex:4];
            [self numForLabel];
        } falid:^(NSString *errorMsg) {
        }];

    }else
    {
        [[requestServiceHelper defaultService]getESSIphoneFsNum:timer.userInfo sucess:^(NSString *str) {
            NSString *num=[Utility changeTohu:str];
            self.numLabel.text=num;
        } falid:^(NSString *errorMsg) {
        }];
        
        [[requestServiceHelper defaultService]getEssAreaIphoneFsNum:timer.userInfo sucess:^(NSArray *array) {
            self.hdLabel.text=[array objectAtIndex:3];
            self.hnLabel.text=[array objectAtIndex:5];
            self.hbLabel.text=[array objectAtIndex:0];
            self.hzLabel.text=[array objectAtIndex:6];
            self.xbLabel.text=[array objectAtIndex:1];
            self.xnLabel.text=[array objectAtIndex:2];
            self.dbLabel.text=[array objectAtIndex:4];
            [self numForLabel];
        } falid:^(NSString *errorMsg) {
        }];

    }


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.hdLabel setAdjustsFontSizeToFitWidth:YES];
    [self.hnLabel setAdjustsFontSizeToFitWidth:YES];
    [self.hbLabel setAdjustsFontSizeToFitWidth:YES];
    [self.hzLabel setAdjustsFontSizeToFitWidth:YES];
    [self.xbLabel setAdjustsFontSizeToFitWidth:YES];
    [self.xnLabel setAdjustsFontSizeToFitWidth:YES];
    [self.dbLabel setAdjustsFontSizeToFitWidth:YES];
    self.titleLabel.text=_titleStr;
    if ([_titleStr isEqualToString:@"ESS实时数据趋势图"]) {
   
        self.vpLabel.text=@"3G用户实时开户数量 :";
        
    }else if ([_titleStr isEqualToString:@"ESS月数据趋势图"]){
    
        self.vpLabel.text=@"3G用户月开户数量 :";
        
    }else if ([_titleStr isEqualToString:@"ESS年数据趋势图"]){
    
        self.vpLabel.text=@"3G用户年开户数量 :";
    }

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)pressThreeGbutton:(UIButton *)sender {
     [myTimer invalidate];
    [self isInTheRect:sender];
    //获取ESS实时3G用户发展总数
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    if ([_titleStr isEqualToString:@"ESS实时数据趋势图"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        self.vpLabel.text=@"3G用户实时开户数量 :";
       
        myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFire:) userInfo:dict repeats:YES];
        
    }else if ([_titleStr isEqualToString:@"ESS月数据趋势图"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
        self.vpLabel.text=@"3G用户月开户数量 :";
        myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
        
    }else if ([_titleStr isEqualToString:@"ESS年数据趋势图"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
        self.vpLabel.text=@"3G用户年开户数量 :";
        myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
    }

    
//    [[requestServiceHelper defaultService]getESStotleNum:dict sucess:^(NSString *str) {
//        NSString *num=[Utility changeTohu:str];
//        self.numLabel.text=num;
//    } falid:^(NSString *errorMsg) {
//    }];
//    
//    [[requestServiceHelper defaultService]getEssAreaNum:dict sucess:^(NSArray *array) {
//        self.hdLabel.text=[array objectAtIndex:3];
//        self.hnLabel.text=[array objectAtIndex:5];
//        self.hbLabel.text=[array objectAtIndex:0];
//        self.hzLabel.text=[array objectAtIndex:6];
//        self.xbLabel.text=[array objectAtIndex:1];
//        self.xnLabel.text=[array objectAtIndex:2];
//        self.dbLabel.text=[array objectAtIndex:4];
//        [self numForLabel];
//    } falid:^(NSString *errorMsg) {
//
//    }];
}

- (IBAction)pressIphoneFiveButton:(UIButton *)sender {
     [myTimer invalidate];
    [self isInTheRect:sender];
   
    //获取ESS实时Iphone5用户发展总数
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    if ([_titleStr isEqualToString:@"ESS实时数据趋势图"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
         self.vpLabel.text=@"iPhone5实时开户数量 :";
        
        myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFire:) userInfo:dict repeats:YES];
        
    }else if ([_titleStr isEqualToString:@"ESS月数据趋势图"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
         self.vpLabel.text=@"iPhone5月开户数量 :";
         myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
        
    }else if ([_titleStr isEqualToString:@"ESS年数据趋势图"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
         self.vpLabel.text=@"iPhone5年开户数量 :";
         myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
    }

//    [[requestServiceHelper defaultService]getESSIphoneFiveNum:dict sucess:^(NSString *str) {
//        NSString *num=[Utility changeTohu:str];
//        self.numLabel.text=num;
//    } falid:^(NSString *errorMsg) {
//    }];
//    
//    [[requestServiceHelper defaultService]getEssAreaIphoneFiveNum:dict sucess:^(NSArray *array) {
//        self.hdLabel.text=[array objectAtIndex:3];
//        self.hnLabel.text=[array objectAtIndex:5];
//        self.hbLabel.text=[array objectAtIndex:0];
//        self.hzLabel.text=[array objectAtIndex:6];
//        self.xbLabel.text=[array objectAtIndex:1];
//        self.xnLabel.text=[array objectAtIndex:2];
//        self.dbLabel.text=[array objectAtIndex:4];
//        [self numForLabel];
//    } falid:^(NSString *errorMsg) {
//
//    }];
}

- (IBAction)pressIphoneFour:(UIButton *)sender {
    [myTimer invalidate];
    
    [self isInTheRect:sender];
    
    //获取ESS实时iphone4s用户发展总数
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    if ([_titleStr isEqualToString:@"ESS实时数据趋势图"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        self.vpLabel.text=@"iPhone4S实时开户数量 :";
        
        myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFire:) userInfo:dict repeats:YES];
        
    }else if ([_titleStr isEqualToString:@"ESS月数据趋势图"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
        self.vpLabel.text=@"iPhone4S月开户数量 :";
        myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
    }else if ([_titleStr isEqualToString:@"ESS年数据趋势图"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
        self.vpLabel.text=@"iPhone4S年开户数量 :";
        myTimer=[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timeFire:) userInfo:dict repeats:NO];
    }

//    [[requestServiceHelper defaultService]getESSIphoneFsNum:dict sucess:^(NSString *str) {
//        NSString *num=[Utility changeTohu:str];
//        self.numLabel.text=num;
//    } falid:^(NSString *errorMsg) {
//    }];
//    
//    [[requestServiceHelper defaultService]getEssAreaIphoneFsNum:dict sucess:^(NSArray *array) {
//        self.hdLabel.text=[array objectAtIndex:3];
//        self.hnLabel.text=[array objectAtIndex:5];
//        self.hbLabel.text=[array objectAtIndex:0];
//        self.hzLabel.text=[array objectAtIndex:6];
//        self.xbLabel.text=[array objectAtIndex:1];
//        self.xnLabel.text=[array objectAtIndex:2];
//        self.dbLabel.text=[array objectAtIndex:4];
//        [self numForLabel];
//    } falid:^(NSString *errorMsg) {
//    
//    }];
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
            self.lineImageView.frame=CGRectMake(bt.frame.origin.x+2, self.lineImageView.frame.origin.y, self.lineImageView.frame.size.width, self.lineImageView.frame.size.height);
        }];

    }
}

//-(void)changeVpLabel : (int) tag
//{
//
//    if (tag==1) {
//        self.vpLabel.text=@"3G用户实时开户数量 :";
//    }else if (tag==2){
//        self.vpLabel.text=@"iPhone5实时开户数量 :";
//    }else if (tag==3)
//    {
//        self.vpLabel.text=@"iPhone4S实时开户数量 :";
//    }
//    
//}
-(void)numForLabel
{
    NSMutableArray *array=[NSMutableArray arrayWithObjects:
                     self.hdLabel.text,
                     self.hnLabel.text,
                     self.hbLabel.text,
                     self.hzLabel.text,
                     self.xbLabel.text,
                     self.xnLabel.text,
                     self.dbLabel.text,
                     nil] ;
//    int a[]={[self.hdLabel.text intValue],[self.hnLabel.text intValue],[self.hbLabel.text intValue],[self.hzLabel.text intValue],[self.xbLabel.text intValue],[self.xnLabel.text intValue],[self.dbLabel.text intValue]};
//    int num = totalsum(a, 7);
//    NSMutableArray *muArray = [self ratio:array total:num];
    
    NSMutableArray *muArray=[Utility calculatePercentage:array height:200];
    
    self.hdLabel.text=[Utility changeToWan:self.hdLabel.text];
    self.hnLabel.text=[Utility changeToWan:self.hnLabel.text];
    self.hbLabel.text=[Utility changeToWan:self.hbLabel.text ];
    self.hzLabel.text=[Utility changeToWan:self.hzLabel.text ];
    self.xbLabel.text=[Utility changeToWan:self.xbLabel.text ];
    self.xnLabel.text=[Utility changeToWan:self.xnLabel.text ];
    self.dbLabel.text=[Utility changeToWan:self.dbLabel.text ];
    
    for (UIView *view in [self.bgImageView subviews]){
        [view removeFromSuperview];
    }
    UIImage *image = [UIImage imageNamed:@"new_ess_tu.png"];
    for (int i = 0 ; i<[muArray count];i++) {
        @autoreleasepool {
            float y=[[muArray objectAtIndex:i]floatValue];
            //16*(i*2.75 +1)
            UIView *newView=[[UIView alloc]initWithFrame:CGRectMake(i*(22+21)+17, 202-y, image.size.width, y)];
            [newView setBackgroundColor:[UIColor colorWithPatternImage:image]];
            newView.transform = CGAffineTransformRotate(newView.transform, 3.14);
            [self.bgImageView addSubview:newView];
        }
    }
}
-(IBAction)back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)pressAreaButton:(UIButton *)sender
{
//    [myTimer invalidate];
    AreaViewController *area=[[AreaViewController alloc]initWithNibName:@"AreaViewController" bundle:nil];
    if (sender.tag==101) {
        area.title=@"华东地区";
    }else if (sender.tag==102)
    {
        area.title=@"华南地区";
    }else if (sender.tag==103)
    {
        area.title=@"华北地区";
    }else if (sender.tag==104)
    {
        area.title=@"华中地区";
    }else if (sender.tag==105)
    {
        area.title=@"西北地区";
    }else if (sender.tag==106)
    {
        area.title=@"西南地区";
    }else if (sender.tag==107)
    {
        area.title=@"东北地区";
    }
    area.vpString=self.vpLabel.text;
    [self.navigationController pushViewController:area animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setHdLabel:nil];
    [self setHnLabel:nil];
    [self setHbLabel:nil];
    [self setHzLabel:nil];
    [self setXbLabel:nil];
    [self setXnLabel:nil];
    [self setDbLabel:nil];
    [self setBgImageView:nil];
    [self setLineImageView:nil];
    [self setNumLabel:nil];
    [self setVpLabel:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [myTimer invalidate];
//    [myTimer setFireDate:[NSDate distantFuture]];
}
//-(NSMutableArray *)ratio :(NSArray *)dataArray total:(int)num
//{
//    float new=0;
//    NSMutableArray *array=[NSMutableArray arrayWithCapacity:[dataArray count]];
//    for (int i=0; i<[dataArray count]; i++) {
//        int data = [[dataArray objectAtIndex:i]intValue];
//        if (data==0) {
//            new=0;
//        }else
//        {
//           new =data*190/num;
//        }
//        
//        [array addObject:[NSString stringWithFormat:@"%f",new]];
//    }
//    return array;
//}
//int totalsum( int* a, int n )
//{
//    int sum = 0;
//    int i;
//    for ( i = 0; i < n; ++i )
//        sum += a[i];
//    return sum ;
//}

@end
