//
//  MonthDataViewController.h
//  Chinaunicom
//
//  Created by YY on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthPointImageView.h"
@interface MonthDataViewController : UIViewController<monthPointDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *bluedian;
@property (weak, nonatomic) IBOutlet UIImageView *anotherBlue;
@property (weak, nonatomic) IBOutlet MonthPointImageView *monthPointImageView;
@property (nonatomic,copy)NSString *str;
@property (nonatomic,weak)IBOutlet UILabel *monthLabel;
@property (nonatomic,weak)IBOutlet UILabel *monthNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *sMonthLabel;
-(IBAction)popToHigherLevel:(id)sender;
- (IBAction)pressMapButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageVIew;
@end
