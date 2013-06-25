//
//  LeftViewController.m
//  Chinaunicom
//
//  Created by on 13-5-6.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SysConfig.h"
//#import "CommonHelper.h"
#import "requestServiceHelper.h"
#import "User.h"
#define IMAGE_GAP 56
#define MaxTagNumber 999

/////////////////////////////////////////////////////////////////
static const CGFloat kWobbleRadians = 1.5;
static const NSTimeInterval kWobbleTime = 0.07;
/////////////////////////////////////////////////////////////////

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

@synthesize mytableView=_mytableView;
//
@synthesize viewDataArray;
@synthesize cardsViewCenterArray;
@synthesize buttonViewCenterArray;
@synthesize shakeViewTimer;
@synthesize deleteAndAddButtonStatusArray;
@synthesize menuArray;
@synthesize tempViewArray;
@synthesize scrollView;


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
//  {"reportTypeId":"12","reportTypeName":"安全类"},{"reportTypeId":"13","reportTypeName":"维护类"},{"reportTypeId":"14","reportTypeName":"分析类"},{"reportTypeId":"15","reportTypeName":"其他类"}]}
    

    firshTouch=YES;
    //背景图片
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
	
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.height, self.view.frame.size.width+144)];
	scrollView.alwaysBounceVertical = YES;
	scrollView.alwaysBounceHorizontal = NO;
    scrollView.showsHorizontalScrollIndicator=NO;
	scrollView.tag = MaxTagNumber;//防止删除子视图时将scrollView删掉
	[self.view addSubview:scrollView];
	
	//viewDataArray = [[NSMutableArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4",nil];
    viewDataArray=[[NSMutableArray alloc] init];
	cardsViewCenterArray = [[NSMutableArray alloc] init];
	buttonViewCenterArray = [[NSMutableArray alloc] init];
    tempViewArray = [[NSMutableArray alloc] init];
//    menuArray=[[NSMutableArray alloc] initWithObjects:@"all",
//                                        @"safety",
//                                        @"maintain",
//                                        @"analysis",
//                                        @"other",
//                                        nil];
	menuArray=[[NSMutableArray alloc] init];
    [self initLayout];
    [self initMainPageMenu];
    [self initCardsView:tempViewArray];
      
    
}

#pragma mark - initLayout
-(void)initLayout
{
    
    //创建navbar
    UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [nav setBackgroundImage:[UIImage imageNamed:@"title.png"] forBarMetrics:UIBarMetricsDefault];
    //电商头条
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 30, 30)];
    [imageView setImage:[UIImage imageNamed:@"leftTop_navg"]];
    [nav addSubview:imageView];
    
    UIButton* personalButton= [UIButton buttonWithType:UIButtonTypeCustom];
    personalButton.frame = CGRectMake(25, 8, 100, 30);
    [personalButton setTitle:@"电商头条" forState:UIControlStateNormal];
    [personalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[personalButton setTag:1];
    [personalButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:personalButton];
    
    /*分割线*/
    UIImageView *imageViewTopDiv=[[UIImageView alloc] initWithFrame:CGRectMake(205, 0, 30, 44)];
    [imageViewTopDiv setImage:[UIImage imageNamed:@"topDividingLine"]];
    [nav addSubview:imageViewTopDiv];
    
    //编辑
    UIButton* editButton= [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(230, 8, 30, 30);
    [editButton setBackgroundImage:[UIImage imageNamed:@"main_edit"] forState:UIControlStateNormal];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editButton setTag:1];
    [editButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:editButton];
    //完成
    UIButton* doneButton= [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(230, 8, 40, 30);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTag:2];
    [doneButton setHidden:YES];
    [doneButton addTarget:self action:@selector(doDone:) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:doneButton];
    
    [self.view addSubview:nav];
    //
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"safety"] ==nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"safety"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"maintain"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"analysis"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"other"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    
    
}

#pragma mark - initMainPageMenu
-(void) initMainPageMenu
{

    if ([tempViewArray count]>0) {
        [tempViewArray removeAllObjects];
    }
    if ([viewDataArray count]>0) {
        [viewDataArray removeAllObjects];
    }
    NSArray *myMenu=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_LEFTMENU_INFO];
    
    [viewDataArray addObject:@"11"];
    for (int i=0; i<[myMenu count];i++) {
        [viewDataArray addObject:[[myMenu objectAtIndex:i] objectForKey:@"reportTypeId"]];
    }

    for (NSString *theItem  in viewDataArray) {
        //if ([[deleteAndAddButtonStatusArray objectAtIndex:[theItem intValue]] boolValue]) {
            [tempViewArray addObject:theItem];
        //}
    }
    
    //
    if ([menuArray count]>0) {
        [menuArray removeAllObjects];
    }
    [menuArray addObject:@"11"];
    for (int i=0; i<[myMenu count];i++) {
        [menuArray addObject:[[myMenu objectAtIndex:i] objectForKey:@"reportTypeId"]];
    }
    //NSLog(@"rrr %@",viewDataArray);
}
-(void) removeScrollViewAllViews
{
        
    for (UIView *tempView in scrollView.subviews) {
        if ([tempView isKindOfClass:[AnimationLeftMenuView class]]) {
                
                [tempView removeFromSuperview];
        }
    }
}

#pragma mark - initCardsView
- (void)initCardsView:(NSMutableArray*)theDataArray{
    
    if ([cardsViewCenterArray count]>0) {
        [cardsViewCenterArray removeAllObjects];
    }
    
	NSInteger theCount = [theDataArray count];
	NSUInteger countPage = ((theCount%4) == 0) ? (theCount/4) : (theCount/4 + 1);
	CGFloat scrollWidth = scrollView.bounds.size.width;
	CGFloat scrollHeight = scrollView.bounds.size.height-144;
	scrollView.contentSize = CGSizeMake(scrollWidth, scrollHeight*countPage);
    
	CGFloat imageWidth = 100;
	CGFloat imageHeight =100; 
    
	CGFloat x = IMAGE_GAP;
	CGFloat y = IMAGE_GAP;
    
	int index = 0;
	int currentPage = 0;
	AnimationLeftMenuView *testView = nil;
    UIButton *mainButton=nil;
	for (NSString *theItem in theDataArray) {
		testView = [[AnimationLeftMenuView alloc] initWithFrame:CGRectMake(x-36, y-44, imageWidth, imageHeight) withNumber:[theItem intValue]];
        mainButton= [UIButton buttonWithType:UIButtonTypeCustom];
        mainButton.frame = CGRectMake(0, 0, 100, 100);
        [mainButton addTarget:self action:@selector(mainMenuTouch:) forControlEvents:UIControlEventTouchUpInside];
        [mainButton setImage:[UIImage imageNamed:[@"left_main" stringByAppendingString:[NSString stringWithFormat:@"%d",[theItem intValue]] ]] forState:UIControlStateNormal];
        //[mainButton setTitle:[@"abc" stringByAppendingString:[NSString stringWithFormat:@"%d",[theItem intValue]]] forState:UIControlStateNormal];
        //
        [mainButton setImage:[UIImage imageNamed:[@"left_main_selected" stringByAppendingString:[NSString stringWithFormat:@"%d",[theItem intValue]] ]] forState:UIControlStateHighlighted];
       
        /*长按事件
		UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
		longPressRecognizer.allowableMovement = 30;
		[testView addGestureRecognizer:longPressRecognizer];
         */

		testView.tag = [theItem intValue];
        mainButton.tag=[theItem intValue]+200;
        [testView addSubview:mainButton];
		[scrollView addSubview:testView];
		NSValue *tempValue = [NSValue valueWithCGPoint:testView.center];
		[cardsViewCenterArray addObject:tempValue];
        //
        //NSLog(@"temview %d",testView.tag);
        //NSLog(@"buton %d",mainButton.tag);
		index ++;
		x += IMAGE_GAP + imageWidth-26;
        
		if (index % 4 == 0) {
			currentPage ++;
			x = IMAGE_GAP;
			y = currentPage*scrollHeight +IMAGE_GAP-93;
		}
		else if (index % 2 == 0) {
			x = IMAGE_GAP;
			y += IMAGE_GAP + imageHeight-42;
		}
	}
}

#pragma mark - Handling long presses
- (void)handleLongPress:(UILongPressGestureRecognizer*)longPressRecognizer {
	if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        if (firshTouch) {
            
            [self addDeleteView];
            isShake = YES;
            [self wobble];
            
            UIButton *edit=(UIButton*)[self.view viewWithTag:1];
            UIButton *done=(UIButton*)[self.view viewWithTag:2];
            [done setHidden:NO];
            [edit setHidden:YES];
            
            firshTouch=NO;
        }
		
	}
}

- (void)addDeleteView {
    //用i去标记delete Button的tag,以防和view冲突
    int i=100;

	UIButton *deleteButton = nil;
    //
	for (UIView *tempView in scrollView.subviews) {
		if ([tempView isKindOfClass:[AnimationLeftMenuView class]]) {
             
            
                deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(tempView.frame.origin.x+68,
																	  tempView.frame.origin.y + tempView.frame.size.height/2 - 50,
																	  32, 32)];
                
                deleteButton.imageView.tag = tempView.tag;
                deleteButton.tag = i;
            
                if ([menuArray indexOfObject:[NSString stringWithFormat:@"%d",[tempView tag]]]!=NSNotFound) {
                    
                        [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else{
                        
                        [deleteButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
                        [deleteButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
                }
            
                //第一个功能按钮不删除
                if (tempView.tag==11){
                    [deleteButton setHidden:YES];
                }
                [scrollView addSubview:deleteButton];
                NSValue *tempValue = [NSValue valueWithCGPoint:deleteButton.center];
                [buttonViewCenterArray addObject:tempValue];
                //当出现删除时，使button不可触动
                [self disableButonWhenShake:tempView.tag isDisable:YES];
                i++;
                [self refreshDeleteAndAddButton:[deleteButton tag]-100 isDelete:NO isLoop:YES];
    
		}
	}
}
#pragma mark - refreshDeleteAndAddButton status
-(void)refreshDeleteAndAddButton:(int)btnTag isDelete:(BOOL)flag isLoop:(BOOL)loop;
{
    
    UIButton *tempBtn=nil;

    if(flag){
        tempBtn=(UIButton*)[[scrollView viewWithTag:btnTag] viewWithTag:btnTag];
        [tempBtn setBackgroundColor:[UIColor grayColor]];

        tempBtn=(UIButton*)[[scrollView viewWithTag:btnTag] viewWithTag:btnTag+200];

        [tempBtn setHighlighted:YES];
    }else{
        if (loop) {
            NSLog(@"%d",btnTag);
//            if (![[deleteAndAddButtonStatusArray objectAtIndex:btnTag] boolValue]) {
//                tempBtn=(UIButton*)[[scrollView viewWithTag:btnTag] viewWithTag:btnTag];
//
//                [tempBtn setBackgroundColor:[UIColor grayColor]];
//            if (![[deleteAndAddButtonStatusArray objectAtIndex:btnTag] boolValue]) {
//                tempBtn=(UIButton*)[[scrollView viewWithTag:btnTag] viewWithTag:btnTag+200];
//                [tempBtn setHighlighted:YES];
//            }else{
//                tempBtn=(UIButton*)[[scrollView viewWithTag:btnTag] viewWithTag:btnTag];
//
//                [tempBtn setBackgroundColor:[UIColor clearColor]];
//                tempBtn=(UIButton*)[[scrollView viewWithTag:btnTag] viewWithTag:btnTag+200];
//                [tempBtn setHighlighted:NO];
//            }
            if ([menuArray indexOfObject:[NSString stringWithFormat:@"%d",btnTag+11]]==NSNotFound) {
                
                tempBtn=(UIButton*)[[scrollView viewWithTag:btnTag+11] viewWithTag:btnTag+211];
                [tempBtn setHighlighted:YES];
            }
               
        }else{
            tempBtn=(UIButton*)[[scrollView viewWithTag:btnTag] viewWithTag:btnTag];
            [tempBtn setBackgroundColor:[UIColor grayColor]];

            tempBtn=(UIButton*)[[scrollView viewWithTag:btnTag] viewWithTag:btnTag+200];
            [tempBtn setHighlighted:NO];
        
        }
    }
}

#pragma mark - deleteButtonEvent
- (void)delete:(UIButton *)sender {
	
    
    UIView *tempView = [scrollView viewWithTag:sender.tag];
    //delete or add icon
	UIButton *tempBtn=(UIButton*)[[scrollView viewWithTag:sender.tag] viewWithTag:sender.tag];
    [tempBtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];

    [self refreshDeleteAndAddButton:[tempView tag]-100 isDelete:YES isLoop:NO];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[menuArray objectAtIndex:[tempView tag]-100]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
     NSLog(@"title:%@   %d",[tempBtn currentTitle],tempView.tag);

}
    
#pragma mark - deleteButtonEvent
- (void)addAction:(UIButton *)sender {
	
    UIView *tempView = [scrollView viewWithTag:sender.tag];
    UIButton *tempBtn=(UIButton*)[[scrollView viewWithTag:sender.tag] viewWithTag:sender.tag];
    [tempBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    //重新设置删除和添加按钮的状态
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[menuArray objectAtIndex:[tempView tag]-100]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //
    [self refreshDeleteAndAddButton:[tempView tag]-100 isDelete:NO isLoop:NO];

    NSLog(@"ADD %d",[tempView tag]);
    
}

- (void)wobble {
    
	static BOOL wobblesLeft = NO;
	
	if (isShake) {
		CGFloat rotation = (kWobbleRadians * M_PI) / 180.0;
		CGAffineTransform wobbleLeft = CGAffineTransformMakeRotation(rotation);
		CGAffineTransform wobbleRight = CGAffineTransformMakeRotation(-rotation);
		
		[UIView beginAnimations:nil context:nil];
		
		NSInteger i = 0;
		NSInteger nWobblyButtons = 0;
		
		for (UIView *tempView in [scrollView subviews]) {
			if ([tempView isKindOfClass:[AnimationLeftMenuView class]] || [tempView isKindOfClass:[UIButton class]]) {
				++nWobblyButtons;
				if (i % 2) {
					tempView.transform = wobblesLeft ? wobbleRight : wobbleLeft;
				} else {
					tempView.transform = wobblesLeft ? wobbleLeft : wobbleRight;
				}
				++i;
			}
		}
		
		if (nWobblyButtons >= 1) {
			[UIView setAnimationDuration:kWobbleTime];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(wobble)];
			wobblesLeft = !wobblesLeft;
			
		} else {
			[NSObject cancelPreviousPerformRequestsWithTarget:self];
			[self performSelector:@selector(wobble) withObject:nil afterDelay:kWobbleTime];
		}
		
		[UIView commitAnimations];
	}
}

- (void)startTimer {
	isShake = YES;
	if (shakeViewTimer == nil) {
		shakeViewTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
														selector:@selector(wobble) userInfo:nil repeats:NO];
	}
}

- (void)stopShake {
	isShake = NO;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3f];
    //	[UIView setAnimationDelegate:self];
	
	for (UIView *tempView in [scrollView subviews]) {
		tempView.transform = CGAffineTransformIdentity;
	}
	[UIView commitAnimations];
	
	for (UIView *tempView in [scrollView subviews]) {
		if ([tempView isKindOfClass:[UIButton class]]) {
			[tempView removeFromSuperview];
		}
	}
}

- (void)disableButonWhenShake:(NSInteger)tag isDisable:(BOOL)flag
{
    if (flag) {
        
        UIButton *temBtn=(UIButton*)[[scrollView viewWithTag:tag] viewWithTag:tag];
        [temBtn setEnabled:NO];
        
    }else{
        
        for (UIView *tempView in scrollView.subviews) {
            if ([tempView isKindOfClass:[AnimationLeftMenuView class]]) {
                
                UIButton *temBtn=(UIButton*)[[scrollView viewWithTag:tempView.tag] viewWithTag:tempView.tag];
                [temBtn setEnabled:YES];
            }
        }
        
    }
    
}
-(void)doDone:(id)sender
{
    UIButton *edit=(UIButton*)[self.view viewWithTag:1];
    UIButton *done=(UIButton*)[self.view viewWithTag:2];
    
    
    UIButton *btn=(UIButton*)sender;
    if ([[btn currentTitle] isEqualToString:@"编辑"]) {
        [done setHidden:NO];
        [edit setHidden:YES];

        firshTouch=NO;
        if (!isShake) {
            
            //重新刷新按钮效果
            [self removeScrollViewAllViews];
            [self opeartReportType];
            
            isShake = YES;
            [self wobble];
        }
        
    }
    if ([[btn currentTitle] isEqualToString:@"完成"]) {
        [done setHidden:YES];
        [edit setHidden:NO];
        firshTouch=YES;
        
        //停止
        if (isShake) {
            [self stopShake];
        }
        //再重新添加按钮上去
        [self removeScrollViewAllViews];
        [self initMainPageMenu];
        [self initCardsView:tempViewArray];
        //当完成编辑后，使button可触动
        [self disableButonWhenShake:0 isDisable:NO];
    }
    
}

-(void)mainMenuTouch:(UIButton*)sender
{
    
    
    MainViewController *mainCtrl=[[MainViewController alloc] init];
    self.delegate=mainCtrl;
    NSLog(@"button tag%d",[sender tag]);
   // if ([sender tag]==201) {
        mainCtrl.title=@"安全";
        mainCtrl.reportid=@"15";
   // }
  [self.delegate pushToMainPage:[sender tag]];

   BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:mainCtrl];
    [self.revealSideViewController popViewControllerWithNewCenterController:nav
                                                                 animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)opeartReportType{
    
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    
    [[requestServiceHelper defaultService] getAllReportType:userid sucess:^(NSArray *array) {
        
        if ([viewDataArray count]>0) {
            [viewDataArray removeAllObjects];
        }

        [viewDataArray addObject:@"11"];
        for (int i=0; i<[array count];i++) {
            [viewDataArray addObject:[[array objectAtIndex:i] objectForKey:@"reportTypeId"]];
        }
        [self initCardsView:viewDataArray];
        [self addDeleteView];
        
    } falid:^(NSString *errorMsg) {
        
    }];
    
}
@end
