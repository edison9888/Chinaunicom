//
//  MonthDataViewController.h
//  Chinaunicom
//
//  Created by YY on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthDataViewController : UIViewController
{
    
}
@property (nonatomic,copy)NSString *str;
@property (nonatomic,weak)IBOutlet UILabel *monthLabel;
@property (nonatomic,weak)IBOutlet UILabel *monthNumLabel;
-(IBAction)popToHigherLevel:(id)sender;
@end
