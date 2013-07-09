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
@property (weak, nonatomic) IBOutlet UIButton *b6;
@property (weak, nonatomic) IBOutlet UIButton *b7;
@property (weak, nonatomic) IBOutlet UIButton *b8;
@property (weak, nonatomic) IBOutlet UIButton *b9;
@property (weak, nonatomic) IBOutlet UIButton *b10;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
- (IBAction)pressAll:(UIButton *)sender;
-(IBAction)pushView:(id)sender;
- (IBAction)pressEditButton:(UIButton *)sender;

@end
