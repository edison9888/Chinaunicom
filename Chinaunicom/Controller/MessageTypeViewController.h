//
//  MessageTypeViewController.h
//  Chinaunicom
//
//  Created by 李天焜 on 13-5-16.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//


@interface MessageTypeViewController : UIViewController

@property(strong , nonatomic) UITableView *mytableView;
@property(strong , nonatomic) UIScrollView *scrollView;
//
@property (nonatomic, retain) NSMutableArray *viewDataArray;
@property (nonatomic, retain) NSMutableArray *tempViewArray;

@property(nonatomic, strong) NSArray *dataSource;
@end
