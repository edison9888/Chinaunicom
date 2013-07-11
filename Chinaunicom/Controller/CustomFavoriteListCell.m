//
//  CustomFavoriteListCell.m
//  Chinaunicom
//
//  Created by 李天焜 on 13-5-22.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "CustomFavoriteListCell.h"

@implementation CustomFavoriteListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _isUnShow=NO;
        _bgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top.png"]];
        [self.contentView addSubview:_bgImageView];
    
        _contentTitleLabel=[[UILabel alloc]init];
        [_contentTitleLabel setBackgroundColor:[UIColor clearColor]];
        [_contentTitleLabel setTextColor:[UIColor blackColor]];
        [_contentTitleLabel setNumberOfLines:0];
        [_contentTitleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentView addSubview:_contentTitleLabel];
        
        _dateTimeLabel=[[UILabel alloc]init];
        [_dateTimeLabel setTextColor:[UIColor darkGrayColor]];
        [_dateTimeLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_dateTimeLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_dateTimeLabel];
        
        UIImage *image=[UIImage imageNamed:@"comment_cell_tip.png"];
        _picImageView=[[UIImageView alloc]initWithImage:image];
        _picImageView.frame=CGRectMake(280, 8, image.size.width, image.size.height);
        [self.contentView addSubview:_picImageView];
        
        _deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"deleteBt.png"] forState:UIControlStateNormal];
        _deleteButton.frame=CGRectMake(280, 30, 30, 30);
        [_deleteButton setBackgroundColor:[UIColor clearColor]];
        [_deleteButton addTarget:self action:@selector(deleteThisRow:) forControlEvents:UIControlEventTouchUpInside];
            _deleteButton.hidden=YES;
        
        [self.contentView addSubview:_deleteButton];
        
        // 滑动的 Recognizer
        _swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandle:)];
        //设置滑动方向
        [_swipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:_swipeRecognizer];
        
    }
    return self;
}

- (void)swipeHandle:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == (UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)) {
        _isUnShow=!_isUnShow;
        if (_isUnShow==YES) {
            _deleteButton.hidden=NO;
        }else
        {
            _deleteButton.hidden=YES;
        }
        if ([_delegate respondsToSelector:@selector(cellDidReveal:)]) {
            [_delegate cellDidReveal:self];
        }

    }

}

-(void)deleteThisRow:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(cellForIndexPath:)]) {
        [_delegate cellForIndexPath:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


//    [self.dateTimeLabel setTextColor:[CommonHelper hexStringToColor:@"#848484"]];
}
#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//	if (gestureRecognizer == _panGesture) {
//		UIScrollView *superview = (UIScrollView *)self.superview;
//		CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:superview];
//		// Make it scrolling horizontally
//		return ((fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO &&
//                (superview.contentOffset.y == 0.0 && superview.contentOffset.x == 0.0));
//	}
//	return YES;
//}

@end
