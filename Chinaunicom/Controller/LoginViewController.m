//
//  LoginViewController.m
//  Chinaunicom
//
//  Created by on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "LoginViewController.h"
#import "SysConfig.h"
#import "User.h"
#import "requestServiceHelper.h"
#import "ASIHTTPRequest.h"
#import "TKAlertCenter.h"
#import "Reachability.h"


@interface LoginViewController ()
{
    BOOL isOff;
}
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"登录";
     
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLayout];
}


-(void) initLayout{
    
    //背景图片
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    //修改placeholder颜色
    [self.userNameTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passWordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //设置光标初始位置
    [self.passWordTextField setSecureTextEntry:YES];//设置成密码框
    UIView *userNamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    self.userNameTextField.leftView = userNamePaddingView;
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    //
    UIView *pwdPaddingUView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    self.passWordTextField.leftView = pwdPaddingUView;
    self.passWordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.userDefault=[NSUserDefaults standardUserDefaults];
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:KEY_REMEMBER_PWD]);
    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_LEFTMENU_INFO];
    //[self.userDefault synchronize];
   // NSLog(@"left menu: %@",[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO]);
  // NSLog(@"left menu: %@",[[NSUserDefaults standardUserDefaults] objectForKey:KEY_LEFTMENU_INFO]);
}

#pragma mark 该方法为点击虚拟键盘Return，要调用的代理方法：隐藏虚拟键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.userNameTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:KEY_REMEMBER_PWD] boolValue]) {
        ((UIButton*)[self.view viewWithTag:1]).selected=YES;
        self.userNameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
        self.passWordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_PWD];
    }else{
        self.userNameTextField.text = @"";
        self.passWordTextField.text = @"";
       ((UIButton*)[self.view viewWithTag:1]).selected=NO;
    }
   
}

- (IBAction)checkbox:(id)sender {
    UIButton *btn=(UIButton *)sender;
    //btn.selected=!btn.selected;
    
    if ([[self.userDefault objectForKey:KEY_REMEMBER_PWD] boolValue]) {

        btn.selected=NO;
    }else{

        btn.selected=YES;
    }
    BOOL isRemenber = [[self.userDefault objectForKey:KEY_REMEMBER_PWD] boolValue];
    NSNumber *number = [NSNumber numberWithBool:!isRemenber];
    [self.userDefault setObject:number forKey:KEY_REMEMBER_PWD];
    [self.userDefault synchronize];
    
}
- (void)setField:(UITextField *)field forKey:(NSString *)key{
    if (field.text != nil){
        [self.userDefault setObject:field.text forKey:key];
    } else {
        [self.userDefault removeObjectForKey:key];
    }
}
- (IBAction)login:(id)sender {
 
      [self.userNameTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    
    NSString *username=self.userNameTextField.text;
    NSString *password=self.passWordTextField.text;

    
    if ([username isEqualToString:@""] || username==nil ) {
        
        [self showAlertViewWithString:@"帐号不能为空" setDelegate:nil setTag:0];
        return;
    }
    
    if ([password isEqualToString:@""] || password == nil) {
        [self showAlertViewWithString:@"密码不能为空" setDelegate:nil setTag:0];
        return;
    }
    
    [self showLoadingActivityViewWithString:@"登录中..."];
    self.view.userInteractionEnabled=NO;
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:username forKey:@"userName"];
    [dictionary setValue:password forKey:@"password"];
 
    
    [[requestServiceHelper defaultService] loginWithParamter:dictionary sucess:^(User *user) {

        //存储用户信息
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
        [self.userDefault setObject:data forKey:KEY_USER_INFO];
        [self setField:self.userNameTextField forKey:KEY_USER_NAME];
        //
        [self getReportType:[NSString stringWithFormat:@"%d",[user.userId intValue]]];
        
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        // Now we get the full path to the file
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"temphead.jpg"];
        NSFileManager *fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:fullPathToFile]){
            [fm removeItemAtPath:fullPathToFile error:Nil];
        }
        //保存密码
        if ([[self.userDefault objectForKey:KEY_REMEMBER_PWD] boolValue]) {
            [self setField:self.passWordTextField forKey:KEY_USER_PWD];
            [self.userDefault synchronize];
        }else{
            [self.userDefault setObject:@"" forKey:KEY_USER_PWD];
            [self.userDefault synchronize];
        }

        self.view.userInteractionEnabled = YES;
        
    } falid:^(NSString *errorMsg) {
        self.view.userInteractionEnabled = YES;
            [self hideLoadingActivityView];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:errorMsg];
    }];


}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger tag=textField.tag;
    
    if(tag==10010){
        [textField setBackground:[UIImage imageNamed:@"user2"]];
        [self.passWordTextField setBackground:[UIImage imageNamed:@"password1"]];
    }
    else{
        [textField setBackground:[UIImage imageNamed:@"password2"]];
        [self.userNameTextField setBackground:[UIImage imageNamed:@"user1"]];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tag=textField.tag;
    
    if (isOff==YES) {
        if(tag==10010){
            [textField setBackground:[UIImage imageNamed:@"user1"]];
            [self.passWordTextField setBackground:[UIImage imageNamed:@"password2"]];
        }
        else{
            [textField setBackground:[UIImage imageNamed:@"password1"]];
            [self.userNameTextField setBackground:[UIImage imageNamed:@"user2"]];
        }
    }
}
- (IBAction)backgroundTouch:(id)sender {
    isOff = NO;
    [self.userNameTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}

//获取我已关注的菜单分类
-(void)getReportType:(NSString*)userId
{
    
    [[requestServiceHelper defaultService] getMyMenuReportType:userId sucess:^(NSArray *array) {
            [self hideLoadingActivityView];
        
        [self.userDefault setObject:array forKey:KEY_LEFTMENU_INFO];
        [self.userDefault synchronize];
        
        MainViewController *safeDetailCtrl=[[MainViewController alloc] init];
        [self.navigationController pushViewController:safeDetailCtrl animated:YES];
    
    } falid:^(NSString *errorMsg) {
        NSLog(@"%@",errorMsg);
        [self hideLoadingActivityView];
    }];
    
}

@end
