//
//  BaseViewController.h
//  Chinaunicom
//
//  Created by on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BaseViewController : UIViewController

//显示alertview
-(void)showAlertViewWithString:(NSString *)alertString setDelegate:(id)delegate setTag:(NSInteger)alertTag;
//添加Activity加载效果
-(void)showLoadingActivityViewWithString:(NSString *)titleString;
//取消activity效果
-(void)hideLoadingActivityView;
@end
