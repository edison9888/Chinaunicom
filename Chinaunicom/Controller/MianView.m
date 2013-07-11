//
//  MianView.m
//  Chinaunicom
//
//  Created by rock on 13-7-11.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "MianView.h"
#import "CommonHelper.h"
@implementation MianView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
//        [self setClipsToBounds:YES];
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
    //开始一个起始路径
    CGContextBeginPath(con);
	//绘图
	float p1 = [[_blueArray objectAtIndex:0] floatValue];
	int i = 1;
	CGContextMoveToPoint(con, 0, self.bounds.size.height);
    CGContextAddLineToPoint(con, 0, self.bounds.size.height-p1);
    CGPoint goPoint;
	for (; i<[_blueArray count]; i++)
	{
		p1 = [[_blueArray objectAtIndex:i] floatValue];
        
        if (i==1) {
            goPoint = CGPointMake(25.5, self.bounds.size.height-p1);
        }
        else if (i==2) {
            goPoint = CGPointMake(35.5, self.bounds.size.height-p1);
        }
        else if (i==3){
            goPoint = CGPointMake(45.5, self.bounds.size.height-p1);
        }
        else if (i==4){
            goPoint = CGPointMake(55.5, self.bounds.size.height-p1);
        }
        else if (i==5){
            goPoint = CGPointMake(64.5, self.bounds.size.height-p1);
        }
        else if (i==6){
            goPoint = CGPointMake(74.5, self.bounds.size.height-p1);
        }
        else if (i==7){
            goPoint = CGPointMake(84.5, self.bounds.size.height-p1);
        }else if (i==8){
            goPoint = CGPointMake(94.5, self.bounds.size.height-p1);
        }else if (i==9){
            goPoint = CGPointMake(103.5, self.bounds.size.height-p1);
        }else if (i==10){
            goPoint = CGPointMake(113.5, self.bounds.size.height-p1);
        }
        else if (i==11){
            goPoint = CGPointMake(123.5, self.bounds.size.height-p1);
        }
        else if (i==12){
            goPoint = CGPointMake(133.5, self.bounds.size.height-p1);
        }
        else if (i==13){
            goPoint = CGPointMake(142.5, self.bounds.size.height-p1);
        }
        else if (i==14){
            goPoint = CGPointMake(160.5, self.bounds.size.height-p1);
        }
        else if (i==15){
            goPoint = CGPointMake(174.5, self.bounds.size.height-p1);
        }else if (i==16){
            goPoint = CGPointMake(184.5, self.bounds.size.height-p1);
        }else if (i==17){
            goPoint = CGPointMake(194.5, self.bounds.size.height-p1);
        }else if (i==18){
            goPoint = CGPointMake(203.5, self.bounds.size.height-p1);
        }else if (i==19){
            goPoint = CGPointMake(213.5, self.bounds.size.height-p1);
        }else if (i==20){
            goPoint = CGPointMake(223.5, self.bounds.size.height-p1);
        }else if (i==21){
            goPoint = CGPointMake(233.5, self.bounds.size.height-p1);
        }else if (i==22){
            goPoint = CGPointMake(242.5, self.bounds.size.height-p1);
        }else if (i==23){
            goPoint = CGPointMake(252.5, self.bounds.size.height-p1);
        }
        else if (i==24){
            goPoint = CGPointMake(262.5, self.bounds.size.height-p1);
        }else if (i==25){
            goPoint = CGPointMake(271.5, self.bounds.size.height-p1);
        }else if (i==26){
            goPoint = CGPointMake(281.5, self.bounds.size.height-p1);
        }else if (i==27){
            goPoint = CGPointMake(291.5, self.bounds.size.height-p1);
        }else if (i==28){
            goPoint = CGPointMake(308.5, self.bounds.size.height-p1);
        }else if (i==29){
            goPoint = CGPointMake(262.5, self.bounds.size.height-p1);
        }

		CGContextAddLineToPoint(con, goPoint.x, goPoint.y);
        if (i==([_blueArray count]-1)) {
            CGContextAddLineToPoint(con, goPoint.x, self.bounds.size.height-p1);
            CGContextAddLineToPoint(con, 0, self.bounds.size.height);
        }
	}
    
    CGContextClosePath(con);
    [[_colorArray objectAtIndex:0] setStroke];
    [[_colorArray objectAtIndex:1] setFill];
    CGContextDrawPath(con, kCGPathFillStroke);
//    CGContextClip(con);
//    CGContextRestoreGState(con);

//    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
}



@end
