//
//  PointImageView.h
//  Chinaunicom
//
//  Created by YY on 13-6-29.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pointDelegate;

@interface PointImageView : UIImageView
{
    CGPoint beginPoint;
    id <pointDelegate> myDelegate;
}
@property (nonatomic,assign)id <pointDelegate> mydelegate;
@property (nonatomic,strong)UIImageView *blueDianImage;
@end
@protocol pointDelegate <NSObject>

-(void)showTheData : (NSString *)key x:(float)hx num:(int)num;

@end

