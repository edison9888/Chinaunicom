//
//  AudiReportDetail.m
//  Chinaunicom
//
//  Created by rock on 13-6-17.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "AudiReportDetail.h"
#import "User.h"
#import "requestServiceHelper.h"
#import "HttpRequestHelper.h"
#import "EditViewController.h"
#import "SDWebImageManager.h"
@interface AudiReportDetail ()
{
    NSMutableArray *dataArray;
}
@end

@implementation AudiReportDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataArray=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initDataSource
{
    [dataArray addObject:self.reportId];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: self.reportId forKey:@"reportId"];
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    [dictionary setValue: userid forKey:@"userId"];
    
    [[requestServiceHelper defaultService] getReportDetail:dictionary sucess:^(NSDictionary *reportDetail) {
        //标题
        NSString *titleStr=[[reportDetail objectForKey:@"title"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
        CGSize titleSize=[titleStr sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 280, titleSize.height)];
        titleLabel.text=titleStr;
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setNumberOfLines:0];
        [titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self.scrollview addSubview:titleLabel];
        [dataArray addObject:titleStr];
        
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
        
        UILabel *comeLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 20+titleSize.height+10, 70, 20)];
        [comeLabel setBackgroundColor:[UIColor clearColor]];
        [comeLabel setTextColor:[UIColor darkGrayColor]];
        comeLabel.text=[NSString stringWithFormat:@"来自%@",typeName];
        [comeLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.scrollview addSubview:comeLabel];
        
        NSString *timeStr=[[reportDetail objectForKey:@"published"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, comeLabel.frame.origin.y, 130, 20)];
        timeLabel.text=timeStr;
        [timeLabel setTextColor:[UIColor darkGrayColor]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.scrollview addSubview:timeLabel];
        
        NSString *commentStr=[[reportDetail objectForKey:@"reportContent"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        CGSize commentSize=[commentStr sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, timeLabel.frame.origin.y+20, 280, commentSize.height)];
        [commentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [commentLabel setNumberOfLines:0];
        [commentLabel setBackgroundColor:[UIColor clearColor]];
        commentLabel.text=commentStr;
        [self.scrollview addSubview:commentLabel];
        [dataArray addObject:commentStr];
        [self.scrollview setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44-44)];
        [self.scrollview setContentSize:CGSizeMake(320, commentLabel.frame.origin.y+commentLabel.frame.size.height+10)];
        
        NSString *picPath=[reportDetail objectForKey:@"picPath"];
        [dataArray addObject:picPath];
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
        // 将需要缓存的图片加载进来
        if (image) {
            // 如果Cache命中，则直接利用缓存的图片进行有关操
            UIImageView *contextImage=[[UIImageView alloc] init];
            UIImage *newImage=[self imageWithImageSimple:image  scaledToSize:CGSizeMake(280, image.size.height/image.size.width*280)];
            [contextImage setImage:image];
            [contextImage setFrame:CGRectMake(20, self.scrollview.contentSize.height, 280,image.size.height)];
            
            [self.scrollview addSubview:contextImage];
            self.scrollview.contentSize=CGSizeMake(320, self.scrollview.contentSize.height+newImage.size.height+10);
        }
    }];
}
// 当下载完成后，调用回调方法，使下载的图片显示
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
    
    UIImageView *contextImage=[[UIImageView alloc] init];
    UIImage *newImage=[self imageWithImageSimple:image  scaledToSize:CGSizeMake(280, image.size.height/image.size.width*280)];
    [contextImage setImage:newImage];
    [contextImage setFrame:CGRectMake(20, self.scrollview.contentSize.height, 280,newImage.size.height)];
    [self.scrollview addSubview:contextImage];
    self.scrollview.contentSize=CGSizeMake(320, self.scrollview.contentSize.height+newImage.size.height+10);

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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        UITextField *tf=[alertView textFieldAtIndex:0];
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
        User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
        [dictionary setObject:userid forKey:@"userId"];
        [dictionary setObject:self.reportId forKey:@"reportId"];
        [dictionary setObject:tf.text forKey:@"backReason"];
        [HttpRequestHelper asyncGetRequest:backReportUrl parameter:dictionary requestComplete:^(NSString *responseStr) {
            [MBHUDView dismissCurrentHUD];
            if ([responseStr isEqualToString:@"success"]) {
                [MBHUDView hudWithBody:@"退回成功" type:MBAlertViewHUDTypeCheckmark hidesAfter:2.0 show:YES];
            }
            else
            {
                [MBHUDView hudWithBody:@"没有审核权限" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
            }
        } requestFailed:^(NSString *errorMsg) {
            [MBHUDView hudWithBody:@"网络不稳定" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
        }];
    }
}

- (void)viewDidUnload {
    [self setScrollview:nil];
    [super viewDidUnload];
}

- (IBAction)editReport:(UIButton *)sender {
    if ([dataArray count]>3) {
        EditViewController *edit=[[EditViewController alloc]initWithNibName:@"EditViewController" bundle:nil];
        edit.dataArray=dataArray;
        [self.navigationController pushViewController:edit animated:YES];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backFile:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退回报告原因" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}

- (IBAction)passFile:(UIButton *)sender {
    [MBHUDView dismissCurrentHUD];
    [MBHUDView hudWithBody:@"请稍等..." type:MBAlertViewHUDTypeDefault hidesAfter:0 show:YES];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    [dictionary setObject:userid forKey:@"userId"];
    [dictionary setObject:self.reportId forKey:@"reportId"];
    [HttpRequestHelper asyncGetRequest:passReport parameter:dictionary requestComplete:^(NSString *responseStr) {
        if ([responseStr isEqualToString:@"success"]) {
            [MBHUDView dismissCurrentHUD];
            [MBHUDView hudWithBody:@"审核成功" type:MBAlertViewHUDTypeCheckmark hidesAfter:1.0 show:YES];
        }
        else
        {
            [MBHUDView dismissCurrentHUD];
            [MBHUDView hudWithBody:@"没有审核权限" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
        }
    } requestFailed:^(NSString *errorMsg) {
            [MBHUDView dismissCurrentHUD];
            [MBHUDView hudWithBody:@"网络不稳定" type:MBAlertViewHUDTypeDefault hidesAfter:2.0 show:YES];
    }];

}
@end
