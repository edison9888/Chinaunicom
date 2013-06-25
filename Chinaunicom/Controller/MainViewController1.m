//
//  MainViewController.m
//  Chinaunicom
//
//  Created by  on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "MainViewController1.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"
//#import "MainViewController.h"
#import "ContextDetailController.h"


@interface MainViewController1 ()

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (nonatomic) int cx;

@end

@implementation MainViewController1



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"首页";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLayoutUI];
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < 2; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    // a page is the width of the scroll view
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.myScrollView.frame) * 2, CGRectGetHeight(self.myScrollView.frame));
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.scrollsToTop = NO;
    self.myScrollView.delegate = self;
    
    self.myPageControl.numberOfPages = 2;
    self.myPageControl.currentPage = 0;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    self.myPageControl.frame=CGRectMake(0,398,320,20);
}


- (void)initLayoutUI
{
    UIButton *login=[UIButton buttonWithType:UIButtonTypeCustom];
    login.frame=CGRectMake(0.0, 0.0, 48.0, 30.0);
    [login setBackgroundImage:[UIImage imageNamed:@"btn_1_On"] forState:UIControlStateNormal];
    login.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc] initWithCustomView:login];
    barItem.style=UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem=barItem;

}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= 2)
        return;
    
    // replace the placeholder if necessary
    ToolsViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        
        controller = [[ToolsViewController alloc] initWithPageNumber:page];
        //BaseNavigationController *baseNav=[[BaseNavigationController alloc] initWithRootViewController:controller];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.myScrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.myScrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        
       
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // remove all the subviews from our scrollview
    for (UIView *view in self.myScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSUInteger numPages = 2;//self.contentList.count;
    
    // adjust the contentSize (larger or smaller) depending on the orientation
    self.myScrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.myScrollView.frame) * numPages, CGRectGetHeight(self.myScrollView.frame));
    
    // clear out and reload our pages
    self.viewControllers = nil;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    [self loadScrollViewWithPage:self.myPageControl.currentPage - 1];
    [self loadScrollViewWithPage:self.myPageControl.currentPage];
    [self loadScrollViewWithPage:self.myPageControl.currentPage + 1];
    [self gotoPage:NO]; // remain at the same page (don't animate)
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.myScrollView.frame);
    NSUInteger page = floor((self.myScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.myPageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}


- (void) Login
{
    LoginViewController  *loginCtrl=[[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginCtrl animated:YES];
}



- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.myPageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect bounds = self.myScrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.myScrollView scrollRectToVisible:bounds animated:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [self setMyScrollView:nil];
    [self setMyPageControl:nil];
    [super viewDidUnload];
}
@end
