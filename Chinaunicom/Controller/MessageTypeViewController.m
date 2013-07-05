//
//  MessageTypeViewController.m
//  Chinaunicom
//
//  Created by 李天焜 on 13-5-16.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "MessageTypeViewController.h"
#import "SendAudiReport.h"
#import "SysConfig.h"
#import "requestServiceHelper.h"
#import "AnimationLeftMenuView.h"
#import "User.h"
#define IMAGE_GAP 56
#define MaxTagNumber 999

@interface MessageTypeViewController ()

@end

@implementation MessageTypeViewController

@synthesize mytableView=_mytableView;
//
@synthesize viewDataArray;
@synthesize tempViewArray;
@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"发布信息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    viewDataArray=[[NSMutableArray alloc] init];
    tempViewArray = [[NSMutableArray alloc] init];
    
    [self initLayout];
    
    [self opeartReportType];
}

-(void)initLayout
{
    //背景图片
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 32, 32);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backItem;
    /*分割线1*/
    UIImageView *imageViewTopDiv1=[[UIImageView alloc] initWithFrame:CGRectMake(40, -10, 30, 63)];
    [imageViewTopDiv1 setImage:[UIImage imageNamed:@"topDividingLine"]];
    [imageViewTopDiv1 setTag:101];
    [self.navigationController.navigationBar addSubview:imageViewTopDiv1];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.height, self.view.frame.size.width)];
	scrollView.alwaysBounceVertical = YES;
	scrollView.alwaysBounceHorizontal = NO;
    scrollView.showsHorizontalScrollIndicator=NO;
	scrollView.tag = MaxTagNumber;//防止删除子视图时将scrollView删掉
	[self.view addSubview:scrollView];
    
}

- (void)initCardsView:(NSMutableArray*)theDataArray{
    
    
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
		testView = [[AnimationLeftMenuView alloc] initWithFrame:CGRectMake(x-10, y-44, imageWidth, imageHeight) withNumber:[theItem intValue]];
        mainButton= [UIButton buttonWithType:UIButtonTypeCustom];
        mainButton.frame = CGRectMake(0, 0, 100, 100);
        [mainButton addTarget:self action:@selector(mainMenuTouch:) forControlEvents:UIControlEventTouchUpInside];
        [mainButton setImage:[UIImage imageNamed:[@"left_main" stringByAppendingString:[NSString stringWithFormat:@"%d",[theItem intValue]*10+1] ]] forState:UIControlStateNormal];
//        [mainButton setImage:[UIImage imageNamed:[@"left_main_selected" stringByAppendingString:[NSString stringWithFormat:@"%d",[theItem intValue]] ]] forState:UIControlStateHighlighted];
        
		testView.tag = [theItem intValue];
        mainButton.tag=[theItem intValue];
        [testView addSubview:mainButton];
		[scrollView addSubview:testView];
        //
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

-(void)opeartReportType{
    
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_INFO];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    NSString *userid = [NSString stringWithFormat:@"%d",[user.userId intValue]];
    self.view.userInteractionEnabled=NO;
    [[requestServiceHelper defaultService] getAllReportType:userid sucess:^(NSArray *array) {
        
        if ([viewDataArray count]>0) {
            [viewDataArray removeAllObjects];
        }
        
        for (int i=0; i<[array count];i++) {
            [viewDataArray addObject:[[array objectAtIndex:i] objectForKey:@"reportTypeId"]];
        }
        [self initCardsView:viewDataArray];
        
    } falid:^(NSString *errorMsg) {
        
    }];
    
}

-(void)mainMenuTouch:(UIButton*)sender
{
    SendAudiReport *sendCtrl=[[SendAudiReport alloc] init];
    sendCtrl.reportTypeId=[NSString stringWithFormat:@"%d",sender.tag];
    [self.navigationController pushViewController:sendCtrl animated:YES];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
