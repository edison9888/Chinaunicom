//
//  YearDataViewController.h
//  Chinaunicom
//
//  Created by YY on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YearPointImageView.h"
@interface YearDataViewController : UIViewController<yearPointDelegate>
@property (nonatomic,copy)NSString *yearStr;
@property (nonatomic,weak)IBOutlet UILabel *yearLabel;
@property (nonatomic,weak)IBOutlet UILabel *yearNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearNameLable;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet YearPointImageView *yearPointImage;
-(IBAction)popToHigherLevel:(id)sender;
- (IBAction)pressMapButton:(id)sender;
@end
