//
//  GoodCommentsViewController.h
//  Chinaunicom
//
//  Created by YY on 13-7-5.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//
#import "PullingRefreshTableView.h"
#import "UIInputToolbar.h"
#import "RecoderAndPlayer.h"
@interface GoodCommentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIInputToolbarDelegate,ViewControllerDelegate>
{
    PullingRefreshTableView *_tableview;
    UIInputToolbar *inputToolbar;
    BOOL refreshing;
    NSInteger page;
    RecoderAndPlayer *recoderAndPlayer;
}
@property (nonatomic,copy)NSString *reportId;
@end
