//
//  SafetyViewController.h
//  Chinaunicom
//
//  Created by  on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//



#import "PullingRefreshTableView.h"

@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate,PullingRefreshTableViewDelegate>
{
    PullingRefreshTableView *myTableView;
}

@property (weak, nonatomic)   IBOutlet UISearchBar *mySearch;
-(void)reloadSource:(int)num;

@end
