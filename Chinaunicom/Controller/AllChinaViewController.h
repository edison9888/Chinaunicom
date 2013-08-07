//
//  AllChinaViewController.h
//  Chinaunicom
//
//  Created by rock on 13-8-7.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AllChinaViewController : UIViewController
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic,weak) IBOutlet UIButton *threeGButton;
@property (nonatomic,weak) IBOutlet UIButton *iphoneFiveButton;
@property (nonatomic,weak) IBOutlet UIButton *iphone4SButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
-(IBAction)popToHigherLevel:(id)sender;
@end
