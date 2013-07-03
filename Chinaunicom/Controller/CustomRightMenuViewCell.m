//
//  CustomRightMenuViewCell.m
//  Chinaunicom
//
//  Created by LITK on 13-5-10.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "CustomRightMenuViewCell.h"
#import "CommonHelper.h"
#import "Utility.h"
#import "ASIHTTPRequest.h"
@implementation CustomRightMenuViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _topBgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top@2x.png"]];
        [self.contentView addSubview:_topBgImageView];
        
        _bottomBgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down@2x.png"]];
        [self.contentView addSubview:_bottomBgImageView];
        
        _nameLabel=[[UILabel alloc]init];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[CommonHelper hexStringToColor:@"00398b"]];
        [self.contentView addSubview:_nameLabel];
        
        _soundButton=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *soundImage=[UIImage imageNamed:@"Sound.png"];
        [_soundButton setBackgroundImage:soundImage forState:UIControlStateNormal];
        [_soundButton setHidden:YES];
        
        [self.contentView addSubview:_soundButton];
        
        _contentLabel=[[UILabel alloc]init];
        [_contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setTextColor:[CommonHelper hexStringToColor:@"00398b"]];
        [self.contentView addSubview:_contentLabel];
        
        _timeLabel=[[UILabel alloc]init];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setTextColor:[CommonHelper hexStringToColor:@"767a7f"]];
        [self.contentView addSubview:_timeLabel];
        
        _newsLabel=[[UILabel alloc]init];
        [_newsLabel setBackgroundColor:[UIColor clearColor]];
        [_newsLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [_newsLabel setNumberOfLines:0];
        [_newsLabel setTextColor:[CommonHelper hexStringToColor:@"252525"]];
        [self.contentView addSubview:_newsLabel];
        
        _pinglunLabel=[[UILabel alloc]init];
        [_pinglunLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_pinglunLabel setBackgroundColor:[UIColor clearColor]];
        _pinglunLabel.adjustsFontSizeToFitWidth=YES;
        [_pinglunLabel setTextColor:[CommonHelper hexStringToColor:@"404040"]];
        [self.contentView addSubview:_pinglunLabel];
        
        _messageImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"com_mes.png"]];
        [self.contentView addSubview:_messageImageView];
        
        _numLabel=[[UILabel alloc]init];
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [_numLabel setFont:[UIFont systemFontOfSize:14.0f]];
        _numLabel.adjustsFontSizeToFitWidth=YES;
        [_numLabel setTextColor:[CommonHelper hexStringToColor:@"404040"]];
        [self.contentView addSubview:_numLabel];
        
        UIImage *headBgImage=[UIImage imageNamed:@"head.png"];
        UIImageView *headBgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(16, 0, headBgImage.size.width, headBgImage.size.height)];
        headBgImageView.image=headBgImage;
        [self.contentView addSubview:headBgImageView];
        
        _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2, 4, 30, 27)];
        [headBgImageView addSubview:_headImageView];

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    //view
//    [self.topView setBackgroundColor:[CommonHelper hexStringToColor:@"#b6c7da"]];
//    [self.bottomView setBackgroundColor:[CommonHelper hexStringToColor:@"#cfd4dc"]];
//    //label
//    [self.userNameLabel setTextColor: [CommonHelper hexStringToColor:@"#00398b"]];

}

@end
