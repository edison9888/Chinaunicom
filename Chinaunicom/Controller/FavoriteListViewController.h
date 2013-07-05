//
//  FavoriteListViewController.h
//  Chinaunicom
//
//  Created by LITK on 13-5-22.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

@interface FavoriteListViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{

}
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTabelView;
@end
