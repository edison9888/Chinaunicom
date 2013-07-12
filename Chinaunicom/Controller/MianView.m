//
//  MianView.m
//  Chinaunicom
//
//  Created by rock on 13-7-11.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "MianView.h"
#import "CommonHelper.h"
#import <QuartzCore/QuartzCore.h>
@implementation MianView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setCornerRadius:5];
        [self.layer setBorderWidth:1.0];
        [self.layer setBorderColor:[UIColor clearColor].CGColor];
        [self setClipsToBounds:YES];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGFloat pointLineWidth = 1.5f;
    CGFloat pointMiterLimit = 1.0f;
    CGContextSetLineWidth(con, pointLineWidth);//主线宽度
    CGContextSetMiterLimit(con, pointMiterLimit);//投影角度
    CGContextSetAlpha(con, 0.5);
    CGContextSetLineJoin(con, 0);
    CGContextSetLineCap(con, kCGLineCapSquare );
//    CGContextTranslateCTM(con, 0, self.bounds.size.height);
//    CGContextScaleCTM(con, 1.0, -1.0);
    //开始一个起始路径
    CGContextBeginPath(con);
	//绘图
	float p1 = 0;
	CGContextMoveToPoint(con, 0, self.bounds.size.height);
    CGPoint goPoint;
	for (int i=0; i<[_blueArray count]; i++)
	{
		p1 = [[_blueArray objectAtIndex:i] floatValue];
        if (i==0) {
            goPoint = CGPointMake(0, self.bounds.size.height-p1);
        }else if (i==1) {
            goPoint = CGPointMake(25.5-11.5, self.bounds.size.height-p1);
        }
        else if (i==2) {
            goPoint = CGPointMake(34.5-11.5, self.bounds.size.height-p1);
        }
        else if (i==3){
            goPoint = CGPointMake(43.5-11.5, self.bounds.size.height-p1);
        }
        else if (i==4){
            goPoint = CGPointMake(52.5-11.5, self.bounds.size.height-p1);
        }
        else if (i==5){
            goPoint = CGPointMake(61.5-11.5, self.bounds.size.height-p1);
        }
        else if (i==6){
            goPoint = CGPointMake(70.5-11.5, self.bounds.size.height-p1);
        }
        else if (i==7){
            goPoint = CGPointMake(79.5-11.5, self.bounds.size.height-p1);
        }else if (i==8){
            goPoint = CGPointMake(88.5-11.5, self.bounds.size.height-p1);
        }else if (i==9){
            goPoint = CGPointMake(97.5-11.5, self.bounds.size.height-p1);
        }else if (i==10){
            goPoint = CGPointMake(106.5-11.5, self.bounds.size.height-p1);
        }
        else if (i==11){
            goPoint = CGPointMake(115.5-11.5, self.bounds.size.height-p1);
        }
        else if (i==12){
            goPoint = CGPointMake(125.5-11.5, self.bounds.size.height-p1);
        }
        else if (i==13){
            goPoint = CGPointMake(134.5-11.5, self.bounds.size.height-p1);
        }
        else if (i==14){
            goPoint = CGPointMake(149.5-11.5, self.bounds.size.height-p1);
        }
        else if (i==15){
            goPoint = CGPointMake(164.5-11.5, self.bounds.size.height-p1);
        }else if (i==16){
            goPoint = CGPointMake(173.5-11.5, self.bounds.size.height-p1);
        }else if (i==17){
            goPoint = CGPointMake(182.5-11.5, self.bounds.size.height-p1);
        }else if (i==18){
            goPoint = CGPointMake(191.5-11.5, self.bounds.size.height-p1);
        }else if (i==19){
            goPoint = CGPointMake(200.5-11.5, self.bounds.size.height-p1);
        }else if (i==20){
            goPoint = CGPointMake(209.5-11.5, self.bounds.size.height-p1);
        }else if (i==21){
            goPoint = CGPointMake(218.5-11.5, self.bounds.size.height-p1);
        }else if (i==22){
            goPoint = CGPointMake(227.5-11.5, self.bounds.size.height-p1);
        }else if (i==23){
            goPoint = CGPointMake(236.5-11.5, self.bounds.size.height-p1);
        }
        else if (i==24){
            goPoint = CGPointMake(245.5-11.5, self.bounds.size.height-p1);
        }else if (i==25){
            goPoint = CGPointMake(254.5-11.5, self.bounds.size.height-p1);
        }else if (i==26){
            goPoint = CGPointMake(263.5-11.5, self.bounds.size.height-p1);
        }else if (i==27){
            goPoint = CGPointMake(272.5-11.5, self.bounds.size.height-p1);
        }else if (i==28){
            goPoint = CGPointMake(282.5-11.5, self.bounds.size.height-p1);
        }else if (i==29){
            goPoint = CGPointMake(291.5-11.5, self.bounds.size.height-p1);
        }else if (i==30)
        {
            goPoint=CGPointMake(308.5-11.5, self.bounds.size.height-p1);
        }
		CGContextAddLineToPoint(con, goPoint.x, goPoint.y);
        if (i==[_blueArray count]-1) {
            CGContextAddLineToPoint(con, goPoint.x, self.bounds.size.height);
            CGContextAddLineToPoint(con, 0, self.bounds.size.height);
        }
	}
    CGContextClosePath(con);
    [[_colorArray objectAtIndex:0] setStroke];
    [[_colorArray objectAtIndex:1] setFill];
    CGContextDrawPath(con, kCGPathFillStroke);
}



@end
