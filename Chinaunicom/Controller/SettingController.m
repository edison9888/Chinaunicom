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
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *picpath=[user.icon stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [self.headButton setImageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:picpath]]];
    [self initLayout];
}

-(void) initLayout
{
    //自定义switch...
    self.message.on=YES;
    self.sound.on=YES;
    self.message.onText=@"声音";
    self.message.offText=@"震动";
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
    [super viewDidUnload];
}
//修改密码
//参数:userId(用户ID),oldPassword(原密码),newPassword(新密码)			格式{'userId':'12','oldPassword':'22','newPassword':'a'}
//访问路径:http://localhost:8080/mobilePortal/restful/UserPrivilegeRe/updatePassword
//返回值:	成功 'true'
//失败 'false'

- (IBAction)changePwd:(id)sender {
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
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //检查是否有相机
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.delegate = self;
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagepicker.allowsEditing = NO;
        
        [self presentModalViewController:imagepicker animated:YES];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
    }
    //把图片转换成jpg格式
      NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1.0);
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    [dictionary setObject:userid forKey:@"userId"];
    [dictionary setObject:@"jpg" forKey:@"picType"];
    [dictionary setObject:[[NSString alloc] initWithData:[GTMBase64 encodeData:imageData] encoding:NSUTF8StringEncoding] forKey:@"imageStr"];
    [self dismissModalViewControllerAnimated:YES];
    [MBHUDView hudWithBody:@"上传中..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0 show:YES];
    [HttpRequestHelper asyncGetRequest:userPhoto parameter:dictionary requestComplete:^(NSString *responseStr) {
        if ([responseStr isEqualToString:@"\"true\""]) {
            [MBHUDView dismissCurrentHUD];
            [self.headButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
            [MBHUDView hudWithBody:@"上传成功" type:MBAlertViewHUDTypeCheckmark hidesAfter:2.0 show:YES];
        }else
        {
            [MBHUDView dismissCurrentHUD];
            [MBHUDView hudWithBody:@"上传失败" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
        }

    } requestFailed:^(NSString *errorMsg) {
        [MBHUDView dismissCurrentHUD];
        [MBHUDView hudWithBody:@"网络不稳定" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
    }];

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

- (IBAction)soundChange:(id)sender {
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
    [self.navigationController popViewControllerAnimated:YES];
}
@end
