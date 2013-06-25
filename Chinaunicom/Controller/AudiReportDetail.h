//
//  AudiReportDetail.h
//  Chinaunicom
//
//  Created by rock on 13-6-17.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "BaseViewController.h"
#import "ReportDetail.h"
@interface AudiReportDetail : BaseViewController<SDWebImageManagerDelegate,UIAlertViewDelegate>
{
    int y;
}
@property (weak, nonatomic) IBOutlet UILabel *reporttitle;
@property (weak, nonatomic) IBOutlet UILabel *reportdate;
@property (strong, nonatomic) Report *myReport;
@property (strong, nonatomic) IBOutlet UITextView *contentDetailLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *topview;
@property (weak, nonatomic) IBOutlet UINavigationBar *bottomBar;
@property (strong, nonatomic) ReportDetail *myReportDetail;


@end
