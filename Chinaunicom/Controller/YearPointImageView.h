//
//  YearPointImageView.h
//  Chinaunicom
//
//  Created by YY on 13-6-30.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol yearPointDelegate;

@interface YearPointImageView : UIImageView
{
    CGPoint beginPoint;
   __weak id <yearPointDelegate> _myDelegate;
}
@property (nonatomic,weak)id <yearPointDelegate> myDelegate;
@end
@protocol yearPointDelegate <NSObject>

-(void)showTheData:(int)num;

@end

