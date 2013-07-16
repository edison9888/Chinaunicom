//
//  SettingController.h
//  Chinaunicom
//
//  Created by rock on 13-5-22.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "DCRoundSwitch.h"
#import "RightMenuViewController.h"
@interface SettingController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *versionButton;
@property (strong,nonatomic)RightMenuViewController *Controll;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet DCRoundSwitch *message;
@property (weak, nonatomic) IBOutlet DCRoundSwitch *sound;
- (IBAction)changePwd:(id)sender;
- (IBAction)quit:(id)sender;
- (IBAction)messageChange:(id)sender;
- (IBAction)soundChange:(id)sender;
- (IBAction)headChange:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)updateVersion:(UIButton *)sender;
@end
