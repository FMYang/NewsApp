//
//  ArticleCell.m
//  UrunNews
//
//  Created by 杨方明 on 16/4/1.
//  Copyright © 2016年 URUN. All rights reserved.
//

#import "ArticleCell.h"

#import "NSString+Expand.h"

#import "UIImageView+WebCache.h"

#import "UIImageView+Extend.h"

/************** 父类cell ****************/
@implementation ArticleCell

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)sourceLalel
{
    if(!_sourceLalel)
    {
        _sourceLalel = [[UILabel alloc]init];
        _sourceLalel.backgroundColor = [UIColor clearColor];
        _sourceLalel.textColor = [UIColor grayColor];
        _sourceLalel.font = kBottomTagFont;
        _sourceLalel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_sourceLalel];
    }
    return _sourceLalel;
}

- (UIImageView *)timeImgView
{
    if(!_timeImgView)
    {
        _timeImgView = [[UIImageView alloc]init];
        _timeImgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeImgView];
    }
    return _timeImgView;
}

- (UILabel *)timeLabel
{
    if(!_timeLabel)
    {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.font = SystemFont_10;
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIImageView *)lineView
{
    if(!_lineView)
    {
        _lineView = [[UIImageView alloc]init];
        _lineView.image = [UIImage imageNamed:@"icon_space_line"];
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UIImageView *)imgView1
{
    if(!_imgView1)
    {
        _imgView1 = [[UIImageView alloc]init];
        _imgView1.backgroundColor = [UIColor clearColor];
        [self addSubview:_imgView1];
    }
    return _imgView1;
}

- (UIImageView *)imgView2
{
    if(!_imgView2)
    {
        _imgView2 = [[UIImageView alloc]init];
        _imgView2.backgroundColor = [UIColor clearColor];
        [self addSubview:_imgView2];
    }
    return _imgView2;
}

- (UIImageView *)imgView3
{
    if(!_imgView3)
    {
        _imgView3 = [[UIImageView alloc]init];
        _imgView3.backgroundColor = [UIColor clearColor];
        [self addSubview:_imgView3];
    }
    return _imgView3;
}


@end

/************** 一张图cell ****************/
#pragma mark - 一张图cell
@implementation OnePicArticleCell

- (void)layoutCellWithLayout:(OnePicArticleCellLayout *)layout
{
    self.titleLabel.font = SystemFont_16;

    NewsModel *articleEntity = layout.model;

    self.titleLabel.numberOfLines = 3;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    
    CGRect imgViewRect = CGRectMake(kPaddingLeft, kSpaceHeight, kOnePicWidth, kOnePicHeight);
    self.imgView1.frame = imgViewRect;
    self.imgView1.image = [UIImage imageNamed:KDefaultImageName];
    
    NSURL *imgUrl = [NSURL URLWithString:articleEntity.picUrl];
    
    [self.imgView1 sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:KDefaultImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image)
        {
            self.imgView1.image = [self.imgView1 cutImageFromImage:image cutFrame:CGSizeMake(kThreePicWidth, kThreePicHeight)];
        }
    }];
    
    CGRect titleRect = CGRectMake(kPaddingLeft+kOnePicWidth+kSpaceWidth, kSpaceHeight, kOnePicTitleWidth, layout.titleHeight);
    self.titleLabel.frame = titleRect;
    self.titleLabel.text = articleEntity.title;
    
    CGRect sourceRect = CGRectMake(self.titleLabel.x, self.titleLabel.y+self.titleLabel.height, 100, kBottomTagHeight);
    self.sourceLalel.frame = sourceRect;
    self.sourceLalel.text = articleEntity.sourceName;

    self.lineView.frame = CGRectMake(0, layout.cellHeight-0.5, ScreenWith, 0.5);
}

@end





