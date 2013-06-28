//
//  SafeDetailController.m
//  Chinaunicom
//
//  Created by rock on 13-5-5.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "ContextDetailController.h"
#import "requestServiceHelper.h"
#import "SysConfig.h"
#import "Report.h"
#import "User.h"
#import "ReportDetail.h"
#import "HttpRequestHelper.h"
@interface ContextDetailController ()

@end

@implementation ContextDetailController
@synthesize favButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLayout];
    [self initDataSource];
    
    self.scorollview.alwaysBounceVertical = YES;
	self.scorollview.alwaysBounceHorizontal = NO;
    self.scorollview.showsHorizontalScrollIndicator=NO;
}
#pragma mark - initDataSource
-(void)initDataSource
{
    [self dismissKeyboard];
    isHasFav=false;
    [self showLoadingActivityViewWithString:@"正在加载..."];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: self.myReport.reportId forKey:@"reportId"];
    
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    [dictionary setValue: userid forKey:@"userId"];
    
    [[requestServiceHelper defaultService] getReportDetail:dictionary sucess:^(ReportDetail *reportDetail) {
        [self hideLoadingActivityView];
        self.myReportDetail=reportDetail;
        self.comFromContextLabel.text=self.myReportDetail.reportTitle;
        self.dateTimeLabel.text=[self.myReportDetail.published substringToIndex:10];
        self.contentDetailLabel.text=self.myReportDetail.reportContent;
        [self.contentDetailLabel setFrame:CGRectMake(0 , 104,320, self.contentDetailLabel.contentSize.height)];
        y=self.contentDetailLabel.contentSize.height;
        
        self.totalLabel.text=[[@"共" stringByAppendingString: self.myReportDetail.size] stringByAppendingString:@"条"];
        NSString *type=self.myReportDetail.fromtype;
        NSString *typeName=nil;
        if ([type isEqualToString:@"65"]){
            typeName=@"安全类";
        }else if ([type isEqualToString:@"18"]) {
            typeName=@"分析类";
        }
        else if([type isEqualToString:@"17"]){
            typeName=@"维护类";
        }
        else if([type isEqualToString:@"214"]){
            typeName=@"应用类";
        }
        else if([type isEqualToString:@"16"])
        {
            typeName=@"应用类";
        }
        else{
            typeName=@"其他";
        }
        self.comFromLabel.text=[@"来自" stringByAppendingString: typeName];
        if([self.myReportDetail.isFav isEqualToString:@"true"])
        {
            isHasFav=true;
            [favButton setBackgroundImage:[UIImage imageNamed:@"favorites@2x"] forState:UIControlStateNormal];
        }
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
        [self hideLoadingActivityView];
    }];
}
-(void)compearImage :(NSString *) picpath{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *cachedImage = [manager imageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:picpath]]]; // 将需要缓存的图片加载进来
    if (cachedImage) {
        // 如果Cache命中，则直接利用缓存的图片进行有关操
        UIImageView *contextImage=[[UIImageView alloc] init];
        
        [contextImage setImage:[self imageWithImageSimple:cachedImage  scaledToSize:CGSizeMake(310, cachedImage.size.height/cachedImage.size.width*310)]];
        [contextImage setFrame:CGRectMake(5, (self.scorollview.contentSize.height>1?self.scorollview.contentSize.height:110+y)+5, 310,cachedImage.size.height/cachedImage.size.width*310)];
        [self.scorollview addSubview:contextImage];
        self.scorollview.contentSize=CGSizeMake(320, (self.scorollview.contentSize.height>y?self.scorollview.contentSize.height:(y+110))+5+cachedImage.size.height/cachedImage.size.width*310);

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
    [contextImage setFrame:CGRectMake(5, (self.scorollview.contentSize.height>1?self.scorollview.contentSize.height:(110+y))+5, 310,image.size.height/image.size.width*310)];   // [self.scorollview setFrame:CGRectMake(0, 0,
    [self.scorollview addSubview:contextImage];
    self.scorollview.contentSize=CGSizeMake(320, (self.scorollview.contentSize.height>y?self.scorollview.contentSize.height:(110+y))+5+image.size.height/image.size.width*310);
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
    
    [self.topView setBackgroundColor:[CommonHelper hexStringToColor:@"#0E5DBF"]];
    [self.comFromContextLabel setTextColor:[UIColor whiteColor]];
    [self.comFromLabel setTextColor:[UIColor whiteColor]];
    [self.dateTimeLabel setTextColor:[UIColor whiteColor]];
    [self.scorollview setShowsVerticalScrollIndicator:NO];
    //底部Bar
    [self.bottomBar setBackgroundImage:[UIImage imageNamed:@"bottomNav"] forBarMetrics:UIBarMetricsDefault];
    //返回按钮
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 8, 32, 32);
    [backButton setBackgroundImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:backButton];
    /*分割线1*/
    UIImageView *imageViewBottomDiv1=[[UIImageView alloc] initWithFrame:CGRectMake(40, -12, 30, 75)];
    [imageViewBottomDiv1 setImage:[UIImage imageNamed:@"dividingLine"]];
    [self.bottomBar addSubview:imageViewBottomDiv1];
    
    /*分割线2*/
    UIImageView *imageViewBottomDiv2=[[UIImageView alloc] initWithFrame:CGRectMake(243, -12, 30, 75)];
    [imageViewBottomDiv2 setImage:[UIImage imageNamed:@"dividingLine"]];
    [self.bottomBar addSubview:imageViewBottomDiv2];
    
    //收藏
    favButton=[UIButton buttonWithType:UIButtonTypeCustom];
    favButton.frame=CGRectMake(276, 8, 30, 30);
    [favButton setBackgroundImage:[UIImage imageNamed:@"grzy_Star"] forState:UIControlStateNormal];
    [favButton addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:favButton];
    
    //查看精彩评论
    UIButton *commentsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    commentsButton.frame=CGRectMake(60, 8, 115, 32);
    [commentsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commentsButton setTitle:@"查看精彩评论" forState:UIControlStateNormal];
    [commentsButton addTarget:self action:@selector(viewComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:commentsButton];
    
    //共多少条评论
    self.totalLabel=[[UILabel alloc] initWithFrame:CGRectMake(185, 13, 70, 21)];
    self.totalLabel.text=@"共0条";
    [self.totalLabel setBackgroundColor:[UIColor clearColor]];
    [self.bottomBar addSubview:self.totalLabel];
    
    self.contentDetailLabel=[[UITextView alloc] init];
    [self.contentDetailLabel setFrame:CGRectMake(0, 104, 320, 240)];
    [self.contentDetailLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentDetailLabel setEditable:NO];
    [self.contentDetailLabel setScrollEnabled:NO];
    self.contentDetailLabel.font= [UIFont systemFontOfSize:18];
    self.contentDetailLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //[self.contentDetailLabel setFont: builderTextView.font];
    [self.scorollview addSubview:self.contentDetailLabel];
    //    self.contentDetailLabel＝[UILabel alloc]
}

#pragma mark - viewWillAppear
- (void) viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
}
//返回
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)collect
{
    if(!isHasFav){
        NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
        User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
        //
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        [dictionary setValue: userid forKey:@"userId"];
        [dictionary setValue: self.myReport.reportId forKey:@"reportId"];
        [self showLoadingActivityViewWithString:@"正在收藏"];
        [[requestServiceHelper defaultService]favoriteZanCai:AddFavoriteList paramter: dictionary sucess:^(NSString *state) {
            [self hideLoadingActivityView];
//                [self showAlertViewWithString:@"收藏成功" setDelegate:nil setTag:0];
          [ALToastView toastInView:self.view withText:@"收藏成功"];
                isHasFav=true;
                self.myReportDetail.favId=state;
                [favButton setBackgroundImage:[UIImage imageNamed:@"favorites@2x"] forState:UIControlStateNormal];
        } falid:^(NSString *errorMsg) {
              [ALToastView toastInView:self.view withText:@"收藏失败"];
        }];
        
    }
    else{
        NSMutableDictionary *dir=[[NSMutableDictionary alloc] init];
        [dir setValue:self.myReportDetail.favId  forKey:@"favoriteId"];
        [self showLoadingActivityViewWithString:@"正在取消收藏..."];
        [HttpRequestHelper asyncGetRequest:delShoucang parameter:dir requestComplete:^(NSString *responseStr) {
            [self hideLoadingActivityView];
            if([responseStr isEqualToString:@"success"])
            {
                   [ALToastView toastInView:self.view withText:@"取消收藏成功"];
                isHasFav=false;
                    [favButton setBackgroundImage:[UIImage imageNamed:@"grzy_Star"] forState:UIControlStateNormal];
            }
        } requestFailed:^(NSString *errorMsg) {
            [ALToastView toastInView:self.view withText:@"取消收藏失败"];
            [self hideLoadingActivityView];
        }];

    }
}


- (void)dismissKeyboard {
    [self.contentDetailLabel resignFirstResponder];
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewComment:(id)sender {
    //    if(![self.totalLabel.text isEqualToString:@"共0条"])
    //    {
    WonderfulCommentsViewController *wonderfulCtrl=[[WonderfulCommentsViewController alloc] init];
    wonderfulCtrl.myReport =    self.myReport;
    [self.navigationController pushViewController:wonderfulCtrl animated:YES];
    //}
    //    else{
    //        UIAlertView *coll=[[UIAlertView alloc] initWithTitle:@""
    //                                                     message:@"暂无评论"
    //                                                    delegate:self
    //                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //        [coll show];
    //    }
}
- (void)viewDidUnload {
    [self setContentDetailLabel:nil];
    [self setScorollview:nil];
    [super viewDidUnload];
}
@end
