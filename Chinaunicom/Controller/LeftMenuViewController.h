//
//  LeftMenuViewController.h
//  Chinaunicom
//
//  Created by rock on 13-7-8.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *b1;
@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIButton *b3;
@property (weak, nonatomic) IBOutlet UIButton *b4;
@property (weak, nonatomic) IBOutlet UIButton *b5;

- (IBAction)b1:(UIButton *)sender;
- (IBAction)b2:(UIButton *)sender;
- (IBAction)b3:(UIButton *)sender;
- (IBAction)b4:(UIButton *)sender;
- (IBAction)b5:(UIButton *)sender;
- (IBAction)b6:(UIButton *)sender;
- (IBAction)b7:(UIButton *)sender;
- (IBAction)b8:(UIButton *)sender;
- (IBAction)b9:(UIButton *)sender;
- (IBAction)b10:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)pressEditButton:(UIButton *)sender;

@end
