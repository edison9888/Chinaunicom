//
//  FavoriteListViewController.h
//  Chinaunicom
//
//  Created by LITK on 13-5-22.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//
#import "CustomFavoriteListCell.h"
@interface FavoriteListViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,TPGestureTableViewCellDelegate>
{
    
}
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTabelView;
@end
