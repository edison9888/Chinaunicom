//
//  PayViewController.h
//  Chinaunicom
//
//  Created by YY on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : UIViewController
@property (nonatomic,copy)NSString *str;
@property (weak, nonatomic) IBOutlet UIButton *yesterdayButton;
@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *avgButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *localTimeLabel;
- (IBAction)pressTodayButton:(id)sender;
- (IBAction)pressAvgButton:(id)sender;
- (IBAction)pressYesterdayButton:(id)sender;
-(IBAction)popToHigherLevel:(id)sender;
@end
