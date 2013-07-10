//
//  ReportTypeViewController.m
//  Chinaunicom
//
//  Created by rock on 13-7-10.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "ReportTypeViewController.h"
#import "PubliceMessageViewConttoller.h"
@interface ReportTypeViewController ()

@end

@implementation ReportTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressBt:(UIButton *)sender {
    NSString *str=[NSString stringWithFormat:@"%d",sender.tag];
    PubliceMessageViewConttoller *mes=[[PubliceMessageViewConttoller alloc]initWithNibName:@"PubliceMessageViewConttoller" bundle:nil];
    mes.reportTypeId=str;
    [self.navigationController pushViewController:mes animated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
