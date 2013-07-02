//
//  BaseNavigationController.m
//  Chinaunicom
//
//  Created by  on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "BaseNavigationController.h"
#import "CommonHelper.h"
@interface BaseNavigationController ()
{
    UIViewController *_viewController;
}
@end

@implementation BaseNavigationController

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
#warning 替换图片
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"title@2x.png"] forBarMetrics:UIBarMetricsDefault];
     UIImageView *_zdLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height-1, self.navigationBar.frame.size.width, 2)];
    _zdLine.image=[UIImage imageNamed:@"img_global_line_"];
    [self.navigationBar addSubview:_zdLine];
    
//    //返回按钮
//    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *image=[UIImage imageNamed:@"left_arrow"];
//    backButton.frame = CGRectMake(10, 0, image.size.width, image.size.height);
//    [backButton setBackgroundImage:image forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationBar addSubview:backButton];
    
//    /*分割线1*/
//    UIImageView *imageViewTopDiv1=[[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 1, self.navigationBar.frame.size.height)];
//    [imageViewTopDiv1 setImage:[UIImage imageNamed:@"dividingLine@2x.png"]];
//    [self.navigationBar addSubview:imageViewTopDiv1];

}

//-(UIBarButtonItem *)createBackButton
//{
//    //返回按钮
//    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *image=[UIImage imageNamed:@"left_arrow"];
//    backButton.frame = CGRectMake(10, 0, image.size.width, image.size.height);
//    [backButton setBackgroundImage:image forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    //定制自己的风格的  UIBarButtonItem
//    UIBarButtonItem *backBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    return backBarButtonItem;
//}
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [super pushViewController:viewController animated:animated];
//    
//    _viewController = viewController;
//    NSLog(@"ssss=%d",[self.viewControllers count]);
//    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1)
//    {
//        viewController.navigationItem.leftBarButtonItem = [self createBackButton];
//    }
//    
////    if ([self.viewControllers count] > 2)
////    {
////        viewController.navigationItem.rightBarButtonItem = [self createHomeButton];
////    }
//    
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
