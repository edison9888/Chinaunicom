//
//  AudiReportDetail.m
//  Chinaunicom
//
//  Created by rock on 13-6-17.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "AudiReportDetail.h"
#import "User.h"
#import "SysConfig.h"
#import "requestServiceHelper.h"
#import "HttpRequestHelper.h"
@interface AudiReportDetail ()

@end

@implementation AudiReportDetail
@synthesize myReport,myReportDetail,contentDetailLabel;
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
    // Do any additional setup after loading the view from its nib.
    [self initLayout];
    [self initDataSource];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initDataSource
{
    [self dismissKeyboard];
//    [self showLoadingActivityViewWithString:@"正在加载..."];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: self.myReport.reportId forKey:@"reportId"];
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    [dictionary setValue: userid forKey:@"userId"];
    
    [[requestServiceHelper defaultService] getReportDetail:dictionary sucess:^(NSDictionary *reportDetail) {
//        [self hideLoadingActivityView];
        self.myReportDetail=reportDetail;
        self.reporttitle.text=self.myReportDetail.reportTitle;
        self.reportdate.text=[self.myReportDetail.published substringToIndex:10];
        self.contentDetailLabel.text=self.myReportDetail.reportContent;
        [self.contentDetailLabel setFrame:CGRectMake(0 , 104,320, self.contentDetailLabel.contentSize.height)];
        y=self.contentDetailLabel.contentSize.height;
        NSString *picpath=[self.myReportDetail.picPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        
        if (picpath!=NULL&&![picpath isEqualToString:@""]) {
            if([picpath rangeOfString:@","].length>0){
                NSArray *picarray=[picpath componentsSeparatedByString:@","];
                for(int i=0;i<(picarray.count>3?3:picarray.count);i++){
                    [self compearImage:[picarray objectAtIndex:i]];
                    
                }
            }
            else{
                [self compearImage:picpath];
            }
        }
        
    } falid:^(NSString *errorMsg) {
//        [self hideLoadingActivityView];
    }];
}
-(void)compearImage :(NSString *) picpath{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *cachedImage = [manager imageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:picpath]]]; // 将需要缓存的图片加载进来
    if (cachedImage) {
        // 如果Cache命中，则直接利用缓存的图片进行有关操
        UIImageView *contextImage=[[UIImageView alloc] init];
        
        [contextImage setImage:[self imageWithImageSimple:cachedImage  scaledToSize:CGSizeMake(310, cachedImage.size.height/cachedImage.size.width*310)]];
        [contextImage setFrame:CGRectMake(5, (self.scrollview.contentSize.height>1?self.scrollview.contentSize.height:110+y)+5, 310,cachedImage.size.height/cachedImage.size.width*310)];
        [self.scrollview addSubview:contextImage];
        self.scrollview.contentSize=CGSizeMake(320, (self.scrollview.contentSize.height>y?self.scrollview.contentSize.height:(y+110))+5+cachedImage.size.height/cachedImage.size.width*310);
        
    } else {
        // 如果Cache没有命中，则去下载指定网络位置的图片，并且给出一个委托方法
        
        [manager downloadWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:picpath]] delegate:self];
    }
}
// 当下载完成后，调用回调方法，使下载的图片显示
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
    // Do something with the downloaded image
    UIImageView *contextImage=[[UIImageView alloc] init];
    [contextImage setImage:[self imageWithImageSimple:image  scaledToSize:CGSizeMake(310, image.size.height/image.size.width*310)]];
    [contextImage setFrame:CGRectMake(5, (self.scrollview.contentSize.height>1?self.scrollview.contentSize.height:(110+y))+5, 310,image.size.height/image.size.width*310)];   // [self.scorollview setFrame:CGRectMake(0, 0,
    [self.scrollview addSubview:contextImage];
    self.scrollview.contentSize=CGSizeMake(320, (self.scrollview.contentSize.height>y?self.scrollview.contentSize.height:(110+y))+5+image.size.height/image.size.width*310);
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
#pragma mark - initLayout
-(void)initLayout
{
    
//    [self.topview setBackgroundColor:[CommonHelper hexStringToColor:@"#0E5DBF"]];
    [self.reporttitle setTextColor:[UIColor whiteColor]];
    [self.reportdate setTextColor:[UIColor whiteColor]];
    [self.scrollview setShowsVerticalScrollIndicator:NO];
    //返回按钮
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 32, 32);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backItem;
     self.title=@"待审核";
    /*分割线1*/
    UIImageView *imageViewTopDiv1=[[UIImageView alloc] initWithFrame:CGRectMake(40, -10, 30, 63)];
    [imageViewTopDiv1 setImage:[UIImage imageNamed:@"topDividingLine"]];
    [imageViewTopDiv1 setTag:101];
    [self.navigationController.navigationBar addSubview:imageViewTopDiv1];
    
    //添加底部navbar
    UINavigationBar *bottomBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 372, 320, 44)];
    [bottomBar setBackgroundImage:[UIImage imageNamed:@"bottomNav"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:bottomBar];
    
    //为nabar添加对应的items
    /*发布消息*/
    UIButton* messageButton= [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(20, 3, 80, 40);
    [messageButton setTitle:@"通过审核" forState:UIControlStateNormal];
    [messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(sendpassReport:) forControlEvents:UIControlEventTouchUpInside];
    [messageButton setTag:1];
    [bottomBar addSubview:messageButton];
    /*分割线1*/
    UIImageView *imageViewBottomDiv1=[[UIImageView alloc] initWithFrame:CGRectMake(145, 0, 30, 44)];
    [imageViewBottomDiv1 setImage:[UIImage imageNamed:@"dividingLine"]];
    [bottomBar addSubview:imageViewBottomDiv1];
    
    /*待审核*/
    UIButton* nonAuditButton= [UIButton buttonWithType:UIButtonTypeCustom];
    nonAuditButton.frame = CGRectMake(200, 2, 80, 40);
    [nonAuditButton setTitle:@"退回稿件" forState:UIControlStateNormal];
    [nonAuditButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nonAuditButton setTag:2];
    [nonAuditButton addTarget:self action:@selector(backReport:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:nonAuditButton];
 
    
    self.contentDetailLabel=[[UITextView alloc] init];
    [self.contentDetailLabel setFrame:CGRectMake(0, 104, 320, 240)];
    [self.contentDetailLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentDetailLabel setEditable:NO];
    [self.contentDetailLabel setScrollEnabled:NO];
    self.contentDetailLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.contentDetailLabel.font= [UIFont systemFontOfSize:18];
    [self.scrollview addSubview:self.contentDetailLabel];
    //    self.contentDetailLabel＝[UILabel alloc]
}

#pragma mark - viewWillAppear
- (void) viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
//    [self.navigationController.navigationBar setHidden:YES];
}

-(IBAction)sendpassReport:(id)sender{
//    [self showLoadingActivityViewWithString:@"提交审核..."];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    [dictionary setObject:userid forKey:@"userId"];
    [dictionary setObject:self.myReport.reportId forKey:@"reportId"];
    [HttpRequestHelper asyncGetRequest:passReport parameter:dictionary requestComplete:^(NSString *responseStr) {
    
//        [self hideLoadingActivityView];
//        [ALToastView toastInView:self.view withText:@"审核成功"];
    } requestFailed:^(NSString *errorMsg) {
//        [ALToastView toastInView:self.view withText:@"审核失败"];
//        [self hideLoadingActivityView];
    }];
}
-(IBAction)backReport:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退回报告" message:@" " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
          UITextField *tf=[alertView textFieldAtIndex:0];
//        [self showLoadingActivityViewWithString:@"退回稿件..."];
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
        User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
        [dictionary setObject:userid forKey:@"userId"];
        [dictionary setObject:self.myReport.reportId forKey:@"reportId"];
        [dictionary setObject:tf.text forKey:@"backReason"];
        [HttpRequestHelper asyncGetRequest:backReportUrl parameter:dictionary requestComplete:^(NSString *responseStr) {
//            [ALToastView toastInView:self.view withText:@"退回成功"];
//            [self hideLoadingActivityView];
        } requestFailed:^(NSString *errorMsg) {
//            [ALToastView toastInView:self.view withText:@"退回失败"];
//            [self hideLoadingActivityView];
        }];
    }
    
}
//返回
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dismissKeyboard {
    [self.contentDetailLabel resignFirstResponder];
}

- (void)viewDidUnload {
    [self setReporttitle:nil];
    [self setReportdate:nil];
    [self setScrollview:nil];
    [self setTopview:nil];
    [self setBottomBar:nil];
    [super viewDidUnload];
}

@end
