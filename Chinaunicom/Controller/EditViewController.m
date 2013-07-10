//
//  EditViewController.m
//  Chinaunicom
//
//  Created by rock on 13-7-10.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "EditViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HttpRequestHelper.h"
@interface EditViewController ()

@end

@implementation EditViewController

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
    [self.commentTextView.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.commentTextView.layer setBorderWidth:3.0];
    [self.commentTextView.layer setCornerRadius:5.0];
    [self.titleTextField.layer setCornerRadius:5.0];
    [self.titleTextField.layer setBorderWidth:3.0];
    [self.titleTextField.layer setBorderColor:[UIColor blackColor].CGColor];
    _titleTextField.text=[_dataArray objectAtIndex:1];
    _commentTextView.text=[_dataArray objectAtIndex:2];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setTitleTextField:nil];
    [self setCommentTextView:nil];
    [super viewDidUnload];
}
- (IBAction)editReport:(id)sender {
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setValue:[_dataArray objectAtIndex:0] forKey:@"reportId"];
    [dict setValue:_titleTextField.text forKey:@"title"];
    [dict setValue:_commentTextView.text forKey:@"reportContent"];
    [dict setValue:@"summary" forKey:@"summary"];
    [dict setValue:@"jpg" forKey:@"picType"];
    [dict setValue:[_dataArray objectAtIndex:3] forKey:@"picpath"];
    
    [HttpRequestHelper asyncGetRequest:changeReport parameter:dict requestComplete:^(NSString *responseStr) {
        [MBHUDView hudWithBody:responseStr type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
    } requestFailed:^(NSString *errorMsg) {
        [MBHUDView hudWithBody:@"网络不稳定" type:MBAlertViewHUDTypeDefault hidesAfter:1.0 show:YES];
    }];
}
@end
