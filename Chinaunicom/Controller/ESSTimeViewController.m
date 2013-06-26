//
//  ESSTimeViewController.m
//  Chinaunicom
//
//  Created by rock on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "ESSTimeViewController.h"
#import "requestServiceHelper.h"
@interface ESSTimeViewController ()

@end

@implementation ESSTimeViewController

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
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"25/06/2013",@"timeStr", nil];
    [[requestServiceHelper defaultService]getESStotleNum:dict sucess:^(NSMutableArray *commentDictionary) {
        NSLog(@"co=%@",commentDictionary);
    } falid:^(NSString *errorMsg) {
        NSLog(@"err=%@",errorMsg);
    }];
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
