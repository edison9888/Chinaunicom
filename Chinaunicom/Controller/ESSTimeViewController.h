//
//  ESSTimeViewController.h
//  Chinaunicom
//
//  Created by rock on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSTimeViewController : UIViewController
@property (nonatomic,weak) IBOutlet UIImageView *lineImageView;
@property (nonatomic,weak) IBOutlet UIButton *threeGButton;
@property (nonatomic,weak) IBOutlet UIButton *iphoneFiveButton;
@property (nonatomic,weak) IBOutlet UIButton *iphone4SButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *hdLabel;
@property (weak, nonatomic) IBOutlet UILabel *hnLabel;
@property (weak, nonatomic) IBOutlet UILabel *hbLabel;
@property (weak, nonatomic) IBOutlet UILabel *hzLabel;
@property (weak, nonatomic) IBOutlet UILabel *xbLabel;
@property (weak, nonatomic) IBOutlet UILabel *xnLabel;
@property (weak, nonatomic) IBOutlet UILabel *dbLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *vpLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,copy)NSString *titleStr;
- (IBAction)pressThreeGbutton:(UIButton *)sender;
- (IBAction)pressIphoneFiveButton:(UIButton *)sender;
- (IBAction)pressIphoneFour:(UIButton *)sender;

-(IBAction)back:(id)sender;
@end
