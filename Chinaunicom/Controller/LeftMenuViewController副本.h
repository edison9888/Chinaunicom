//
//  LeftViewController.h
//  Chinaunicom
//
//  Created by  on 13-5-6.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "CustomLeftMenuViewCell.h"
#import "AnimationLeftMenuView.h"

@protocol LeftMenuViewControllerDelegate <NSObject>
-(void)pushToMainPage:(int)tag;
@end

@interface LeftMenuViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *scrollView;
	NSMutableArray *viewDataArray;
	NSMutableArray *cardsViewCenterArray;
	NSMutableArray *buttonViewCenterArray;
	
	NSTimer *shakeViewTimer;
	BOOL isShake;
    BOOL firshTouch;
}

@property(strong , nonatomic) UITableView *mytableView;
@property(strong , nonatomic) UIScrollView *scrollView;
@property(weak, nonatomic) id<LeftMenuViewControllerDelegate> delegate;
//
@property (nonatomic, retain) NSMutableArray *viewDataArray;
@property (nonatomic, retain) NSMutableArray *cardsViewCenterArray;
@property (nonatomic, retain) NSMutableArray *buttonViewCenterArray;
@property (nonatomic, retain) NSMutableArray *deleteAndAddButtonStatusArray;
@property (nonatomic, retain) NSMutableArray *menuArray;
@property (nonatomic, retain) NSMutableArray *tempViewArray;
@property int iconTag;
@property (nonatomic, retain, readonly) NSTimer *shakeViewTimer;

- (void)initCardsView:(NSMutableArray*)theDataArray;
- (void)addDeleteView;
- (void)startTimer;
- (void)stopShake;
- (void)wobble;
- (void)disableButonWhenShake:(NSInteger)tag isDisable:(BOOL)flag;

@end
