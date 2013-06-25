//
//  AnimationLeftMenu.m
//  Chinaunicom
//
//  Created by LITK on 13-5-13.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "AnimationLeftMenuView.h"

#define MaxTagNumber 999

@implementation AnimationLeftMenuView


- (id)initWithFrame:(CGRect)frame withNumber:(NSInteger)theNumber {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
//		UILabel *theNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2, 50,
//																			frame.size.width/2, 50)];
//		theNumberLabel.text = [NSString stringWithFormat:@"%d", theNumber];
//		theNumberLabel.tag = MaxTagNumber;
//		[self addSubview:theNumberLabel];

    }
    return self;
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
