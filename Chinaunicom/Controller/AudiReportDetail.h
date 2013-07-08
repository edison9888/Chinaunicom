//
//  AudiReportDetail.h
//  Chinaunicom
//
//  Created by rock on 13-6-17.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
@interface AudiReportDetail : UIViewController<SDWebImageManagerDelegate,UIAlertViewDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (nonatomic,strong)NSString *reportId;
- (IBAction)editReport:(UIButton *)sender;
- (IBAction)back:(id)sender;
- (IBAction)backFile:(UIButton *)sender;
- (IBAction)passFile:(UIButton *)sender;



@end
