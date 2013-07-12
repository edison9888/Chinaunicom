//
//  MonthPointImageView.m
//  Chinaunicom
//
//  Created by rock on 13-7-11.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "MonthPointImageView.h"
#import  <QuartzCore/QuartzCore.h>
@implementation MonthPointImageView
@synthesize myDelegate=_myDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //计算起始坐标
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    
    self.blueDian.hidden=YES;
    
    self.anotherBlue.hidden=YES;
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint nowPoint = [touch locationInView:self];
    
    //计算位移=当前位置-起始位置
    float dx=nowPoint.x-beginPoint.x;
    //计算移动后的view中心点
    CGPoint newcenter = CGPointMake(self.center.x+dx, self.frame.origin.y+self.frame.size.height/2);
    
    /*限制用户不可将视图托出屏幕*/
    float halfx=CGRectGetMidX(self.bounds);
    //x坐标左边界
    newcenter.x=MAX(halfx,newcenter.x);
    //x坐标右边界
    newcenter.x=MIN(self.superview.bounds.size.width-halfx,newcenter.x);
    
    self.center = CGPointMake(newcenter.x, self.frame.origin.y+self.frame.size.height/2);
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    int num=0;
    if (self.center.x>2.5 && self.center.x<19.5) {
        
        self.center=CGPointMake(11.5, self.center.y);
        num=0;
    }else if (self.center.x>=19.5 && self.center.x<29.5)
    {
        self.center=CGPointMake(26.5, self.center.y);
        num=1;
    }else if (self.center.x>=29.5 && self.center.x<39.5)
    {
        self.center=CGPointMake(35.5, self.center.y);
        num=2;
    }else if (self.center.x>=39.5 && self.center.x<48)
    {
        num=3;
        self.center=CGPointMake(44.5, self.center.y);
    }else if (self.center.x>=48 && self.center.x<57)
    {
        num=4;
        self.center=CGPointMake(52.5+1, self.center.y);
    }else if (self.center.x>=57 && self.center.x<66)
    {
        num=5;
        self.center=CGPointMake(61.5+1, self.center.y);
    }else if (self.center.x>=66 && self.center.x<75)
    {
        num=6;
        self.center=CGPointMake(70.5+1, self.center.y);
    }else if (self.center.x>=75 && self.center.x<84)
    {
        num=7;
        self.center=CGPointMake(79.5+1, self.center.y);
    }else if (self.center.x>=84 && self.center.x<93)
    {
        num=8;
        self.center=CGPointMake(88.5+1, self.center.y);
    }else if (self.center.x>=93 && self.center.x<102)
    {
        num=9;
        self.center=CGPointMake(97.5+1, self.center.y);
    }else if (self.center.x>=102 && self.center.x<111)
    {
        num=10;
        self.center=CGPointMake(106.5+1, self.center.y);
    }else if (self.center.x>=111 && self.center.x<120)
    {
        num=11;
        self.center=CGPointMake(115.5+1, self.center.y);
        
    }else if (self.center.x>=120 && self.center.x<129)
    {
        num=12;
        self.center=CGPointMake(124.5+1, self.center.y);
    }else if (self.center.x>=129 && self.center.x<139.5)
    {
        num=13;
        self.center=CGPointMake(133.5+1, self.center.y);
    }else if (self.center.x>=139.5 && self.center.x<157.5)
    {
        num=14;
        self.center=CGPointMake(150+1, self.center.y);
    }else if (self.center.x>=157.5 && self.center.x<168.5)
    {
        num=15;
        self.center=CGPointMake(164.5+1, self.center.y);
    }else if (self.center.x>=168.5 && self.center.x<177.5)
    {
        num=16;
        self.center=CGPointMake(173.5+1, self.center.y);
    }else if (self.center.x>=177.5 && self.center.x<186.5)
    {
        num=17;
        self.center=CGPointMake(182.5+1, self.center.y);
    }else if (self.center.x>=186.5 && self.center.x<196.5)
    {
        num=18;
        self.center=CGPointMake(191.5+1, self.center.y);
    }else if (self.center.x>=196.5 && self.center.x<204.5)
    {
        num=19;
        self.center=CGPointMake(200.5+1, self.center.y);
    }else if (self.center.x>=204.5 && self.center.x<213.5)
    {
        num=20;
        self.center=CGPointMake(209.5+1, self.center.y);
    }else if (self.center.x>=213.5 && self.center.x<223.5)
    {
        num=21;
        self.center=CGPointMake(218.5+1, self.center.y);
    }else if (self.center.x>=223.5 && self.center.x<231.5)
    {
        num=22;
        self.center=CGPointMake(227.5+1, self.center.y);
    }else if (self.center.x>=231.5 && self.center.x<240.5)
    {
        num=23;
        self.center=CGPointMake(236.5+1, self.center.y);
    }else if (self.center.x>=240.5 && self.center.x<250.5)
    {
        num=24;
        self.center=CGPointMake(245.5+1, self.center.y);
    }else if (self.center.x>=250.5 && self.center.x<258.5)
    {
        num=25;
        self.center=CGPointMake(254.5+1, self.center.y);
    }else if (self.center.x>=258.5 && self.center.x<267.5)
    {
        num=26;
        self.center=CGPointMake(263.5+1, self.center.y);
    }else if (self.center.x>=267.5 && self.center.x<276.5)
    {
        num=27;
        self.center=CGPointMake(272.5+1, self.center.y);
    }else if (self.center.x>=276.5 && self.center.x<286.5)
    {
        num=28;
        self.center=CGPointMake(282.5+1, self.center.y);
    }else if (self.center.x>=286.5 && self.center.x<298.5)
    {
        num=29;
        self.center=CGPointMake(291.5+1, self.center.y);
    }else if (self.center.x>=298.5 && self.center.x<310)
    {
        num=30;
        self.center=CGPointMake(308.5+1, self.center.y);
    }
    [_myDelegate showTheData:self.center.x num:num];
}
@end