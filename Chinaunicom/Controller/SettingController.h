//
//  SettingController.h
//  Chinaunicom
//
//  Created by rock on 13-5-22.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingController : BaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,retain) UIImage *tempHead;


@property (weak, nonatomic) IBOutlet UISwitch *message;
@property (weak, nonatomic) IBOutlet UISwitch *sound;
@property (weak, nonatomic) IBOutlet UIButton *quit;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
- (IBAction)quit:(id)sender;
- (IBAction)messageChange:(id)sender;
- (IBAction)soundChange:(id)sender;
- (IBAction)headChange:(id)sender;
@end
