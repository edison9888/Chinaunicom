//
//  GoodCommentsViewController.h
//  Chinaunicom
//
//  Created by YY on 13-7-5.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//
#import "PullingRefreshTableView.h"
@interface GoodCommentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    PullingRefreshTableView *_tableview;
    BOOL refreshing;
    NSInteger page;
}
@property (nonatomic,copy)NSString *reportId;
@end
