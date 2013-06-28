//
//  YearDataViewController.h
//  Chinaunicom
//
//  Created by YY on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YearDataViewController : UIViewController
@property (nonatomic,copy)NSString *yearStr;
@property (nonatomic,weak)IBOutlet UILabel *yearLabel;
@property (nonatomic,weak)IBOutlet UILabel *yearNumLabel;
-(IBAction)popToHigherLevel:(id)sender;
@end
