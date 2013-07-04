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
//#import "Report.h"
//#import "User.h"
#import "ReportDetail.h"
#import "HttpRequestHelper.h"
#import "CommonHelper.h"
@interface ContextDetailController ()
{
    UILabel *_totalLabel;
    UIView *_topview;
    UIScrollView *_bottomScrollview;
}
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLayout];
    [self getTheData];

}
#pragma mark - initLayout
-(void)initLayout
{
    [self.bottomView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title@2x.png"]]];
    _topview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    [_topview setBackgroundColor:[CommonHelper hexStringToColor:@"#0E5DBF"]];
    _bottomScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, 320, self.view.frame.size.height-44-100)];
    [_bottomScrollview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_topview];
    [self.view addSubview:_bottomScrollview];
    
    //返回按钮
    UIImage *backImage=[UIImage imageNamed:@"new_arraw.png"];
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, (44-backImage.size.height)/2, backImage.size.width, backImage.size.height);
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:backButton];
    
    /*分割线1*/
    UIImageView *imageViewBottomDiv1=[[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 2, 44)];
    [imageViewBottomDiv1 setImage:[UIImage imageNamed:@"new_line.png"]];
    [self.bottomView addSubview:imageViewBottomDiv1];
    
    /*分割线2*/
    UIImageView *imageViewBottomDiv2=[[UIImageView alloc] initWithFrame:CGRectMake(260, 0, 2, 44)];
    [imageViewBottomDiv2 setImage:[UIImage imageNamed:@"new_line.png"]];
    [self.bottomView addSubview:imageViewBottomDiv2];
    
    //收藏
    UIImage *starImage=[UIImage imageNamed:@"Star.png"];
    favButton=[UIButton buttonWithType:UIButtonTypeCustom];
    favButton.frame=CGRectMake(276, (44-starImage.size.height)/2, starImage.size.width, starImage.size.height);
    [favButton setBackgroundImage:starImage forState:UIControlStateNormal];
    [favButton addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:favButton];
    
    //查看精彩评论
    UIButton *commentsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    commentsButton.frame=CGRectMake(60, 8, 115, 32);
    [commentsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commentsButton setTitle:@"查看精彩评论" forState:UIControlStateNormal];
    [commentsButton addTarget:self action:@selector(viewComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:commentsButton];
    
    //共多少条评论
    _totalLabel=[[UILabel alloc] initWithFrame:CGRectMake(185, 13, 70, 21)];
    _totalLabel.text=@"共0条";
    [_totalLabel setBackgroundColor:[UIColor clearColor]];
    [self.bottomView addSubview:_totalLabel];

}

-(void)getTheData
{
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithObject:self.reportId forKey:@"reportId"];
    [[requestServiceHelper defaultService]getReportDetail:dictionary sucess:^(NSDictionary *reportDetail) {
        NSLog(@"report=%@",reportDetail);
        NSString *titleStr=[reportDetail objectForKey:@"title"];
        CGSize titleSize=[titleStr sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 280, titleSize.height)];
        titleLabel.text=titleStr;
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setNumberOfLines:0];
        [titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [_topview addSubview:titleLabel];
        
        NSString *comeStr=[reportDetail objectForKey:@"reportType"];
        NSString *typeName=nil;
        if ([comeStr isEqualToString:@"12"]){
            
            typeName=@"安全类";
            
        }else if ([comeStr isEqualToString:@"14"]) {
            typeName=@"维护类";
        }
        else if([comeStr isEqualToString:@"13"]){
            typeName=@"分析类";
        }
        else{
            typeName=@"其他";
        }
        
        UILabel *comeLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 20+titleSize.height+10, 70, 20)];
        [comeLabel setBackgroundColor:[UIColor clearColor]];
        [comeLabel setTextColor:[UIColor darkGrayColor]];
        comeLabel.text=[NSString stringWithFormat:@"来自%@",typeName];
        [comeLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_topview addSubview:comeLabel];
        
        NSString *timeStr=[reportDetail objectForKey:@"published"];
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, comeLabel.frame.origin.y, 130, 20)];
        timeLabel.text=timeStr;
        [timeLabel setTextColor:[UIColor darkGrayColor]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_topview addSubview:timeLabel];
        
        _topview.frame=CGRectMake(0, 0, 320, timeLabel.frame.origin.y+timeLabel.frame.size.height+20);
        
        NSString *commentStr=[reportDetail objectForKey:@"reportContent"];
        CGSize commentSize=[commentStr sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 280, commentSize.height)];
        [commentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [commentLabel setNumberOfLines:0];
        [commentLabel setBackgroundColor:[UIColor clearColor]];
        commentLabel.text=comeStr;
        
        [_bottomScrollview addSubview:commentLabel];
        [_bottomScrollview setFrame:CGRectMake(0, _topview.frame.size.height, 320, self.view.frame.size.height-44-_topview.frame.size.height)];
        [_bottomScrollview setContentSize:CGSizeMake(320, 20+commentSize.height+10)];
        
        NSString *picPath=[reportDetail objectForKey:@"picPath"];
        if (picPath !=nil) {
            NSArray *array=[picPath componentsSeparatedByString:@","];
            for (int i=0; i<[array count]; i++) {
                @autoreleasepool {
                    NSString *path=[[array objectAtIndex:i]stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                    [self compearImage:path];
                    
                }
            }
        }

        
    } falid:^(NSString *errorMsg) {
    }];
//        if ([type isEqualToString:@"65"]){
//            typeName=@"安全类";
//        }else if ([type isEqualToString:@"18"]) {
//            typeName=@"分析类";
//        }
//        else if([type isEqualToString:@"17"]){
//            typeName=@"维护类";
//        }
//        else if([type isEqualToString:@"214"]){
//            typeName=@"应用类";
//        }
//        else if([type isEqualToString:@"16"])
//        {
//            typeName=@"应用类";
//        }
//        else{
//            typeName=@"其他";
//        }

}
#pragma mark - initDataSource
//-(void)initDataSource
//{
//    [self dismissKeyboard];
//    isHasFav=false;
//    [self showLoadingActivityViewWithString:@"正在加载..."];
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    [dictionary setValue: self.myReport.reportId forKey:@"reportId"];
    
//    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
//    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
//    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
//    [dictionary setValue: userid forKey:@"userId"];
//}
-(void)compearImage :(NSString *) picpath{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *cachedImage = [manager imageWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:picpath]]];
    // 将需要缓存的图片加载进来
    if (cachedImage) {
        // 如果Cache命中，则直接利用缓存的图片进行有关操
        UIImageView *contextImage=[[UIImageView alloc] init];
        UIImage *newImage=[self imageWithImageSimple:cachedImage  scaledToSize:CGSizeMake(280, cachedImage.size.height/cachedImage.size.width*280)];
        [contextImage setImage:newImage];
        [contextImage setFrame:CGRectMake(20, _bottomScrollview.contentSize.height, 280,newImage.size.height)];
        
        [_bottomScrollview addSubview:contextImage];
        _bottomScrollview.contentSize=CGSizeMake(320, _bottomScrollview.contentSize.height+newImage.size.height+10);

    } else {
        // 如果Cache没有命中，则去下载指定网络位置的图片，并且给出一个委托方法
   
        [manager downloadWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:picpath]] delegate:self];
    }
}
// 当下载完成后，调用回调方法，使下载的图片显示
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
    // Do something with the downloaded image
    UIImageView *contextImage=[[UIImageView alloc] init];
    UIImage *newImage=[self imageWithImageSimple:image  scaledToSize:CGSizeMake(280, image.size.height/image.size.width*280)];
    [contextImage setImage:newImage];
    [contextImage setFrame:CGRectMake(20, _bottomScrollview.contentSize.height, 280,newImage.size.height)];
    [_bottomScrollview addSubview:contextImage];
    _bottomScrollview.contentSize=CGSizeMake(320, _bottomScrollview.contentSize.height+newImage.size.height+10);
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

#pragma mark - viewWillAppear

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
//    [self.contentDetailLabel resignFirstResponder];
   
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
//    wonderfulCtrl.myReport =    self.myReport;
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

    [super viewDidUnload];
}
@end
