//
//  SafetyViewController.h
//  Chinaunicom
//
//  Created by  on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//



#import "PullToRefreshTableView.h"

@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    CGFloat _offset;
    NSInteger page;
    NSInteger pagesize;
    NSInteger totalresult;
    NSString *reportid;
    NSMutableArray *dataSource;
    BOOL isfirst;
    PullToRefreshTableView *myTableView;
    BOOL isSearchBar;
}

@property (weak, nonatomic)   IBOutlet UISearchBar *mySearch;


//@property (strong, nonatomic) Report *myReport;


@end
