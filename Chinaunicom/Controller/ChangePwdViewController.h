//
//  ChangePwdViewController.h
//  Chinaunicom
//
//  Created by YY on 13-7-9.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePwdViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *changePwd;
@property (weak, nonatomic) IBOutlet UITextField *againNewPwd;
- (IBAction)savePwd:(UIButton *)sender;

@end
