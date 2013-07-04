//
//  SafeDetailController.h
//  Chinaunicom
//
//  Created by rock on 13-5-5.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"

@interface ContextDetailController : UIViewController<SDWebImageManagerDelegate>

@property (nonatomic,strong) NSString *reportId;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
