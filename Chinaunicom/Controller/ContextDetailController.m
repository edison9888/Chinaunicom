//
//  SafeDetailController.m
//  Chinaunicom
//
//  Created by rock on 13-5-5.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "ContextDetailController.h"
#import "User.h"
#import "HttpRequestHelper.h"
#import "CommonHelper.h"
#import "GoodCommentsViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface ContextDetailController ()
{
    UILabel *_totalLabel;
    UIView *_topview;
    UIScrollView *_bottomScrollview;
    NSString *favString;
    UIButton *commentsButton;
    UIButton *favButton;
}
@end

@implementation ContextDetailController
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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect_screen = [[UIScreen mainScreen]applicationFrame];
    self.view.frame=rect_screen;
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
    [_bottomScrollview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_topview];
    [self.view addSubview:_bottomScrollview];
    //返回按钮
    UIImage *backImage=[UIImage imageNamed:@"new_arraw.png"];
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 57, 44);
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:backButton];
    
    /*分割线1*/
    UIImageView *imageViewBottomDiv1=[[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 2, 44)];
    [imageViewBottomDiv1 setImage:[UIImage imageNamed:@"new_line.png"]];
    [self.bottomView addSubview:imageViewBottomDiv1];
    
    /*分割线2*/
    UIImageView *imageViewBottomDiv2=[[UIImageView alloc] initWithFrame:CGRectMake(265, 0, 2, 44)];
    [imageViewBottomDiv2 setImage:[UIImage imageNamed:@"new_line.png"]];
    [self.bottomView addSubview:imageViewBottomDiv2];
    
    //收藏
    UIImage *starImage=[UIImage imageNamed:@"Star.png"];
    favButton=[UIButton buttonWithType:UIButtonTypeCustom];
    favButton.frame=CGRectMake(265, 0, 57, 44);
    [favButton setImage:starImage forState:UIControlStateNormal];
    [favButton setImage:[UIImage imageNamed:@"favorites.png"] forState:UIControlStateSelected];
    [favButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:favButton];
    
    //查看精彩评论
    commentsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    commentsButton.frame=CGRectMake(50, 8, 210, 32);
    [commentsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commentsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [commentsButton setTitle:[NSString stringWithFormat:@"查看精彩评论 共0条"] forState:UIControlStateNormal];
    [commentsButton addTarget:self action:@selector(viewComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:commentsButton];

}

-(void)getTheData
{
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:self.reportId,@"reportId",userid,@"userId", nil];
    
    [[requestServiceHelper defaultService]getReportDetail:dictionary sucess:^(NSDictionary *reportDetail) {
        NSString *titleStr=[[reportDetail objectForKey:@"title"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        CGSize titleSize=[titleStr sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 280, titleSize.height)];
        titleLabel.text=titleStr;
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setNumberOfLines:0];
        [titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [_topview addSubview:titleLabel];
        
        NSString *comeStr=[[reportDetail objectForKey:@"reportType"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *typeName=nil;
        if ([comeStr isEqualToString:@"12"]){
            
            typeName=@"安全类";
            
        }else if ([comeStr isEqualToString:@"14"]) {
            typeName=@"分析类";
        }
        else if([comeStr isEqualToString:@"13"]){
            typeName=@"维护类";
        }
        else{
            typeName=@"其他";
        }
        
        UILabel *comeLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 20+titleSize.height+5, 70, 20)];
        [comeLabel setBackgroundColor:[UIColor clearColor]];
        [comeLabel setTextColor:[UIColor whiteColor]];
        comeLabel.text=[NSString stringWithFormat:@"来自%@",typeName];
        [comeLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_topview addSubview:comeLabel];
        
        NSString *timeStr=[[reportDetail objectForKey:@"published"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, comeLabel.frame.origin.y, 130, 20)];
        timeLabel.text=timeStr;
        [timeLabel setTextColor:[UIColor whiteColor]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_topview addSubview:timeLabel];
        
        _topview.frame=CGRectMake(0, 0, 320, timeLabel.frame.origin.y+timeLabel.frame.size.height);
        
        NSString *commentStr=[[reportDetail objectForKey:@"reportContent"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        CGSize commentSize=[commentStr sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 280, commentSize.height)];
        [commentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [commentLabel setNumberOfLines:0];
        [commentLabel setBackgroundColor:[UIColor clearColor]];
        
        commentLabel.text=commentStr;
        
        [_bottomScrollview addSubview:commentLabel];
        [_bottomScrollview setFrame:CGRectMake(0, _topview.frame.size.height, 320, self.view.frame.size.height-44-_topview.frame.size.height)];
        [_bottomScrollview setContentSize:CGSizeMake(320, 20+commentSize.height+10)];
        
        BOOL isFav=[[reportDetail objectForKey:@"isFav"] boolValue];
        if (isFav) {
            [favButton setSelected:YES];
        }
        favString=[reportDetail objectForKey:@"favId"];
        
        NSNumber *pinlunNUm=[reportDetail objectForKey:@"size"];
        [commentsButton setTitle:[NSString stringWithFormat:@"查看精彩评论 共%@条",pinlunNUm] forState:UIControlStateNormal];
        
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

}

-(void)compearImage :(NSString *) picpath{
    [[SDWebImageManager sharedManager]downloadWithURL:[NSURL URLWithString:[ImageUrl stringByAppendingString:picpath]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (image) {
            UIImageView *contextImage=[[UIImageView alloc] init];
            UIImage *newImage=[self imageWithImageSimple:image  scaledToSize:CGSizeMake(280, image.size.height/image.size.width*280)];
            [contextImage setImage:newImage];
            [contextImage setFrame:CGRectMake(20, _bottomScrollview.contentSize.height, 280,newImage.size.height)];
            
            [_bottomScrollview addSubview:contextImage];
            _bottomScrollview.contentSize=CGSizeMake(320, _bottomScrollview.contentSize.height+newImage.size.height+10);
            
        }

    }];
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

//返回
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)collect :(UIButton *)sender
{
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    if (!sender.selected) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:self.reportId forKey:@"reportId"];
        [dictionary setValue: userid forKey:@"userId"];
        
        [[requestServiceHelper defaultService]favoriteZanCai:AddFavoriteList paramter: dictionary sucess:^(NSString *state) {
            MBHUDView *hub=[[MBHUDView alloc]init];
            UIImage *image=[UIImage imageNamed:@"delte.png"];
            hub.size=image.size;
            hub.backgroundColor=[UIColor colorWithPatternImage:image];
            hub.iconLabel.text=@"收藏成功";
            hub.iconLabel.textColor=[UIColor whiteColor];
            hub.hudHideDelay=1.0f;
            [hub addToDisplayQueue];
            favString=state;
    
            sender.selected=YES;
        } falid:^(NSString *errorMsg) {
            sender.selected=NO;
        }];
        
    }
    else{

        NSMutableDictionary *dir=[[NSMutableDictionary alloc] init];
        [dir setValue:favString  forKey:@"favoriteId"];
        [dir setValue:userid forKey:@"userId"];
        [HttpRequestHelper asyncGetRequest:delShoucang parameter:dir requestComplete:^(NSString *responseStr) {
            if([responseStr isEqualToString:@"success"])
            {
                sender.selected=NO;
            }
        } requestFailed:^(NSString *errorMsg) {
            sender.selected=YES;
        }];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewComment:(id)sender {
        GoodCommentsViewController *wonderfulCtrl=[[GoodCommentsViewController alloc] init];
        wonderfulCtrl.reportId=self.reportId;
        wonderfulCtrl.pinglunBt=commentsButton;
        [self.navigationController pushViewController:wonderfulCtrl animated:YES];
}
- (void)viewDidUnload {

    [super viewDidUnload];
}
@end
