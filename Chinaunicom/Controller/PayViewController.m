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
@interface PayViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text=_str;
    [self getLocalData];
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"today" forKey:@"timeStr"];
    [[requestServiceHelper defaultService]getEssHourTrend:dict sucess:^(NSArray *array) {
        NSString *num=[Utility changeToyuan:[[array objectAtIndex:0]objectForKey:@"00"]];
        self.numLabel.text=[NSString stringWithFormat:@"00点 : %@",num];
        
    } falid:^(NSString *errorMsg) {
    }];

    // Do any additional setup after loading the view from its nib.
}

- (IBAction)pressTodayButton:(id)sender {
    
    [self getLocalData];
    [self isInTheRect:sender];
}

- (IBAction)pressAvgButton:(id)sender {
    
    [self isInTheRect:sender];
}

- (IBAction)pressYesterdayButton:(id)sender {
    
    [self isInTheRect:sender];
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
    [super viewDidUnload];
}
-(void)getLocalData 
{
    NSString *str=[Utility getTodayDate];
    self.localTimeLabel.text=[NSString stringWithFormat:@"%@日整点数据",str];
}

@end
