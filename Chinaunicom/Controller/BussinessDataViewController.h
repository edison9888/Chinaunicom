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
@property (nonatomic,weak)IBOutlet UILabel *nameLabel;
@property (nonatomic,copy)NSString *name;
-(IBAction)backToLeftMenu:(id)sender;
@end
