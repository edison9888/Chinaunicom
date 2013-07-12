//
//  MonthPointImageView.h
//  Chinaunicom
//
//  Created by rock on 13-7-11.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol monthPointDelegate;

@interface MonthPointImageView : UIImageView
{
    CGPoint beginPoint;
    __weak id <monthPointDelegate> _myDelegate;
}
@property (nonatomic,strong)UIImageView *blueDian;
@property (nonatomic,strong)UIImageView *anotherBlue;
@property (nonatomic,weak)id <monthPointDelegate> myDelegate;
@end
@protocol monthPointDelegate <NSObject>

-(void)showTheData:(float)num num:(int)objcNum;
@end