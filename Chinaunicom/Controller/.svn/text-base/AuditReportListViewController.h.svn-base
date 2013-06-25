//
//  AuditedReportListViewController.h
//  Chinaunicom
//
//  Created by LITK on 13-5-16.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "BaseViewController.h"

@interface AuditReportListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    int totalresult;
    int pageSize;
    int page;
}
@property(nonatomic,strong) NSString *state;;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, retain) PullToRefreshTableView *myTableView;
@end
