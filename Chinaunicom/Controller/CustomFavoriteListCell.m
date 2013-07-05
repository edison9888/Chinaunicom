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
        _picImageView.frame=CGRectMake(270, 8, image.size.width, image.size.height);
        [self.contentView addSubview:_picImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


//    [self.dateTimeLabel setTextColor:[CommonHelper hexStringToColor:@"#848484"]];
}

@end
