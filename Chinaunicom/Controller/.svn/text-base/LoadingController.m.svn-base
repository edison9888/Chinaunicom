//
//  LoadingController.m
//  Chinaunicom
//
//  Created by rock on 13-5-24.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "LoadingController.h"
#import "LoginViewController.h"
@interface LoadingController ()

@end

@implementation LoadingController

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
    [self initLayout];
    // Do any additional setup after loading the view from its nib.
}
-(void)initLayout
{
    NSArray *bg=[NSArray arrayWithObjects:@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",nil];
    [self.navigationController.navigationBar setHidden:YES];
    [self.loading setImage:[UIImage imageNamed:[bg objectAtIndex:arc4random()%4]]];
  
//    
//    NSThread* myThread = [[NSThread alloc] initWithTarget:self
//                                                 selector:@selector(myThreadMainMethod:)
//                                                   object:nil];
//    [myThread start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLoading:nil];
    [super viewDidUnload];
}
@end
