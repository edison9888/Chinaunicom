//
//  MonthPointImageView.m
//  Chinaunicom
//
//  Created by rock on 13-7-11.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "MonthPointImageView.h"

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
    NSLog(@"aaaa=%@",NSStringFromCGPoint(self.center));
}
@end