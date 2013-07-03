//
//  AppDelegate.h
//  Chinaunicom
//
//  Created by  on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSTimer *timer;
    LoadingController *loadingcontroller;
}
@property (strong, nonatomic) UIWindow *window;


@end
