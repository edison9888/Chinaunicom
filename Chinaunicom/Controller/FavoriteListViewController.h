//
//  FavoriteListViewController.h
//  Chinaunicom
//
//  Created by LITK on 13-5-22.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "BaseViewController.h"

@interface FavoriteListViewController : BaseViewController<UIAlertViewDelegate>
{
    int delIndex;
}
@property (strong, nonatomic) NSMutableArray *dictionayData;
@property (weak, nonatomic) IBOutlet UITableView *myTabelView;
@end
