//
//  BaseViewController.m
//  Chinaunicom
//
//  Created by  on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "BaseViewController.h"


#define AnnimationTime 0.5
#define KEY_LOAD 201316

@interface BaseViewController ()

@end

@implementation BaseViewController

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
	// Do any additional setup after loading the view.
}

//显示alertview
-(void)showAlertViewWithString:(NSString *)alertString setDelegate:(id)delegate setTag:(NSInteger)alertTag{
    if (delegate) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertString delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = alertTag;
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertString delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
}
//加载数据activity
#pragma mark -loading
-(void)showLoadingActivityViewWithString:(NSString *)titleString{
    
    UIView* _blockerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 200, 60)];
    _blockerView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.8];
    _blockerView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2-50);
    _blockerView.alpha = 0.0;
    _blockerView.clipsToBounds = YES;
    _blockerView.tag=KEY_LOAD;
    if ([_blockerView.layer respondsToSelector: @selector(setCornerRadius:)]) [(id) _blockerView.layer setCornerRadius: 10];
    
    UILabel	*label = [[UILabel alloc] initWithFrame: CGRectMake(0, 5, _blockerView.bounds.size.width, 15)];
    label.text = NSLocalizedString(titleString, nil);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize: 15];
    [_blockerView addSubview: label];
    
    UIActivityIndicatorView	*spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    spinner.center = CGPointMake(_blockerView.bounds.size.width / 2, _blockerView.bounds.size.height / 2 + 10);
    [_blockerView addSubview: spinner];
    [self.view addSubview: _blockerView];
    _blockerView.alpha = 0.0;
    [UIView animateWithDuration:AnnimationTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _blockerView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}
//取消activity效果
-(void)hideLoadingActivityView{
    UIView* _blockerView = [self.view viewWithTag:KEY_LOAD];
    [UIView animateWithDuration:AnnimationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _blockerView.alpha = 0;
    } completion:^(BOOL finished) {
        if (_blockerView) {
            [_blockerView removeFromSuperview];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
