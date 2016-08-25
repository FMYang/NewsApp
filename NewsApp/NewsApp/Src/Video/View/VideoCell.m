//
//  VideoCell.m
//  NewsApp
//
//  Created by 杨方明 on 16/5/12.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "VideoCell.h"

@interface VideoCell()

@property (nonatomic, strong) CAGradientLayer * gradientLayer;

@end

@implementation VideoCell

- (UIImageView *)videoImageView
{
    if(!_videoImageView)
    {
        _videoImageView = [[UIImageView alloc]init];
        _videoImageView.backgroundColor = [UIColor clearColor];
        _videoImageView.userInteractionEnabled = YES;
        [self addSubview:_videoImageView];
    }
    return _videoImageView;
}

- (UIView *)bottomView
{
    if(!_bottomView)
    {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

- (UIView *)titleBackgroundView
{
    if(!_titleBackgroundView)
    {
        _titleBackgroundView = [[UIView alloc]init];
        [self addSubview:_titleBackgroundView];
    }
    return _titleBackgroundView;
}

- (CAGradientLayer *)gradientLayer
{
    if(!_gradientLayer)
    {
        _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
//        _gradientLayer.bounds = _titleBackgroundView.layer.bounds;
        _gradientLayer.borderWidth = 0;
        
//        _gradientLayer.frame = _titleBackgroundView.layer.bounds;
        _gradientLayer.colors = [NSArray arrayWithObjects:
                                 (id)[[UIColor blackColor] CGColor],
                                 (id)[[UIColor clearColor] CGColor], nil,nil];
        _gradientLayer.startPoint = CGPointMake(0.2, 0.2);
        _gradientLayer.endPoint = CGPointMake(0.2, 1.0);
        
        [self.titleBackgroundView.layer insertSublayer:_gradientLayer atIndex:0];
    }
    return _gradientLayer;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = BoldSystemFont_16;
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        [self.titleBackgroundView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)lengthLabel
{
    if(!_lengthLabel)
    {
        _lengthLabel = [[UILabel alloc]init];
        _lengthLabel.backgroundColor = [UIColor clearColor];
        _lengthLabel.textColor = [UIColor darkGrayColor];
        _lengthLabel.font = SystemFont_14;
        [self.bottomView addSubview:_lengthLabel];
    }
    return _lengthLabel;
}

- (UILabel *)replyLabel
{
    if(!_replyLabel)
    {
        _lengthLabel = [[UILabel alloc]init];
        _lengthLabel.backgroundColor = [UIColor clearColor];
        _lengthLabel.textColor = [UIColor darkGrayColor];
        _lengthLabel.font = SystemFont_14;
        [self.bottomView addSubview:_lengthLabel];
    }
    return _replyLabel;
}

- (UIButton *)playButton
{
    if(!_playButton)
    {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"icon_video_cell_play_normal"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"icon_video_cell_play_selected"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playButton];
    }
    return _playButton;
}

- (void)playButtonClick
{
    if([self.delegate respondsToSelector:@selector(didClickPlayButtonAtIndexPath:)])
    {
        [self.delegate didClickPlayButtonAtIndexPath:self.indexPath];
    }
}

- (void)layoutCellWithLayout:(VideoCellLayout *)layout
{
    self.videoImageView.frame = CGRectMake(0, 0, layout.videoImageWidth, layout.videoImageHeight);
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:layout.model.picUrl] placeholderImage:[UIImage imageNamed:@"icon_default_image"]];
    
    self.titleBackgroundView.frame = CGRectMake(0, 0, ScreenWith, layout.titleHeight+20);
    self.gradientLayer.frame = _titleBackgroundView.layer.bounds;
    [self.titleBackgroundView.layer insertSublayer:self.gradientLayer atIndex:0];
    
    self.titleLabel.frame = CGRectMake(10, 10, ScreenWith-20, layout.titleHeight);
    self.titleLabel.text = layout.model.title;
    
    self.playButton.frame = self.videoImageView.frame;
    self.playButton.imageEdgeInsets = UIEdgeInsetsMake(0.5*(self.playButton.height-60), 0.5*(self.playButton.width-60), 0.5*(self.playButton.height-60), 0.5*(self.playButton.width-60));
    
    self.bottomView.frame = CGRectMake(0, self.videoImageView.height, ScreenWith, 40);
}

@end
