//
//  LoginViewController.m
//  Chinaunicom
//
//  Created by on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "MMDrawerController.h"
#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"
#import "MainViewController.h"
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
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
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
        [MBHUDView hudWithBody:@"请输入帐号" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
        return;
    }
    
    if ([password isEqualToString:@""] || password == nil) {
        [MBHUDView hudWithBody:@"请输入密码" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
        return;
    }
    [MBHUDView hudWithBody:@"登录中..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0 show:YES];
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:username forKey:@"userName"];
    [dictionary setValue:password forKey:@"password"];
 
    
    [[requestServiceHelper defaultService] loginWithParamter:dictionary sucess:^(User *user) {

        //存储用户信息
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
        [self.userDefault setObject:data forKey:KEY_USER_INFO];
        [self setField:self.userNameTextField forKey:KEY_USER_NAME];
    
//        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString* documentsDirectory = [paths objectAtIndex:0];
//        // Now we get the full path to the file
//        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"temphead.jpg"];
//        NSFileManager *fm = [NSFileManager defaultManager];
//        if([fm fileExistsAtPath:fullPathToFile]){
//            [fm removeItemAtPath:fullPathToFile error:Nil];
//        }
        //保存密码
        if ([[self.userDefault objectForKey:KEY_REMEMBER_PWD] boolValue]) {
            [self setField:self.passWordTextField forKey:KEY_USER_PWD];
            [self.userDefault synchronize];
        }else{
            [self.userDefault setObject:@"" forKey:KEY_USER_PWD];
            [self.userDefault synchronize];
        }
        [MBHUDView dismissCurrentHUD];
        MMDrawerController *drawerController= [self makeNewframeWork];
        [self.navigationController pushViewController:drawerController animated:YES];
        
    } falid:^(NSString *errorMsg) {
        [MBHUDView dismissCurrentHUD];
        [MBHUDView hudWithBody:@"登陆失败" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
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



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(MMDrawerController *)makeNewframeWork
{
    LeftMenuViewController * leftSideDrawerViewController = [[LeftMenuViewController alloc] init];
    
    MainViewController * centerViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    RightMenuViewController * rightSideDrawerViewController = [[RightMenuViewController alloc] init];
    
    //中间层导航条
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title@2x.png"] forBarMetrics:UIBarMetricsDefault];
    
    UINavigationController * navigationController2 = [[UINavigationController alloc] initWithRootViewController:rightSideDrawerViewController];
    [navigationController2.navigationBar setBackgroundImage:[UIImage imageNamed:@"title@2x.png"] forBarMetrics:UIBarMetricsDefault];
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:navigationController
                                             leftDrawerViewController:leftSideDrawerViewController
                                             rightDrawerViewController:navigationController2];
    [drawerController setMaximumRightDrawerWidth:280.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    return drawerController;
}
@end
