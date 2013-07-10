//
//  ChangePwdViewController.m
//  Chinaunicom
//
//  Created by YY on 13-7-9.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "HttpRequestHelper.h"
#import "User.h"
@interface ChangePwdViewController ()

@end

@implementation ChangePwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_oldPwd becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOldPwd:nil];
    [self setChangePwd:nil];
    [self setAgainNewPwd:nil];
    [super viewDidUnload];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)savePwd:(UIButton *)sender {
    if ([_changePwd.text isEqualToString:@""]||_changePwd.text==nil) {
        [MBHUDView hudWithBody:@"新密码不能为空" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
    }else if([_oldPwd.text isEqualToString:@""]||_oldPwd.text==nil)
    {
         [MBHUDView hudWithBody:@"旧密码不能为空" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
    }else if ([_againNewPwd.text isEqualToString:@""]||_againNewPwd.text==nil)
    {
         [MBHUDView hudWithBody:@"重复密码不能为空" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
    }else if (![_changePwd.text isEqualToString:_againNewPwd.text])
    {
         [MBHUDView hudWithBody:@"新密码不相同" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
    }else
    {
        NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
        User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];

        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:userid,@"userId",_oldPwd.text,@"oldPassword",_changePwd.text,@"newPassword", nil];
        [HttpRequestHelper asyncGetRequest:userPwd parameter:dict requestComplete:^(NSString *responseStr) {
            if ([responseStr isEqualToString:@"\"true\""]) {
                    [MBHUDView hudWithBody:@"修改成功" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
            }else
            {
                    [MBHUDView hudWithBody:@"修改失败" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
            }
        } requestFailed:^(NSString *errorMsg) {
            [MBHUDView hudWithBody:@"网络不稳定" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
        }];
    }
    
}
@end
