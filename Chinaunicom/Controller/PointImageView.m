//
//  PointImageView.m
//  Chinaunicom
//
//  Created by YY on 13-6-29.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "PointImageView.h"

@implementation PointImageView
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
    
    self.blueDianImage.hidden=YES;
    
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
        NSString *key=nil;
        float hx=0;
        int num=0;
        if (self.center.x>2.5 && self.center.x<24.5) {
            
            self.center=CGPointMake(14.5, self.center.y);
            key=@"00";
            hx=14.5;
            num=0;
        }else if (self.center.x>=24.5 && self.center.x<39.5)
        {
            self.center=CGPointMake(33.5, self.center.y);
            key=@"01";
            hx=33.5;
            num=1;
        }else if(self.center.x>=39.5 && self.center.x <50.5)
        {
            self.center=CGPointMake(44.5, self.center.y);
            key=@"02";;
            hx=44.5;
            num=2;
        }else if(self.center.x>=50.5 && self.center.x <61.5)
        {
            self.center=CGPointMake(55.5, self.center.y);
            key=@"03";
            hx=55.5;
            num=3;
        }else if(self.center.x>=61.5 && self.center.x <72.5)
        {
            self.center=CGPointMake(66.5, self.center.y);
            key=@"04";
            hx=66.5;
            num=4;
        }else if(self.center.x>=72.5 && self.center.x <83.5)
        {
            self.center=CGPointMake(77.5, self.center.y);
            key=@"05";
            hx=77.5;
            num=5;
        }else if(self.center.x>=83.5 && self.center.x <94.5)
        {
            self.center=CGPointMake(88.5, self.center.y);
            key=@"06";
            hx=88.5;
            num=6;
        }else if(self.center.x>=94.5 && self.center.x <105.5)
        {
            self.center=CGPointMake(99.5, self.center.y);
            key=@"07";
            hx=99.5;
            num=7;
        }else if(self.center.x>=105.5 && self.center.x <116.5)
        {
            self.center=CGPointMake(110.5, self.center.y);
            key=@"08";
            hx=110.5;
            num=8;
        }else if(self.center.x>=116.5 && self.center.x <127.5)
        {
            self.center=CGPointMake(121.5, self.center.y);
            key=@"09";
            hx=121.5;
            num=9;
        }else if(self.center.x>=127.5 && self.center.x <138.5)
        {
            self.center=CGPointMake(132.5, self.center.y);
            key=@"10";
            hx=132.5;
            num=10;
        }else if(self.center.x>=138.5 && self.center.x <149.5)
        {
            self.center=CGPointMake(143.5, self.center.y);
            key=@"11";
            hx=143.5;
            num=11;
        }else if(self.center.x>=149.5 && self.center.x <177)
        {
            self.center=CGPointMake(164.5, self.center.y);
            key=@"12";
            hx=164.5;
            num=12;
        }else if(self.center.x>=177 && self.center.x <188)
        {
            self.center=CGPointMake(182.5, self.center.y);
            key=@"13";
            hx=182.5;
            num=13;
        }else if(self.center.x>=188 && self.center.x <198)
        {
            self.center=CGPointMake(192.5, self.center.y);
            key=@"14";
            hx=192.5;
            num=14;
        }else if(self.center.x>=198 && self.center.x <208)
        {
            self.center=CGPointMake(202.5, self.center.y);
            key=@"15";
            hx=202.5;
            num=15;
        }else if(self.center.x>=208 && self.center.x <218)
        {
            self.center=CGPointMake(212.5, self.center.y);
            key=@"16";
            hx=212.5;
            num=16;
        }else if(self.center.x>=218 && self.center.x <228)
        {
            self.center=CGPointMake(222.5, self.center.y);
            key=@"17";
            hx=222.5;
            num=17;
        }else if(self.center.x>=228 && self.center.x <238)
        {
            self.center=CGPointMake(232.5, self.center.y);
            key=@"18";
            hx=232.5;
            num=18;
        }else if(self.center.x>=238 && self.center.x <248)
        {
            self.center=CGPointMake(242.5, self.center.y);
            key=@"19";
            hx=242.5;
            num=19;
        }else if(self.center.x>=248 && self.center.x <258)
        {
            self.center=CGPointMake(252.5, self.center.y);
            key=@"20";
            hx=252.5;
            num=20;
        }else if(self.center.x>=258 && self.center.x <268)
        {
            self.center=CGPointMake(262.5, self.center.y);
            key=@"21";
            hx=262.5;
            num=21;
        }else if(self.center.x>=268 && self.center.x <278)
        {
            self.center=CGPointMake(272.5, self.center.y);
            key=@"22";
            hx=272.5;
            num=22;
        }else if(self.center.x>=278 && self.center.x <288)
        {
            self.center=CGPointMake(282.5, self.center.y);
            key=@"23";
            hx=282.5;
            num=23;
        }else if (self.center.x>=288 && self.center.x <315.5)
        {
             self.center=CGPointMake(305.5, self.center.y);
            key=@"24";
            hx=305.5;
            num=24;
        }
    [_myDelegate showTheData:key x:hx num:num];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
