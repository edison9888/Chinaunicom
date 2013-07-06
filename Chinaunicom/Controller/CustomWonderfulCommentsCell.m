//
//  CustomWonderfulCommentsCell.m
//  Chinaunicom
//
//  Created by on 13-5-5.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "CustomWonderfulCommentsCell.h"

@implementation CustomWonderfulCommentsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgImageView=[[UIImageView alloc]init];
        _bgImageView.image=[UIImage imageNamed:@"top.png"];
        [self.contentView addSubview:_bgImageView];
        
        _headImageView=[[UIImageView alloc]init];
        UIImage *headImage=[UIImage imageNamed:@"head.png"];
        _headImageView.frame=CGRectMake(8, 8, headImage.size.width, headImage.size.height);
        _headImageView.image=headImage;
        [self.contentView addSubview:_headImageView];
        
        _realHead=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 30, 30)];
        [_headImageView addSubview:_realHead];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 20)];
        _nameLabel.backgroundColor=[UIColor clearColor];
        [_nameLabel setTextColor:[UIColor blueColor]];
        [self.contentView addSubview:_nameLabel];
        
        _commentLabel=[[UILabel alloc]init];
        [_commentLabel setBackgroundColor:[UIColor clearColor]];
        [_commentLabel setNumberOfLines:0];
        [_commentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentView addSubview:_commentLabel];
        
        _timeLabel=[[UILabel alloc]init];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setTextColor:[UIColor darkGrayColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView addSubview:_timeLabel];
        
        _soundButton=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *soundImage=[UIImage imageNamed:@"Sound.png"];
        _soundButton.frame=CGRectMake(270, 10, 40, 30);
        [_soundButton setImage:soundImage forState:UIControlStateNormal];
        [_soundButton setBackgroundColor:[UIColor clearColor]];
        _soundButton.hidden=YES;
        [self.contentView addSubview:_soundButton];
    }
    return self;
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    _realHead.image=nil;
    _nameLabel.text=nil;
    _commentLabel.text=nil;
    _timeLabel.text=nil;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
