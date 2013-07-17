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

@property (weak, nonatomic) IBOutlet UILabel *b1;
@property (weak, nonatomic) IBOutlet UILabel *b2;
@property (weak, nonatomic) IBOutlet UILabel *b3;
@property (weak, nonatomic) IBOutlet UILabel *b4;
@property (weak, nonatomic) IBOutlet UILabel *b5;
@property (weak, nonatomic) IBOutlet UILabel *b6;
@property (weak, nonatomic) IBOutlet UILabel *b7;
@property (weak, nonatomic) IBOutlet UILabel *b8;
@property (weak, nonatomic) IBOutlet UILabel *b9;
@property (weak, nonatomic) IBOutlet UILabel *b10;
@property (weak, nonatomic) IBOutlet UILabel *b11;
@property (weak, nonatomic) IBOutlet UILabel *b12;

-(IBAction)popToHigherLevel:(id)sender;
- (IBAction)pressMapButton:(id)sender;
@end
