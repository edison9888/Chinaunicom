//
//  SendAudiReport.h
//  Chinaunicom
//
//  Created by rock on 13-6-14.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

@interface SendAudiReport : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,
                            UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
- (IBAction)addimage:(id)sender;
- (IBAction)sendreport:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *reporttitle;
@property (weak, nonatomic) IBOutlet UITextView *reportcontent;

@property (weak, nonatomic) IBOutlet UIButton *sendMessageEvent;

@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (strong, nonatomic) NSString *reportTypeId;
@end
