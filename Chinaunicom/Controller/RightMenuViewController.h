//
//  PersonalCenterViewController.h
//  Chinaunicom
//
//  Created byon 13-5-7.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomRightMenuViewCell.h"
#import "User.h"

@interface RightMenuViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSURL *iconurl;
}
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *dictionayData;
@property(strong , nonatomic) UITableView *mytableView;

@end
