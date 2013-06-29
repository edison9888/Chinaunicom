//
//  LineImageView.m
//  Chinaunicom
//
//  Created by YY on 13-6-29.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "LineImageView.h"

@implementation LineImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    UIGraphicsBeginImageContext(imageView.frame.size);
    CGContextRef con = UIGraphicsGetCurrentContext();
//    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    CGFloat pointLineWidth = 1.5f;
    CGFloat pointMiterLimit = 1.0f;
    
    CGContextSetLineWidth(con, pointLineWidth);//主线宽度
    CGContextSetMiterLimit(con, pointMiterLimit);//投影角度
    
    CGContextSetLineJoin(con, 0);
    
    CGContextSetLineCap(con, kCGLineCapSquare );
    
    CGContextSetBlendMode(con, kCGBlendModeNormal);
    
//    CGContextSetStrokeColorWithColor(con, [UIColor blueColor].CGColor);
//    //设置颜色
    CGContextSetRGBStrokeColor(con, [[_colorArray objectAtIndex:0]floatValue], [[_colorArray objectAtIndex:1]floatValue], [[_colorArray objectAtIndex:2]floatValue], [[_colorArray objectAtIndex:3]floatValue]);
    //开始一个起始路径
    CGContextBeginPath(con);
	//绘图
	float p1 = [[_blueArray objectAtIndex:0] floatValue];
	int i = 1;
	CGContextMoveToPoint(con, 9.5, self.bounds.size.height-p1);
    CGPoint goPoint;
	for (; i<[_blueArray count]; i++)
	{
		p1 = [[_blueArray objectAtIndex:i] floatValue];
        
        if (i==1) {
            goPoint = CGPointMake(27.5, self.bounds.size.height-p1);
        }
        else if (i==2) {
            goPoint = CGPointMake(38.5, self.bounds.size.height-p1);
        }
        else if (i==3){
            goPoint = CGPointMake(49.5, self.bounds.size.height-p1);
        }
        else if (i==4){
            goPoint = CGPointMake(60.5, self.bounds.size.height-p1);
        }
        else if (i==5){
            goPoint = CGPointMake(71.5, self.bounds.size.height-p1);
        }
        else if (i==6){
            goPoint = CGPointMake(82.5, self.bounds.size.height-p1);
        }
        else if (i==7){
            goPoint = CGPointMake(93.5, self.bounds.size.height-p1);
        }else if (i==8){
            goPoint = CGPointMake(104.5, self.bounds.size.height-p1);
        }else if (i==9){
            goPoint = CGPointMake(115.5, self.bounds.size.height-p1);
        }else if (i==10){
            goPoint = CGPointMake(126.5, self.bounds.size.height-p1);
        }
        else if (i==11){
            goPoint = CGPointMake(137.5, self.bounds.size.height-p1);
        }
        else if (i==12){
            goPoint = CGPointMake(157.5, self.bounds.size.height-p1);
        }
        else if (i==13){
            goPoint = CGPointMake(175.5, self.bounds.size.height-p1);
        }
        else if (i==14){
            goPoint = CGPointMake(185.5, self.bounds.size.height-p1);
        }
        else if (i==15){
            goPoint = CGPointMake(195.5, self.bounds.size.height-p1);
        }else if (i==16){
            goPoint = CGPointMake(205.5, self.bounds.size.height-p1);
        }else if (i==17){
            goPoint = CGPointMake(215.5, self.bounds.size.height-p1);
        }else if (i==18){
            goPoint = CGPointMake(225.5, self.bounds.size.height-p1);
        }else if (i==19){
            goPoint = CGPointMake(235.5, self.bounds.size.height-p1);
        }else if (i==20){
            goPoint = CGPointMake(245.5, self.bounds.size.height-p1);
        }else if (i==21){
            goPoint = CGPointMake(255.5, self.bounds.size.height-p1);
        }else if (i==22){
            goPoint = CGPointMake(265.5, self.bounds.size.height-p1);
        }else if (i==23){
            goPoint = CGPointMake(275.5, self.bounds.size.height-p1);
        }
        else if (i==24){
            goPoint = CGPointMake(298.5, self.bounds.size.height-p1);
        }
		CGContextAddLineToPoint(con, goPoint.x, goPoint.y);;
        
	}
	CGContextStrokePath(con);
//    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();

}


@end
