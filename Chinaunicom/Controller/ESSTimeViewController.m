//
//  ESSTimeViewController.m
//  Chinaunicom
//
//  Created by rock on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "ESSTimeViewController.h"
#import "requestServiceHelper.h"
#import <math.h>
#import <stdio.h>
@interface ESSTimeViewController ()

@end

@implementation ESSTimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.threeGButton setShadowColor:[UIColor blueColor] ];
    
    
    [self numForLabel:@"a"];
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"25/06/2013",@"timeStr", nil];
    [[requestServiceHelper defaultService]getESStotleNum:dict sucess:^(NSMutableArray *commentDictionary) {
        NSLog(@"co=%@",commentDictionary);
    } falid:^(NSString *errorMsg) {
        NSLog(@"err=%@",errorMsg);
    }];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)pressThreeGbutton:(UIButton *)sender {
    [self isInTheRect:sender];
    [self numForLabel:@"a"];
}

- (IBAction)pressIphoneFiveButton:(UIButton *)sender {
    [self isInTheRect:sender];
    [self numForLabel:@"b"];
}

- (IBAction)pressIphoneFour:(UIButton *)sender {
    [self isInTheRect:sender];
    [self numForLabel:@"c"];
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
-(void)numForLabel : (NSString *)str
{
    if ([str isEqualToString:@"a"])
    {
        self.hdLabel.text=[NSString stringWithFormat:@"111"];
        self.hnLabel.text=[NSString stringWithFormat:@"222"];
        self.hbLabel.text=[NSString stringWithFormat:@"333"];
        self.hzLabel.text=[NSString stringWithFormat:@"444"];
        self.xbLabel.text=[NSString stringWithFormat:@"555"];
        self.xnLabel.text=[NSString stringWithFormat:@"666"];
        self.dbLabel.text=[NSString stringWithFormat:@"777"];
    }
    else if ([str isEqualToString:@"b"])
    {
        self.hdLabel.text=[NSString stringWithFormat:@"200"];
        self.hnLabel.text=[NSString stringWithFormat:@"2000"];
        self.hbLabel.text=[NSString stringWithFormat:@"20000"];
        self.hzLabel.text=[NSString stringWithFormat:@"200000"];
        self.xbLabel.text=[NSString stringWithFormat:@"20000"];
        self.xnLabel.text=[NSString stringWithFormat:@"2000"];
        self.dbLabel.text=[NSString stringWithFormat:@"200"];
    }
    else
    {
        self.hdLabel.text=[NSString stringWithFormat:@"100"];
        self.hnLabel.text=[NSString stringWithFormat:@"100"];
        self.hbLabel.text=[NSString stringWithFormat:@"100"];
        self.hzLabel.text=[NSString stringWithFormat:@"100"];
        self.xbLabel.text=[NSString stringWithFormat:@"100"];
        self.xnLabel.text=[NSString stringWithFormat:@"100"];
        self.dbLabel.text=[NSString stringWithFormat:@"1000"];
    }
    
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
    [self.navigationController popViewControllerAnimated:YES];
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
