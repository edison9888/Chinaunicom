//
//  SendAudiReport.m
//  Chinaunicom
//
//  Created by rock on 13-6-14.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "SendAudiReport.h"
#import "SysConfig.h"
#import "HttpRequestHelper.h"
#import "GTMBase64.h"
#import "User.h"
@interface SendAudiReport ()

@end

@implementation SendAudiReport

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"发布信息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLayout];
   
}
-(void)initLayout
{
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
    
    self.sendView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"send_bg"]];
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.navigationController.navigationBar addGestureRecognizer:singleTouch];
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

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
   [self dismissModalViewControllerAnimated:YES];
    //把图片转换成jpg格式
    
    NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1.0);
        UIImage *image = [UIImage imageWithData:imageData];
        [self saveImage:image WithName:@"temp.jpg"];
    
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
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [self addSomeElements:viewController];
}
- (void)viewDidUnload {
    [self setSendView:nil];
    [self setReporttitle:nil];
    [self setReportcontent:nil];
    [self setSendMessageEvent:nil];
    [super viewDidUnload];
}
- (IBAction)addimage:(id)sender {
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
    [sheet showInView:self.view];
}

- (IBAction)sendreport:(id)sender {
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
       NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
        User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
       NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    [dictionary setObject:userid forKey:@"userId"];
    [dictionary setObject:@"" forKey:@"picType"];
    [dictionary setObject:@"" forKey:@"imageStr"];
    [dictionary setObject:self.reporttitle.text forKey:@"title"];
    [dictionary setObject:@"summary" forKey:@"summary"];
    [dictionary setObject:@"1" forKey:@"status"];
     [dictionary setObject:self.reportcontent.text forKey:@"content"];
    [dictionary setObject:self.reportTypeId forKey:@"reportTypeId"];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"temp.jpg"];
   NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:fullPathToFile]){
//        result = YES;
        [dictionary setObject:@"jpg" forKey:@"picType"];
        NSData *imageData= [NSData dataWithContentsOfFile:fullPathToFile];
        [dictionary setObject:[[NSString alloc] initWithData:[GTMBase64 encodeData:imageData] encoding:NSUTF8StringEncoding] forKey:@"imageStr"];
        [fm removeItemAtPath:fullPathToFile error:Nil];
    }
    [HttpRequestHelper asyncGetRequest:sendReport parameter:dictionary requestComplete:^(NSString *responseStr) {
        
    } requestFailed:^(NSString *errorMsg) {
       
    }];
}
- (void)dismissKeyboard {
    
    [self.reporttitle resignFirstResponder];
    [self.reportcontent resignFirstResponder];
}

#pragma mark 解决虚拟键盘挡住UITextField的方法
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    CGRect frame = self.sendMessageEvent.frame;//textField.frame;
    int offset = frame.origin.y + 200 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{

    [self.reporttitle resignFirstResponder];
    [self.reportcontent resignFirstResponder];
    //还原view位置
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0,self.view.frame.size.width,self.view.frame.size.height);
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
   
    
    return YES;
    
}


@end






