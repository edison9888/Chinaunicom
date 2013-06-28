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
@interface ESSTimeViewController ()

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
    if ([_titleStr isEqualToString:@"实时ESS用户发展总数"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];

    }else if ([_titleStr isEqualToString:@"ESS月数据总数"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
       
    }else if ([_titleStr isEqualToString:@"ESS年数据总数"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
    }
    
    [[requestServiceHelper defaultService]getESStotleNum:dict sucess:^(NSString *str) {
        NSString *num=[Utility changeTohu:str];
        self.numLabel.text=num;
    } falid:^(NSString *errorMsg) {
    }];
    
    [[requestServiceHelper defaultService]getEssAreaNum:dict sucess:^(NSArray *array) {
        self.hdLabel.text=[Utility changeToWan:[array objectAtIndex:3]];
        self.hnLabel.text=[Utility changeToWan:[array objectAtIndex:5]];
        self.hbLabel.text=[Utility changeToWan:[array objectAtIndex:0]];
        self.hzLabel.text=[Utility changeToWan:[array objectAtIndex:6]];
        self.xbLabel.text=[Utility changeToWan:[array objectAtIndex:1]];
        self.xnLabel.text=[Utility changeToWan:[array objectAtIndex:2]];
        self.dbLabel.text=[Utility changeToWan:[array objectAtIndex:4]];
        [self numForLabel];
    } falid:^(NSString *errorMsg) {
        NSLog(@"err=%@",errorMsg);
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text=_titleStr;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)pressThreeGbutton:(UIButton *)sender {
    [self isInTheRect:sender];
    //获取ESS实时3G用户发展总数
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    if ([_titleStr isEqualToString:@"实时ESS用户发展总数"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        
    }else if ([_titleStr isEqualToString:@"ESS月数据总数"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
        
    }else if ([_titleStr isEqualToString:@"ESS年数据总数"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
    }
    
    [[requestServiceHelper defaultService]getESStotleNum:dict sucess:^(NSString *str) {
        NSString *num=[Utility changeTohu:str];
        self.numLabel.text=num;
    } falid:^(NSString *errorMsg) {
    }];
    
    [[requestServiceHelper defaultService]getEssAreaNum:dict sucess:^(NSArray *array) {
        self.hdLabel.text=[Utility changeToWan:[array objectAtIndex:3]];
        self.hnLabel.text=[Utility changeToWan:[array objectAtIndex:5]];
        self.hbLabel.text=[Utility changeToWan:[array objectAtIndex:0]];
        self.hzLabel.text=[Utility changeToWan:[array objectAtIndex:6]];
        self.xbLabel.text=[Utility changeToWan:[array objectAtIndex:1]];
        self.xnLabel.text=[Utility changeToWan:[array objectAtIndex:2]];
        self.dbLabel.text=[Utility changeToWan:[array objectAtIndex:4]];
        [self numForLabel];
    } falid:^(NSString *errorMsg) {
        NSLog(@"err=%@",errorMsg);
    }];
}

- (IBAction)pressIphoneFiveButton:(UIButton *)sender {
    [self isInTheRect:sender];
    //获取ESS实时Iphone5用户发展总数
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    if ([_titleStr isEqualToString:@"实时ESS用户发展总数"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        
    }else if ([_titleStr isEqualToString:@"ESS月数据总数"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
        
    }else if ([_titleStr isEqualToString:@"ESS年数据总数"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
    }
    [[requestServiceHelper defaultService]getESSIphoneFiveNum:dict sucess:^(NSString *str) {
        NSString *num=[Utility changeTohu:str];
        self.numLabel.text=num;
    } falid:^(NSString *errorMsg) {
    }];
    
    [[requestServiceHelper defaultService]getEssAreaIphoneFiveNum:dict sucess:^(NSArray *array) {
        self.hdLabel.text=[Utility changeToWan:[array objectAtIndex:3]];
        self.hnLabel.text=[Utility changeToWan:[array objectAtIndex:5]];
        self.hbLabel.text=[Utility changeToWan:[array objectAtIndex:0] ];
        self.hzLabel.text=[Utility changeToWan:[array objectAtIndex:6] ];
        self.xbLabel.text=[Utility changeToWan:[array objectAtIndex:1] ];
        self.xnLabel.text=[Utility changeToWan:[array objectAtIndex:2] ];
        self.dbLabel.text=[Utility changeToWan:[array objectAtIndex:4] ];
        [self numForLabel];
    } falid:^(NSString *errorMsg) {
        NSLog(@"err=%@",errorMsg);
    }];
}

- (IBAction)pressIphoneFour:(UIButton *)sender {
    [self isInTheRect:sender];
    //获取ESS实时iphone4s用户发展总数
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    if ([_titleStr isEqualToString:@"实时ESS用户发展总数"]) {
        [dict setValue:@"currData" forKey:@"timeStr"];
        
    }else if ([_titleStr isEqualToString:@"ESS月数据总数"]){
        [dict setValue:@"monthData" forKey:@"timeStr"];
        
    }else if ([_titleStr isEqualToString:@"ESS年数据总数"]){
        [dict setValue:@"yearData" forKey:@"timeStr"];
    }
    [[requestServiceHelper defaultService]getESSIphoneFsNum:dict sucess:^(NSString *str) {
        NSString *num=[Utility changeTohu:str];
        self.numLabel.text=num;
    } falid:^(NSString *errorMsg) {
    }];
    
    [[requestServiceHelper defaultService]getEssAreaIphoneFsNum:dict sucess:^(NSArray *array) {
        self.hdLabel.text=[Utility changeToWan:[array objectAtIndex:3]];
        self.hnLabel.text=[Utility changeToWan:[array objectAtIndex:5]];
        self.hbLabel.text=[Utility changeToWan:[array objectAtIndex:0]];
        self.hzLabel.text=[Utility changeToWan:[array objectAtIndex:6]];
        self.xbLabel.text=[Utility changeToWan:[array objectAtIndex:1]];
        self.xnLabel.text=[Utility changeToWan:[array objectAtIndex:2]];
        self.dbLabel.text=[Utility changeToWan:[array objectAtIndex:4]];
        [self numForLabel];
    } falid:^(NSString *errorMsg) {
        NSLog(@"err=%@",errorMsg);
    }];
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
        
        [self changeVpLabel:bt.tag];
        
        [UIView animateWithDuration:0.3f animations:^{
            self.lineImageView.frame=CGRectMake(bt.frame.origin.x+2, self.lineImageView.frame.origin.y, self.lineImageView.frame.size.width, self.lineImageView.frame.size.height);
            
        }];
        for (UIView *view in [self.bgImageView subviews]){
            [view removeFromSuperview];
        }
    }
}

-(void)changeVpLabel : (int) tag
{
    if (tag==1) {
        self.vpLabel.text=@"3G用户实时开户数量 :";
    }else if (tag==2){
        self.vpLabel.text=@"iPhone5实时开户数量 :";
    }else if (tag==3)
    {
        self.vpLabel.text=@"iPhone4S实时开户数量 :";
    }
    
}
-(void)numForLabel 
{
    NSArray *array=[NSArray arrayWithObjects:
                     self.hdLabel.text,
                     self.hnLabel.text,
                     self.hbLabel.text,
                     self.hzLabel.text,
                     self.xbLabel.text,
                     self.xnLabel.text,
                     self.dbLabel.text,
                     nil] ;
    int a[]={[self.hdLabel.text intValue],[self.hnLabel.text intValue],[self.hbLabel.text intValue],[self.hzLabel.text intValue],[self.xbLabel.text intValue],[self.xnLabel.text intValue],[self.dbLabel.text intValue]};
    int num = totalsum(a, 7);
    NSMutableArray *muArray = [self ratio:array total:num];
    
    UIImage *image = [UIImage imageNamed:@"new_ess_tu.png"];
    for (int i = 0 ; i<[muArray count];i++) {
        float y=[[muArray objectAtIndex:i]floatValue];
        UIView *newView=[[UIView alloc]initWithFrame:CGRectMake(16*(i*2.69 +1), 190-y, image.size.width, y)];
        [newView setBackgroundColor:[UIColor colorWithPatternImage:image]];
        newView.transform = CGAffineTransformRotate(newView.transform, 3.14);
        [self.bgImageView addSubview:newView];
    }
}
-(IBAction)back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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
-(NSMutableArray *)ratio :(NSArray *)dataArray total:(int)num
{
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:[dataArray count]];
    for (int i=0; i<[dataArray count]; i++) {
        int data = [[dataArray objectAtIndex:i]intValue];
        float new=data*190/num;
        [array addObject:[NSString stringWithFormat:@"%f",new]];
    }
    return array;
}
int totalsum( int* a, int n )
{
    int sum = 0;
    int i;
    for ( i = 0; i < n; ++i )
        sum += a[i];
    return sum ;
}

@end
