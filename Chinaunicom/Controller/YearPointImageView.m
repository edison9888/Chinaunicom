//
//  YearPointImageView.m
//  Chinaunicom
//
//  Created by YY on 13-6-30.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "YearPointImageView.h"


@implementation YearPointImageView
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
    int i=1;
    if (self.center.x>0 && self.center.x <28) {
        self.center=CGPointMake(14.5, self.center.y);
        i=1;
    }else if (self.center.x>=28 && self.center.x <55)
    {
        self.center=CGPointMake(41.5, self.center.y);
        i=2;
    }else if (self.center.x>=55 && self.center.x <81)
    {
        self.center=CGPointMake(68.5, self.center.y);
        i=3;
    }else if (self.center.x>=81 &&self.center.x <108)
    {
        self.center=CGPointMake(94.5, self.center.y);
        i=4;
    }else if (self.center.x >= 108 && self.center.x <134)
    {
        self.center=CGPointMake(121.5, self.center.y);
        i=5;
    }else if (self.center.x>=134 && self.center.x<160)
    {
        self.center=CGPointMake(147.5, self.center.y);
        i=6;
    }else if (self.center.x>=160 && self.center.x<186)
    {
        self.center=CGPointMake(173.5, self.center.y);
        i=7;
    }else if (self.center.x>=186 && self.center.x <212.5)
    {
        self.center=CGPointMake(200.5, self.center.y);
        i=8;
    }else if (self.center.x>=212.5 && self.center.x<239.5)
    {
        self.center=CGPointMake(225.5, self.center.y);
        i=9;
    }else if (self.center.x>=239.5 && self.center.x<265.5)
    {
        self.center=CGPointMake(252.5, self.center.y);
        i=10;
    }else if (self.center.x>=265.5 &&self.center.x<292.5)
    {
        self.center=CGPointMake(279.5, self.center.y);
        i=11;
    }else if (self.center.x>=292.5)
    {
        self.center=CGPointMake(305.5, self.center.y);
        i=12;
    }
    [_myDelegate showTheData:i];
}
@end
