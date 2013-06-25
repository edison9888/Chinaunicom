//
//  ReportDetail.h
//  Chinaunicom
//
//  Created by 李天焜 on 13-5-18.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportDetail : NSObject
@property(strong,nonatomic)NSString *summary;
@property(strong,nonatomic)NSString *reportTitle;
@property(strong,nonatomic)NSString *reportContent;
@property(strong,nonatomic)NSString *published;
@property(strong,nonatomic)NSString *size;
@property(strong,nonatomic)NSString *fromtype;
@property(strong,nonatomic)NSString *isFav;
@property(strong,nonatomic)NSString *picPath;
@property(strong,nonatomic)NSString *favId;
@end
