//
//  BussinessDataViewController.h
//  Chinaunicom
//
//  Created by rock on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BussinessDataViewController : UIViewController
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *qianImageView;
@property (nonatomic,weak)IBOutlet UILabel *nameLabel;
@property (nonatomic,weak)IBOutlet UILabel *moneyLabel;
@property (nonatomic,weak)IBOutlet UIView *bottomView;
@property (nonatomic,weak)IBOutlet UIButton *payButton;
@property (nonatomic,weak)IBOutlet UIButton *monthButton;
@property (nonatomic,weak)IBOutlet UIButton *yearButton;
@property (nonatomic,copy)NSString *name;
-(IBAction)backToLeftMenu:(id)sender;
-(IBAction)pressPayButton:(id)sender;
-(IBAction)pressMonthButton:(id)sender;
-(IBAction)pressYearButton:(id)sender;
@end
