//
//  SafetyViewController.h
//  Chinaunicom
//
//  Created by  on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//


#import "CustomMainViewCell.h"
#import "ContextDetailController.h"
#import "RightMenuViewController.h"
#import "PullToRefreshTableView.h"
@class Report;

@interface MainViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,LeftMenuViewControllerDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    CGFloat _offset;
    
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, retain) PullToRefreshTableView *myTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearch;
@property (weak, nonatomic)  UITextField *df;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pagesize;
@property (nonatomic,assign) NSInteger totalresult;
@property(nonatomic,strong) NSString *reportid;
@property (strong, nonatomic) Report *myReport;
@property (nonatomic,assign) BOOL isfirst;
-(void)initCustomTableCell:(CustomMainViewCell*)cell IndexPath:(NSIndexPath *)indexPath ;

@end
