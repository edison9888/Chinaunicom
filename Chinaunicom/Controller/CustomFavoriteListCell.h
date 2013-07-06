//
//  CustomFavoriteListCell.h
//  Chinaunicom
//
//  Created by 李天焜 on 13-5-22.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//
@class CustomFavoriteListCell;

@protocol TPGestureTableViewCellDelegate <NSObject>
- (void)cellDidReveal:(CustomFavoriteListCell *)cell;
-(void) cellForIndexPath:(CustomFavoriteListCell *)cell;
@end
@interface CustomFavoriteListCell : UITableViewCell
@property (nonatomic,weak) id<TPGestureTableViewCellDelegate> delegate;
@property (strong,nonatomic) UIImageView *picImageView;
@property (strong,nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UILabel *contentTitleLabel;
@property (strong, nonatomic) UILabel *dateTimeLabel;
@property (nonatomic,strong) UISwipeGestureRecognizer *swipeRecognizer;
@property (nonatomic,strong)UIButton *deleteButton;
@property (nonatomic)BOOL isUnShow;
@end
