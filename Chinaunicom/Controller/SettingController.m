//
//  SettingController.m
//  Chinaunicom
//
//  Created by rock on 13-5-22.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "SettingController.h"
#import "HttpRequestHelper.h"
#import "User.h"
#import "GTMBase64.h"
#import "UIButton+WebCache.h"
#import "UIViewController+MMDrawerController.h"
#import "ChangePwdViewController.h"
#import "ASIHTTPRequest.h"
@interface SettingController ()

@end

@implementation SettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelectorInBackground:@selector(getTheVersion) withObject:nil];
    //本地版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [self.versionButton setTitle:[NSString stringWithFormat:@"当前版本 %@",version] forState:UIControlStateNormal];
}
-(void)getTheVersion
{
    NSURL*url=[NSURL URLWithString:@"http://k.webj.cn/ios/1.txt"];
    __block ASIHTTPRequest*_request =[ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setCompletionBlock:^{
        
        //服务器版本
        NSString *responseString =[request responseString];
        NSData *data = [responseString dataUsingEncoding: NSUTF8StringEncoding];
        NSDictionary *dictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString *versonString=[dictionary objectForKey:@"verson"];
        //本地版本
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        if (![version isEqualToString:versonString]) {
            [self.versionButton setEnabled:YES];
            [self.versionButton setTitle:[NSString stringWithFormat:@"当前版本%@,可升级至%@",version,versonString] forState:UIControlStateNormal];
        }else
        {
            [self.versionButton setTitle:[NSString stringWithFormat:@"当前版本%@,已是最新",version] forState:UIControlStateNormal];
        }
    }];
    [request setFailedBlock:^{
    }];
    [request startAsynchronous];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *picpath=[user.icon stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSString *urlStr=[ImageUrl stringByAppendingString:picpath];
    NSURL *url=[NSURL URLWithString:urlStr];
    [self.headButton setImageWithURL:url forState:UIControlStateNormal];
    [self initLayout];
    
}

-(void) initLayout
{
    //自定义switch...
    self.message.on=YES;
    
    self.message.onText=@"声音";
    self.message.offText=@"震动";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *isOpen=[userDefaults objectForKey:@"Sound"];
    if (isOpen==nil) {
        self.sound.on=NO;
    }else
    {
        if ([isOpen isEqualToString:@"open"]) {
            self.sound.on=YES;
        }else
        {
            self.sound.on=NO;
        }
    }

    self.sound.onText=@"开";
    self.sound.offText=@"关";
    [self.message addTarget:self action:@selector(messageChange:) forControlEvents:UIControlEventValueChanged];
    [self.sound addTarget:self action:@selector(soundChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMessage:nil];
    [self setSound:nil];
    [self setHeadButton:nil];
    [self setVersionButton:nil];
    [super viewDidUnload];
}

- (IBAction)changePwd:(id)sender {
    ChangePwdViewController *pwd=[[ChangePwdViewController alloc]initWithNibName:@"ChangePwdViewController" bundle:nil];
    [self.navigationController pushViewController:pwd animated:YES];
}

- (IBAction)quit:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)headChange:(id)sender {
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self pickImageFromAlbum];
        
    }else if (buttonIndex == 0)
    {
        [self pickImageFromCamera];
    }

}
- (void)pickImageFromAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        //检查是否有相机
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.delegate = self;
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagepicker.allowsEditing = NO;
        [self presentModalViewController:imagepicker animated:YES];
    }
}
- (void)pickImageFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.delegate = self;
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagepicker.allowsEditing = NO;
        
        [self presentModalViewController:imagepicker animated:YES];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    //把图片转换成jpg格式
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [self dismissModalViewControllerAnimated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *theImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(70.0, 70.0)];
        NSData *imageData=UIImageJPEGRepresentation(theImage, 1.0);
        
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
        User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
        [dictionary setObject:userid forKey:@"userId"];
        [dictionary setObject:@"jpg" forKey:@"picType"];
        [dictionary setObject:[[NSString alloc] initWithData:[GTMBase64 encodeData:imageData] encoding:NSUTF8StringEncoding] forKey:@"imageStr"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBHUDView hudWithBody:@"上传中..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0 show:YES];
            [HttpRequestHelper asyncGetRequest:userPhoto parameter:dictionary requestComplete:^(NSString *responseStr) {

                if ([responseStr isEqualToString:@"\"false\""]) {
                    [MBHUDView dismissCurrentHUD];
                    [MBHUDView hudWithBody:@"上传失败" type:MBAlertViewHUDTypeExclamationMark hidesAfter:1.0 show:YES];

                }else
                {
                    NSString *newString=[responseStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    user.icon=[NSString stringWithFormat:@"upload\\%@",newString];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KEY_USER_INFO];
                    [self.headButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                    [MBHUDView dismissCurrentHUD];
                    [MBHUDView hudWithBody:@"上传成功" type:MBAlertViewHUDTypeCheckmark hidesAfter:1.0 show:YES];
                }
                
            } requestFailed:^(NSString *errorMsg) {
                [MBHUDView dismissCurrentHUD];
                [MBHUDView hudWithBody:@"网络不稳定" type:MBAlertViewHUDTypeExclamationMark hidesAfter:2.0 show:YES];
            }];

        });
    });
   
}
//改变图片大小
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (IBAction)messageChange:(id)sender {

}

- (IBAction)soundChange:(DCRoundSwitch *)sender {
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if(sender.isOn)
    {
        [userDefaults setObject:@"open" forKey:@"Sound"];
        
    }else {
        [userDefaults setObject:@"close" forKey:@"Sound"];
    }
    [userDefaults synchronize];
}
////保存图片到Document
//- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
//{
//    NSData* imageData = UIImagePNGRepresentation(tempImage);
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* documentsDirectory = [paths objectAtIndex:0];
//    // Now we get the full path to the file
//    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
//    // and then we write it out
//    [imageData writeToFile:fullPathToFile atomically:NO];
//}
-(UIView *)findView:(UIView *)aView withName:(NSString *)name{
    Class cl = [aView class];
    NSString *desc = [cl description];
    
    if ([name isEqualToString:desc])
        return aView;
    
    for (NSUInteger i = 0; i < [aView.subviews count]; i++)
    {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findView:subView withName:name];
        if (subView)
            return subView;
    }
    return nil;
}
-(void)addSomeElements:(UIViewController *)viewController{
    UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
    UIView *bottomBar=[self findView:PLCameraView withName:@"PLCropOverlayBottomBar"];
    UIImageView *bottomBarImageForSave = [bottomBar.subviews objectAtIndex:0];
    UIButton *retakeButton=[bottomBarImageForSave.subviews objectAtIndex:0];
    [retakeButton setTitle:@"重拍" forState:UIControlStateNormal];  //左下角按钮
    UIButton *useButton=[bottomBarImageForSave.subviews objectAtIndex:1];
    [useButton setTitle:@"使用" forState:UIControlStateNormal];  //右下角按钮
    
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self addSomeElements:viewController];
}

- (IBAction)back:(id)sender {
    [_Controll viewWillAppear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateVersion:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://k.webj.cn/ios/index.html"]];
}
@end
