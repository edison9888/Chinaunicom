//
//  PayViewController.m
//  Chinaunicom
//
//  Created by YY on 13-6-26.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "PayViewController.h"
#import "requestServiceHelper.h"
#import "Utility.h"
@interface PayViewController ()

@end

@implementation PayViewController
@synthesize str=_str;
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
    self.titleLabel.text=_str;
    [self getLocalData];
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObject:@"today" forKey:@"timeStr"];
    [[requestServiceHelper defaultService]getEssHourTrend:dict sucess:^(NSDictionary *nsdict) {
        NSString *num=[Utility changeToyuan:[nsdict objectForKey:@"00"]];
        self.numLabel.text=[NSString stringWithFormat:@"00点 : %@",num];
        NSMutableArray *muArray=[self ratio:nsdict];
        [self drawBlueLine:muArray];
    } falid:^(NSString *errorMsg) {
    }];

    // Do any additional setup after loading the view from its nib.
}

- (IBAction)pressTodayButton:(id)sender {
    
    [self getLocalData];
    [self isInTheRect:sender];
}

- (IBAction)pressAvgButton:(id)sender {
    
    [self isInTheRect:sender];
}

- (IBAction)pressYesterdayButton:(id)sender {
    
    [self isInTheRect:sender];
}
-(void)isInTheRect : (UIButton *)bt
{
    CGPoint point=CGPointMake(self.lineImageView.frame.origin.x, self.lineImageView.frame.origin.y);
    BOOL isIn= CGRectContainsPoint(bt.frame,point);
    if (!isIn) {

        [UIView animateWithDuration:0.3f animations:^{
            self.lineImageView.frame=CGRectMake(bt.frame.origin.x+27, self.lineImageView.frame.origin.y, self.lineImageView.frame.size.width, self.lineImageView.frame.size.height);
            
        }];
    }
}
-(IBAction)popToHigherLevel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setNumLabel:nil];
    [self setYesterdayButton:nil];
    [self setTodayButton:nil];
    [self setAvgButton:nil];
    [self setLineImageView:nil];
    [self setLocalTimeLabel:nil];
    [self setBgImageView:nil];
    [super viewDidUnload];
}
-(void)getLocalData 
{
    NSString *str=[Utility getTodayDate];
    self.localTimeLabel.text=[NSString stringWithFormat:@"%@日整点数据",str];
}

-(NSMutableArray *)ratio :(NSDictionary *)dict 
{
    NSString *str=nil;
    NSMutableArray *muArray=[NSMutableArray array];
    for (int i=0; i<[dict count]; i++) {
        if (i==0) {
            str =[dict objectForKey:@"00"];
        } else if (i==1) {
            str =[dict objectForKey:@"01"];
            
        } else if (i==2) {
            str =[dict objectForKey:@"02"];
          
        } else if (i==3) {
            str =[dict objectForKey:@"03"];
            
        } else if (i==4) {
            str =[dict objectForKey:@"04"];
          
        } else if (i==5) {
            str =[dict objectForKey:@"05"];
           
        } else if (i==6) {
            str =[dict objectForKey:@"06"];
          
        } else if (i==7) {
            str =[dict objectForKey:@"07"];
           
        } else if (i==8) {
            str =[dict objectForKey:@"08"];
         
        } else if (i==9) {
            str =[dict objectForKey:@"09"];
          
        } else if (i==10) {
            str =[dict objectForKey:@"10"];
            
        } else if (i==11) {
            str =[dict objectForKey:@"11"];
         
        } else if (i==12) {
            str =[dict objectForKey:@"12"];
          
        } else if (i==13) {
            str =[dict objectForKey:@"13"];
          
        } else if (i==14) {
            str =[dict objectForKey:@"14"];
            
        } else if (i==15) {
            str =[dict objectForKey:@"15"];
          
        }else if (i==16) {
            str =[dict objectForKey:@"16"];
            
        }else if (i==17) {
            str =[dict objectForKey:@"17"];
            
        }else if (i==18) {
            str =[dict objectForKey:@"18"];
            
        }else if (i==19) {
            str =[dict objectForKey:@"19"];
            
        }else if (i==20) {
            str =[dict objectForKey:@"20"];
            
        }else if (i==21) {
            str =[dict objectForKey:@"21"];
            
        }else if (i==22) {
            str =[dict objectForKey:@"22"];
            
        }else if (i==23) {
            str =[dict objectForKey:@"23"];
            
        }else if (i==24) {
            str =[dict objectForKey:@"24"];
            
        }
        [muArray addObject:str];
    }
    float maxNum=[self maxNum:muArray];
    float minNum=[self minNum:muArray];
    if (minNum==0) {
        minNum=1;
    }
    float bei=maxNum/minNum;
    
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:[muArray count]];
    for (int i=0; i<[muArray count]; i++) {
        float data = [[muArray objectAtIndex:i]floatValue];
        float bi =data/bei*180;
        [array addObject:[NSString stringWithFormat:@"%f",bi]];
    }
    return array;
}
-(void)drawBlueLine : (NSMutableArray *)blueArray
{
    UIImageView  *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 310, self.bgImageView.frame.size.height-15)];
    [imageView setBackgroundColor:[UIColor clearColor]];
//    [imageView.layer setBorderColor:[UIColor redColor].CGColor];
//    [imageView.layer setBorderWidth:1.0f];
    [self.bgImageView  addSubview:imageView];
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    CGFloat pointLineWidth = 1.5f;
    CGFloat pointMiterLimit = 1.0f;
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), pointLineWidth);//主线宽度
    CGContextSetMiterLimit(UIGraphicsGetCurrentContext(), pointMiterLimit);//投影角度

    CGContextSetLineJoin(UIGraphicsGetCurrentContext(), 0);
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), 2 );
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blueColor].CGColor);
    
	//绘图
	float p1 = [[blueArray objectAtIndex:0] floatValue];
	int i = 1;
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, imageView.bounds.size.height-p1);
	for (; i<[blueArray count]; i++)
	{
		p1 = [[blueArray objectAtIndex:i] floatValue];
        CGPoint goPoint = CGPointMake(i*14, imageView.bounds.size.height-p1);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), goPoint.x, goPoint.y);;
        
	}
	CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
//-(int)totalsum : (NSArray *)array num:(int)n
//{
//    int sum=0;
//    for (int i = 0 ; i<[array count]; i++) {
//        sum+=[[array objectAtIndex:i]intValue];
//    }
//    return sum;
//}
//找最大值
-(float )maxNum : (NSMutableArray *)array
{
    int big=[[array objectAtIndex:0] floatValue];
    for (int i=0; i<[array count]; i++) {
        if (big<[[array objectAtIndex:i] floatValue]) {
            big=[[array objectAtIndex:i]floatValue];
        }
    }
    return big;
}
//找最小值
-(float)minNum:(NSMutableArray *)array
{
    float small=[[array objectAtIndex:0] floatValue];
    for (int i=0; i<[array count]; i++) {
        if ([[array objectAtIndex:i] floatValue]<small) {
            small=[[array objectAtIndex:i]floatValue];
        }
    }
    return small;
}
@end
