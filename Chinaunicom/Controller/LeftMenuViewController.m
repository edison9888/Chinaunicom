//
//  LeftMenuViewController.m
//  Chinaunicom
//
//  Created by rock on 13-7-8.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MainViewController.h"
#import "BussinessDataViewController.h"
@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

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
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        UINavigationController *nav= (UINavigationController *)self.mm_drawerController.centerViewController;
        MainViewController *main=(MainViewController *)[nav topViewController];
        [main reloadSource :10];
    }];

}

- (IBAction)b2:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        UINavigationController *nav= (UINavigationController *)self.mm_drawerController.centerViewController;
        MainViewController *main=(MainViewController *)[nav topViewController];
        [main reloadSource :12];
    }];
}

- (IBAction)b3:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        UINavigationController *nav= (UINavigationController *)self.mm_drawerController.centerViewController;
        MainViewController *main=(MainViewController *)[nav topViewController];
        [main reloadSource :14];
    }];
}

- (IBAction)b4:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        UINavigationController *nav= (UINavigationController *)self.mm_drawerController.centerViewController;
        MainViewController *main=(MainViewController *)[nav topViewController];
        [main reloadSource :13];
    }];
}

- (IBAction)b5:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        UINavigationController *nav= (UINavigationController *)self.mm_drawerController.centerViewController;
        MainViewController *main=(MainViewController *)[nav topViewController];
        [main reloadSource :15];
    }];
}

- (IBAction)b6:(UIButton *)sender {
    BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
    bd.name=@"ESS实时看板";
    [self.navigationController pushViewController:bd animated:YES];
}

- (IBAction)b7:(UIButton *)sender {
    BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
    bd.name=@"ESS合约计划";
    [self.navigationController pushViewController:bd animated:YES];
}

- (IBAction)b8:(UIButton *)sender {
    BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
    bd.name=@"ECS交易额";
    [self.navigationController pushViewController:bd animated:YES];
}

- (IBAction)b9:(id)sender {
    BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
    bd.name=@"ECS商城订单";
    [self.navigationController pushViewController:bd animated:YES];
}

- (IBAction)b10:(UIButton *)sender {
    BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
    bd.name=@"ECS用户发展";
    [self.navigationController pushViewController:bd animated:YES];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
