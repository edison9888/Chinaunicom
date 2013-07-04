//
//  SafeDetailController.h
//  Chinaunicom
//
//  Created by rock on 13-5-5.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WonderfulCommentsViewController.h"
#import "UIImageView+WebCache.h"

@class Report;
@class ReportDetail;

@interface ContextDetailController : BaseViewController<SDWebImageManagerDelegate>
{
    BOOL isHasFav;
    int y;
}

@property (nonatomic,strong) NSString *reportId;
@property (weak, nonatomic) IBOutlet UIView *bottomView;



//@property (weak, nonatomic) IBOutlet UIView *topView;
//@property (weak, nonatomic) IBOutlet UILabel *comFromContextLabel;
//@property (weak, nonatomic) IBOutlet UILabel *comFromLabel;
//@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
//@property (weak, nonatomic) IBOutlet UITextView *contentDetailLabel;

@property (strong,nonatomic)UIButton *favButton;
@property (strong, nonatomic) ReportDetail *myReportDetail;
//@property (weak, nonatomic) IBOutlet UIScrollView *scorollview;

- (IBAction)viewComment:(id)sender;
@end
