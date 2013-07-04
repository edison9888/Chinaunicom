//
//  LoginViewController.h
//  Chinaunicom
//
//  Created by  on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@property (strong,nonatomic) NSUserDefaults *userDefault;

- (IBAction)checkbox:(id)sender;
- (IBAction)login:(id)sender;

@end
