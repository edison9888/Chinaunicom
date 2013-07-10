//
//  PubliceMessageViewConttoller.m
//  Chinaunicom
//
//  Created by YY on 13-7-7.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "PubliceMessageViewConttoller.h"
#import "User.h"
#import "GTMBase64.h"
#import "HttpRequestHelper.h"
@interface PubliceMessageViewConttoller (){
    UIImageView *phoneImage;
}

@property (weak, nonatomic) IBOutlet UITextView *mesagTtextview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
- (IBAction)addPic:(UIButton *)sender;
- (IBAction)sendMessage:(UIButton *)sender;
- (IBAction)back:(id)sender;

@end

@implementation PubliceMessageViewConttoller

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
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMesagTtextview:nil];
    [self setScrollview:nil];
    [self setTitleTextField:nil];
    [super viewDidUnload];
}
#pragma mark - textviewdelegate
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    return YES;
}
#pragma mark - actionsheetDelete
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
        
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.delegate = self;
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagepicker.allowsEditing = NO;
        [self presentModalViewController:imagepicker animated:YES];
    }
}
#pragma mark - 选取照片后

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    phoneImage = [[UIImageView alloc]init];
    UIImage *newImage=[self imageWithImageSimple:image  scaledToSize:CGSizeMake(310, image.size.height/image.size.width*310)];
    phoneImage.frame = CGRectMake(5, _mesagTtextview.frame.size.height+5, newImage.size.width, newImage.size.height);
    phoneImage.image = newImage;
    [_scrollview addSubview:phoneImage];
    [_scrollview setContentSize:CGSizeMake(320, phoneImage.frame.origin.y+phoneImage.frame.size.height)];
    [picker dismissModalViewControllerAnimated:YES];

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


#pragma mark - ibaction
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addPic:(UIButton *)sender {
    if ([_mesagTtextview.text length] == 0){
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"信息提示"
                                                      message:@"请输入主题"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照",@"从相册中选", nil];
    [actionsheet showInView:self.view];
    
}

- (IBAction)sendMessage:(UIButton *)sender {
    if ([self.titleTextField.text isEqualToString:@""]|| self.titleTextField.text==nil) {
        [MBHUDView hudWithBody:@"主题不能为空" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
        return;
    }
    //把图片转换成jpg格式
    NSData *imageData = UIImageJPEGRepresentation(phoneImage.image, 1.0);
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    [dictionary setObject:userid forKey:@"userId"];
    [dictionary setObject:@"jpg" forKey:@"picType"];
    [dictionary setObject:[[NSString alloc] initWithData:[GTMBase64 encodeData:imageData] encoding:NSUTF8StringEncoding] forKey:@"imageStr"];
    [dictionary setObject:self.titleTextField.text forKey:@"title"];
    [dictionary setObject:@"summary" forKey:@"summary"];
    [dictionary setObject:@"1" forKey:@"status"];
    [dictionary setObject:self.mesagTtextview.text forKey:@"content"];
    [dictionary setObject:self.reportTypeId forKey:@"reportTypeId"];
    [MBHUDView hudWithBody:@"发布中..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0 show:YES];
    [HttpRequestHelper asyncGetRequest:sendReport parameter:dictionary requestComplete:^(NSString *responseStr) {
        
        [MBHUDView dismissCurrentHUD];
        [MBHUDView hudWithBody:responseStr type:MBAlertViewHUDTypeCheckmark hidesAfter:1.0 show:YES];
        
    } requestFailed:^(NSString *errorMsg) {
        [MBHUDView dismissCurrentHUD];
        [MBHUDView hudWithBody:@"网络不稳定" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
    }];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
