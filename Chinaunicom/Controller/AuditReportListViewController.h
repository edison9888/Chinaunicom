//
//  AuditedReportListViewController.h
//  Chinaunicom
//
//  Created by LITK on 13-5-16.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "PullingRefreshTableView.h"
@interface AuditReportListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) PullingRefreshTableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *senHeButton;
@property (weak, nonatomic) IBOutlet UIButton *passButton;
- (IBAction)auditNews:(UIButton *)sender;
- (IBAction)pressPassButton:(UIButton *)sender;
- (IBAction)pressSenHeButton:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;


@end
