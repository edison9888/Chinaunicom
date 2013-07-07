//
//  PubliceMessageViewConttoller.m
//  Chinaunicom
//
//  Created by YY on 13-7-7.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "PubliceMessageViewConttoller.h"

@interface PubliceMessageViewConttoller (){
    NSMutableArray *arrimage;
    UIView *pickimageview;
}

@property (weak, nonatomic) IBOutlet UITextView *mesagTtextview;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
- (IBAction)addPic:(UIButton *)sender;
- (IBAction)sendMessage:(UIButton *)sender;

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
    arrimage = [[NSMutableArray alloc]init];
      
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewChange)
                                                name:UITextViewTextDidChangeNotification
                                              object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    /* Move the toolbar to above the keyboard */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect frame = _mesagTtextview.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height - kbSize.height;
	_mesagTtextview.frame = frame;
	[UIView commitAnimations];
//    keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    /* Move the toolbar back to bottom of the screen */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect frame = _mesagTtextview.frame;
    
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    
	_mesagTtextview.frame = frame;
	[UIView commitAnimations];
//    keyboardIsVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMesagTtextview:nil];
    [self setScrollview:nil];
    [super viewDidUnload];
}

#pragma mark - notifcation
- (void)textViewChange{
    
    CGRect cg = _mesagTtextview.frame;
    CGSize size = [_mesagTtextview.text sizeWithFont: [UIFont systemFontOfSize:17] constrainedToSize:_mesagTtextview.frame.size lineBreakMode:UILineBreakModeWordWrap];
    float textviewhei = size.height;
    
    if(textviewhei == 0.0){
        textviewhei = 19.0;
    }
    float fHeight = textviewhei + 17.0;
    
    CGSize siz = CGSizeMake(320, fHeight);
    [_scrollview setContentSize:siz];
    
    cg.size.height = fHeight;
    _mesagTtextview.frame = cg;
    if(pickimageview){
        pickimageview.frame=CGRectMake(0, _mesagTtextview.frame.size.height+_mesagTtextview.frame.origin.y+5, 320, pickimageview.frame.size.height);
    }
    NSLog(@"textview  is  form  -%@",_mesagTtextview);
    
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
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        
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

    if(!pickimageview){
        pickimageview = [[UIView alloc]init];
        [_scrollview addSubview:pickimageview];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageView *phoneimage = [[UIImageView alloc]init];
    UIImage *newImage=[self imageWithImageSimple:image  scaledToSize:CGSizeMake(310, image.size.height/image.size.width*310)];
    phoneimage.frame = CGRectMake(5, pickimageview.frame.size.height+5, newImage.size.width, newImage.size.height);
    
    phoneimage.image = newImage;
    pickimageview.frame=CGRectMake(0, _mesagTtextview.frame.size.height+_mesagTtextview.frame.origin.y+5, 320, pickimageview.frame.size.height+phoneimage.frame.size.height);

    [pickimageview addSubview:phoneimage];
    [_scrollview setContentSize:CGSizeMake(320, _scrollview.contentSize.height+pickimageview.frame.size.height)];
//    //把图片转换成jpg格式
//    NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1.0);
    [picker dismissModalViewControllerAnimated:YES];
    
//    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
//    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
//    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
//    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
//    [dictionary setObject:userid forKey:@"userId"];
//    [dictionary setObject:@"jpg" forKey:@"picType"];
//    [dictionary setObject:[[NSString alloc] initWithData:[GTMBase64 encodeData:imageData] encoding:NSUTF8StringEncoding] forKey:@"imageStr"];
//    [MBHUDView hudWithBody:@"上传中..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0 show:YES];
//    [HttpRequestHelper asyncGetRequest:userPhoto parameter:dictionary requestComplete:^(NSString *responseStr) {
//        if ([responseStr isEqualToString:@"\"true\""]) {
//            [MBHUDView dismissCurrentHUD];
//            [self.headButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
//            [MBHUDView hudWithBody:@"上传成功" type:MBAlertViewHUDTypeCheckmark hidesAfter:2.0 show:YES];
//        }else
//        {
//            [MBHUDView dismissCurrentHUD];
//            [MBHUDView hudWithBody:@"上传失败" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
//        }
//        
//    } requestFailed:^(NSString *errorMsg) {
//        [MBHUDView dismissCurrentHUD];
//        [MBHUDView hudWithBody:@"网络不稳定" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
//    }];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
}
@end
