//
//  AuditAndNonAuditReportViewController.h
//  Chinaunicom
//
//  Created by LITK on 13-6-3.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "BaseViewController.h"

@interface AuditAndNonAuditReportViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    int totalresult;
    int pageSize;
    int page;
    Boolean isfirst;
  
}
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, retain) PullToRefreshTableView *myTableView;
@end
