//
//  PayViewController.h
//  Chinaunicom
//
//  Created by YY on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointImageView.h"
@interface PayViewController : UIViewController<pointDelegate>
@property (nonatomic,strong)NSDictionary  *todayDict;
@property (nonatomic,strong)NSDictionary *avgDict;
@property (nonatomic,strong)NSDictionary *yesterdayDict;
@property (nonatomic,strong)NSMutableArray *todayArray;
@property (nonatomic,strong)NSMutableArray *yesterdayArray;
@property (nonatomic,strong)NSMutableArray *avgArray;
@property (nonatomic,copy)NSString *str;
@property (weak, nonatomic) IBOutlet UIButton *yesterdayButton;
@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *avgButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet PointImageView *pointImageView;
@property (weak, nonatomic) IBOutlet UILabel *localTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *blueDian;


- (IBAction)pressTodayButton:(id)sender;
- (IBAction)pressAvgButton:(id)sender;
- (IBAction)pressYesterdayButton:(id)sender;
-(IBAction)popToHigherLevel:(id)sender;
- (IBAction)pressMapButton:(id)sender;
@end
