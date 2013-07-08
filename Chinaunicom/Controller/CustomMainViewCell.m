//
//  CustomSafeCell.m
//  Chinaunicom
//
//  Created by  on 13-5-5.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "CustomMainViewCell.h"

@implementation CustomMainViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image=[UIImage imageNamed:@"cell_bg.png"];
        [self.contentView addSubview:_bgImageView];
        
        _titleLabel=[[UILabel alloc]init];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [_titleLabel setNumberOfLines:0];
        [self.contentView addSubview:_titleLabel];
        
        _qitaImageView=[[UIImageView alloc]init];
        [self.contentView addSubview:_qitaImageView];
        
        _pinlunLabel=[[UILabel alloc]init];
        [_pinlunLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_pinlunLabel sizeToFit];
        [_pinlunLabel setTextAlignment:NSTextAlignmentRight];
        [_pinlunLabel setBackgroundColor:[UIColor clearColor]];
        [_pinlunLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:_pinlunLabel];
        
        _tupianImageView=[[UIImageView alloc]init];
        [_tupianImageView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_tupianImageView];
        
    }
    return self;
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    _titleLabel.text=@"";
    _qitaImageView.image=nil;
    _pinlunLabel.text=@"";
    _tupianImageView.image=nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
