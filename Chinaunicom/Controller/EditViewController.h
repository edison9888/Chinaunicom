//
//  EditViewController.h
//  Chinaunicom
//
//  Created by rock on 13-7-10.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController
- (IBAction)back:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (nonatomic,strong) NSMutableArray *dataArray;
- (IBAction)editReport:(id)sender;


@end
