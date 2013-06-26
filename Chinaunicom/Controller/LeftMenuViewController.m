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
#import "JKCustomAlert.h"
#import "UIViewController+MMDrawerController.h"


#import "ESSTimeViewController.h"
#import "BussinessDataViewController.h"
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

@synthesize viewDataArray;
@synthesize cardsViewCenterArray;
@synthesize buttonViewCenterArray;
@synthesize shakeViewTimer;
@synthesize deleteAndAddButtonStatusArray;
@synthesize menuArray;
@synthesize tempViewArray;
@synthesize scrollView;
@synthesize bottomViewDataArray;
@synthesize leftMenudelegate=_leftMenudelegate;
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
    
    firshTouch=YES;
    //背景图片
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
	
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 265, 410)];
	scrollView.alwaysBounceVertical = YES;
	scrollView.alwaysBounceHorizontal = NO;
    scrollView.showsHorizontalScrollIndicator=NO;

	scrollView.tag = MaxTagNumber;//防止删除子视图时将scrollView删掉
    scrollView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"left_menu_bg"]];
	[self.view addSubview:scrollView];
    //title
    UILabel *menuTopHeader=[[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 21)];
    [menuTopHeader setBackgroundColor:[UIColor clearColor]];
    [menuTopHeader setText:@"电商头条"];
    [menuTopHeader setTextColor:[UIColor whiteColor]];
	[scrollView addSubview:menuTopHeader];
    //bottom title
    UILabel *menuBottomHeader=[[UILabel alloc] initWithFrame:CGRectMake(20, 215, 100, 21)];
    [menuBottomHeader setBackgroundColor:[UIColor clearColor]];
    [menuBottomHeader setText:@"业务数据"];
    [menuBottomHeader setTextColor:[UIColor whiteColor]];
	[scrollView addSubview:menuBottomHeader];
    
    viewDataArray=[[NSMutableArray alloc] init];
	cardsViewCenterArray = [[NSMutableArray alloc] init];
	buttonViewCenterArray = [[NSMutableArray alloc] init];
    tempViewArray = [[NSMutableArray alloc] init];
    //
    bottomViewDataArray=[[NSMutableArray alloc] init];
    
	menuArray=[[NSMutableArray alloc] init];
    
    //    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_LEFT_BOTTOM_MENU_INFO];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
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
    if ([bottomViewDataArray count]>0) {
        
        [bottomViewDataArray removeAllObjects];
    }
    NSArray *myMenu=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_LEFTMENU_INFO];
    //下面菜单
    NSArray *bottomMenu=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_LEFT_BOTTOM_MENU_INFO];
    
    //默认初始化top菜单
    [viewDataArray addObject:@"11"];
    for (int i=0; i<[myMenu count];i++) {
        [viewDataArray addObject:[[myMenu objectAtIndex:i] objectForKey:@"reportTypeId"]];
    }
    //默认初始化bottom菜单
    for (int i=0; i<[bottomMenu count];i++) {
        [viewDataArray addObject:[bottomMenu objectAtIndex:i]];
    }
    for (NSString *theItem  in viewDataArray) {
        
        [tempViewArray addObject:theItem];
        
    }
    //
    if ([menuArray count]>0) {
        [menuArray removeAllObjects];
    }
    
    //当编辑菜单时，判断该菜单是添加还是删除
    [menuArray addObject:@"11"];
    for (int i=0; i<[myMenu count];i++) {
        [menuArray addObject:[[myMenu objectAtIndex:i] objectForKey:@"reportTypeId"]];
    }
    
    for (int i=0; i<[bottomMenu count];i++) {
        [menuArray addObject:[bottomMenu objectAtIndex:i]];
    }
    [CommonHelper changeSortArray:menuArray orderWithKey:@"" ascending:YES];
    [CommonHelper changeSortArray:tempViewArray orderWithKey:@"" ascending:YES];
    
    
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
	//int currentPage = 0;
	AnimationLeftMenuView *testView = nil;
    UIButton *mainButton=nil;
	for (NSString *theItem in theDataArray) {
        
		testView = [[AnimationLeftMenuView alloc] initWithFrame:CGRectMake(x-52, y-15, imageWidth, imageHeight) withNumber:[theItem intValue]];
        mainButton= [UIButton buttonWithType:UIButtonTypeCustom];
        mainButton.frame = CGRectMake(0, 10, 90, 75);
        [mainButton addTarget:self action:@selector(mainMenuTouch:) forControlEvents:UIControlEventTouchUpInside];
        [mainButton setImage:[UIImage imageNamed:[@"left_main_menu" stringByAppendingString:[NSString stringWithFormat:@"%d",[theItem intValue]] ]] forState:UIControlStateNormal];
        
		testView.tag = [theItem intValue];
        mainButton.tag=[theItem intValue]+200;
        [testView addSubview:mainButton];
		[scrollView addSubview:testView];
		NSValue *tempValue = [NSValue valueWithCGPoint:testView.center];
		[cardsViewCenterArray addObject:tempValue];
        
		index ++;
		x += IMAGE_GAP + imageWidth-70;
        
        if (index % 3 == 0) {
            if ([testView tag]>20) {
                
                x=IMAGE_GAP+85;
                y += IMAGE_GAP + imageHeight-38;
            }else{
                x = IMAGE_GAP;
                y += IMAGE_GAP + imageHeight-76;
            }
            
		}
        
        if (index % 5== 0) {
            
            x=IMAGE_GAP;
            y+=IMAGE_GAP+imageHeight-38;
            
        }
        if (index % 6==0) {
            
            x=IMAGE_GAP+85;
            y+=IMAGE_GAP-174;
            
        }
        
        if (index % 8 == 0) {
            
            x=IMAGE_GAP;
            y += IMAGE_GAP+23;
            
        }
        if (index % 9 == 0) {
            
            x=IMAGE_GAP+85;
            y += IMAGE_GAP-173;
            
        }
        
        
	}//loop end
    scrollView.contentSize=CGSizeMake(265,416);
    
    
    
}


- (void)addDeleteView {
    //用i去标记delete Button的tag,以防和view冲突
    int i=100;
    
	UIButton *deleteButton = nil;
    //
	for (UIView *tempView in scrollView.subviews) {
		if ([tempView isKindOfClass:[AnimationLeftMenuView class]]) {
            
            
            deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(tempView.frame.origin.x+58,
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
    [tempBtn removeTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [tempBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self refreshDeleteAndAddButton:[tempView tag]-200 isDelete:YES isLoop:NO];
    
    //[tempView tag] >=105的是『业务数据』的菜单
    if ([tempView tag]<105) {
        
        [self deleteAddType:DeleteReportType paramter:[NSString stringWithFormat:@"%d",[tempBtn tag]+11-100] ] ;
        
    }else{
        
        [self deleteOrAddBottomMenu:[tempBtn tag]+16-100 deleteOrAdd:@"delete"];
    }
    
}

#pragma mark - deleteButtonEvent
- (void)addAction:(UIButton *)sender {
	
    UIView *tempView = [scrollView viewWithTag:sender.tag];
    UIButton *tempBtn=(UIButton*)[[scrollView viewWithTag:sender.tag] viewWithTag:sender.tag];
    [tempBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [tempBtn removeTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [tempBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self refreshDeleteAndAddButton:[tempView tag]-200 isDelete:NO isLoop:NO];
    //[tempView tag] >=105的是『业务数据』的菜单
    if ([tempView tag]<105) {
        
        [self deleteAddType:AddReportType paramter:[NSString stringWithFormat:@"%d",[tempBtn tag]+11-100] ];
        
    }else{
        
        [self deleteOrAddBottomMenu:[tempBtn tag]+16-100 deleteOrAdd:@"add"];
    }
    
    
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
        
        //获取我已关注的菜单分
        [self showLoadingActivityViewWithString:@"保存中..."];
        
        NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
        User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
        
        [[requestServiceHelper defaultService] getMyMenuReportType:userid sucess:^(NSArray *array) {
            NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
            [userDefault setObject:array forKey:KEY_LEFTMENU_INFO];
            [userDefault synchronize];
            //停止
            if (isShake) {
                [self stopShake];}
            //再重新添加按钮上去
            [self removeScrollViewAllViews];
            [self initMainPageMenu];
            [self initCardsView:tempViewArray];
            //当完成编辑后，使button可触动
            [self disableButonWhenShake:0 isDisable:NO];
            [self hideLoadingActivityView];
        } falid:^(NSString *errorMsg) {
            //停止
            if (isShake) {
                [self stopShake];}
            [self hideLoadingActivityView];
        }];
        
    }
    
}

-(void)mainMenuTouch:(UIButton*)sender
{
    
//    NSLog(@"1111=%@",self.mm_drawerController.centerViewController);
//    UINavigationController *ct= self.mm_drawerController.centerViewController;
    if (sender.tag<219)
    {
        if ([_leftMenudelegate respondsToSelector:@selector(pushToMainPage:title:)]) {
            NSString *str=@"";
            int reid=0;
            if (sender.tag==211) {
                str=@"全部";
                reid=0;
            }else  if (sender.tag==213) {
                str=@"维护类";
                reid=13;
            }
            else  if (sender.tag==212) {
                str=@"安全类";
                reid=12;
            }
            else  if (sender.tag==214) {
                str=@"分析类";
                reid=14;
            }
            else if (sender.tag==215)
            {
                str=@"其他";
                reid=15;
            }
            
            [_leftMenudelegate pushToMainPage:reid title:str];
        }
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        }];

    }
    else
    {
        if (sender.tag==221)
        {
            ESSTimeViewController *ess=[[ESSTimeViewController alloc]initWithNibName:@"ESSTimeViewController" bundle:nil];
            [self.navigationController pushViewController:ess animated:YES];
        }else if (sender.tag==222)
        {
            BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
            bd.name=@"实时ESS合约计划";
            [self.navigationController pushViewController:bd animated:YES];
            
        }else if (sender.tag==223)
        {
            BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
            bd.name=@"实时ECS交易总额";
            [self.navigationController pushViewController:bd animated:YES];
            
        }else if (sender.tag==224)
        {
            BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
            bd.name=@"实时ECS商城订单";
            [self.navigationController pushViewController:bd animated:YES];
            
        }else if (sender.tag==225)
        {
            BussinessDataViewController *bd=[[BussinessDataViewController alloc]initWithNibName:@"BussinessDataViewController" bundle:nil];
            bd.name=@"实时ECS用户发展";
            [self.navigationController pushViewController:bd animated:YES];
        }
    }
   //    [self.mm_drawerController setCenterViewController:self.mm_drawerController.centerViewController withCloseAnimation:YES completion:nil];

    
//    MainViewController *mainCtrl=[[MainViewController alloc] init];
//    self.delegate=mainCtrl;
//    NSLog(@"button tag%d",[sender tag]);

//
//    [self.delegate pushToMainPage:[sender tag]];
//
//    BaseNavigationController *nav=[[BaseNavigationController alloc] initWithRootViewController:mainCtrl];
//    [self.revealSideViewController popViewControllerWithNewCenterController:nav
//                                                                   animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)opeartReportType{
    
    [self showLoadingActivityViewWithString:@"正在加载..."];
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    self.view.userInteractionEnabled=NO;
    [[requestServiceHelper defaultService] getAllReportType:userid sucess:^(NSArray *array) {
        
        if ([viewDataArray count]>0) {
            [viewDataArray removeAllObjects];
        }
        
        [viewDataArray addObject:@"11"];
        for (int i=0; i<[array count];i++) {
            [viewDataArray addObject:[[array objectAtIndex:i] objectForKey:@"reportTypeId"]];
        }
        //加载底部菜单
        [viewDataArray addObject:@"21"];
        [viewDataArray addObject:@"22"];
        [viewDataArray addObject:@"23"];
        [viewDataArray addObject:@"24"];
        [viewDataArray addObject:@"25"];
        [self initCardsView:viewDataArray];
        [self addDeleteView];
        
        [self hideLoadingActivityView];
        self.view.userInteractionEnabled=YES;
    } falid:^(NSString *errorMsg) {
        self.view.userInteractionEnabled=YES;
        [self hideLoadingActivityView];
    }];
    
}
//添加和删除分类
-(void)deleteAddType:(NSString *)url paramter:(NSString *)reportid {
    
    if ([bottomViewDataArray count]>0) {
        
        [bottomViewDataArray removeAllObjects];
    }
    //下面菜单
    NSArray *bottomMenu=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_LEFT_BOTTOM_MENU_INFO];
    for (int i=0; i<[bottomMenu count];i++) {
        [bottomViewDataArray addObject:[bottomMenu objectAtIndex:i]];
    }
    
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] init];
    [dictionary setValue:userid forKey:@"userId"];
    [dictionary setValue:reportid forKey:@"repTypeId"];
    
    if([url isEqualToString:DeleteReportType]){
        
        [self showLoadingActivityViewWithString:@"正在删除..."];
        
        [bottomViewDataArray addObject:[NSString stringWithFormat:@"%d",[reportid intValue]+5]];
        [[NSUserDefaults standardUserDefaults] setObject:bottomViewDataArray forKey:KEY_LEFT_BOTTOM_MENU_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }else{
        
        [self showLoadingActivityViewWithString:@"正在添加..."];
        [bottomViewDataArray removeObjectAtIndex:[bottomViewDataArray indexOfObject:[NSString stringWithFormat:@"%d",[reportid intValue]+5]]];
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:bottomViewDataArray forKey:KEY_LEFT_BOTTOM_MENU_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"add %@   bottomViewDataArray %@",[NSString stringWithFormat:@"%d",[reportid intValue]+5],bottomViewDataArray);
        
    }
    self.view.userInteractionEnabled=NO;
    
    
    [[requestServiceHelper defaultService]opreateReportType:url paramter:dictionary sucess:^(BOOL *isSucess) {
        
        [self hideLoadingActivityView];
        
        self.view.userInteractionEnabled=YES;
        [ALToastView toastInView:self.view withText:([url isEqualToString:DeleteReportType]?@"删除成功":@"添加成功")];
        
    } falid:^(NSString *errorMsg) {
        
        self.view.userInteractionEnabled=YES;
        
        [self hideLoadingActivityView];
    }];
    
    
    
    
}
//添加或是删除底部菜单选项
-(void)deleteOrAddBottomMenu:(int)tag deleteOrAdd:(NSString*)flag
{
    if ([bottomViewDataArray count]>0) {
        
        [bottomViewDataArray removeAllObjects];
    }
    //下面菜单
    NSArray *bottomMenu=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_LEFT_BOTTOM_MENU_INFO];
    for (int i=0; i<[bottomMenu count];i++) {
        [bottomViewDataArray addObject:[bottomMenu objectAtIndex:i]];
    }
    
    //
    if ([flag isEqualToString:@"add"]) {
        
        [self showLoadingActivityViewWithString:@"正在添加..."];
        
        [bottomViewDataArray addObject:[NSString stringWithFormat:@"%d",tag]];
        [[NSUserDefaults standardUserDefaults] setObject:bottomViewDataArray forKey:KEY_LEFT_BOTTOM_MENU_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self hideLoadingActivityView];
        [ALToastView toastInView:self.view withText:(@"添加成功")];
        
    }else{
        
        [self showLoadingActivityViewWithString:@"正在添加..."];
        [bottomViewDataArray removeObjectAtIndex:[bottomViewDataArray indexOfObject:[NSString stringWithFormat:@"%d",tag]]];
        
        [[NSUserDefaults standardUserDefaults] setObject:bottomViewDataArray forKey:KEY_LEFT_BOTTOM_MENU_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self hideLoadingActivityView];
        [ALToastView toastInView:self.view withText:(@"删除成功")];
        
    }
    
}

@end
