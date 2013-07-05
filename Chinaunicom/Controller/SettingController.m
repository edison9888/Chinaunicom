//
//  SettingController.m
//  Chinaunicom
//
//  Created by rock on 13-5-22.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "SettingController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HttpRequestHelper.h"
#import "SysConfig.h"
#import "User.h"
#import "GTMBase64.h"
#import "UIImageView+WebCache.h"
@interface SettingController ()

@end

@implementation SettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLayout];
}

-(void) initLayout
{
    //返回按钮
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 32, 32);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backItem;
    /*分割线1*/
    UIImageView *imageViewTopDiv1=[[UIImageView alloc] initWithFrame:CGRectMake(40, -10, 30, 63)];
    [imageViewTopDiv1 setImage:[UIImage imageNamed:@"topDividingLine"]];
    [imageViewTopDiv1 setTag:101];
    [self.navigationController.navigationBar addSubview:imageViewTopDiv1];
    
//    //返回按钮
//    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *image=[UIImage imageNamed:@"left_arrow"];
//    backButton.frame = CGRectMake(10, 0, 30, 30);
//    [backButton setBackgroundImage:image forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem=backItem;
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"temphead.jpg"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:fullPathToFile]){
        [self.icon setImage:[UIImage imageWithContentsOfFile:fullPathToFile]];
    }else{
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *picpath=[user.icon stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [self.icon setImageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:picpath]]];
    }
    
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

-(void)back
{
//    RightMenuViewController *right=[[RightMenuViewController alloc] init];
//    BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:right];
//    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [myDelegate.revealSideViewController pushViewController:nav onDirection:PPRevealSideDirectionRight withOffset:50 animated:YES forceToPopPush:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMessage:nil];
    [self setSound:nil];
    [self setQuit:nil];
    [self setIcon:nil];
    [super viewDidUnload];
}

- (IBAction)quit:(id)sender {
//    LoginViewController *loginCtrl=[[LoginViewController alloc] init];
//    BaseNavigationController *baseNav=[[BaseNavigationController alloc] initWithRootViewController:loginCtrl];
//    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    myDelegate.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:baseNav];
//    [[UIApplication sharedApplication] keyWindow].rootViewController= myDelegate.revealSideViewController;
    
//    LoginViewController *loginCtrl=[[LoginViewController alloc] init];
//    BaseNavigationController *baseNav=[[BaseNavigationController alloc] initWithRootViewController:loginCtrl];
//    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    myDelegate.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:baseNav];
//    [[UIApplication sharedApplication] keyWindow].rootViewController= myDelegate.revealSideViewController;
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
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
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
//    [HttpRequestHelper asyncPostRequest:userPhoto parameter:dictionary filename:@"jpg" fileData:    } requestFailed:^(NSString *errorMsg) {
//        //<#code#>
//        NSLog(@"error %@",errorMsg);
//    
//    }];
    
    [HttpRequestHelper asyncGetRequest:userPhoto parameter:dictionary requestComplete:^(NSString *responseStr) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.tempHead = [self imageWithImageSimple:image scaledToSize:CGSizeMake(128.0, 228.0)];
            self.icon.image = self.tempHead;
        [self saveImage:image WithName:@"temphead.jpg"];

    } requestFailed:^(NSString *errorMsg) {
     //   <#code#>
        NSLog(@"error");
    }];
//     [[EPUploader alloc]initWithURL:[NSURL URLWithString:userPhoto] filePath:imageData delegate:self doneSelector:@selector(uploadHeadImgFinish:) errorSelector:@selector(uploadHeadImgError:)];

}

-(void)uploadHeadImgFinish:(id)sender
{
    NSLog(@"上传成功");
}

-(void)uploadHeadImgError:(id)sender
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"上传头像失败!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
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

- (IBAction)headChange:(id)sender {
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
    [sheet showInView:self.view];
}
//保存图片到Document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}
-(UIView *)findView:(UIView *)aView withName:(NSString *)name{
    Class cl = [aView class];
    NSString *desc = [cl description];
    
    if ([name isEqualToString:desc])
        return aView;
    
    for (NSUInteger i = 0; i < [aView.subviews count]; i++)
    {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findView:subView withName:name];
        //        NSLog(@"subview = %@",subView);
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



@end
