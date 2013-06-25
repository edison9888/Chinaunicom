//
//  WonderfulCommentsViewController.h
//  Chinaunicom
//
//  Created by on 13-5-5.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomWonderfulCommentsCell.h"
#import "UIKeyboardCoView.h"
#import "PullToRefreshTableView.h"
#import "Report.h"
#import "RecoderAndPlayer.h"


@interface WonderfulCommentsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ViewControllerDelegate,UITextViewDelegate>
{
    BOOL isRecord;
}
- (IBAction)send:(id)sender;

- (IBAction)switchTextAndSpeecn:(id)sender;
@property(nonatomic,retain)UIImageView *recodAlert;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (nonatomic, strong) NSArray *dataSource;
//@property (weak, nonatomic) IBOutlet UITextView *commentsTextField;
//@property (weak, nonatomic) IBOutlet UIKeyboardCoView *keyBoardView;
//@property (strong, nonatomic) PullToRefreshTableView  *myTableView;

- (IBAction)startRecord:(id)sender;
- (IBAction)endRecord:(id)sender;
@property (strong, nonatomic) RecoderAndPlayer *recoderAndPlayer;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIView *theTableView;
@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (weak, nonatomic) IBOutlet UIButton *talkbutton;
@property BOOL isText;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, strong) Report *myReport;
@end
