//
//  ArticleCell.h
//  UrunNews
//
//  Created by 杨方明 on 16/4/1.
//  Copyright © 2016年 URUN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ArticleCellLayout.h"

@interface ArticleCell : UITableViewCell

/*标题*/
@property (nonatomic, strong) UILabel *titleLabel;

/*来源*/
@property (nonatomic, strong) UILabel *sourceLalel;

/*时间图标*/
@property (nonatomic, strong) UIImageView *timeImgView;

/*时间*/
@property (nonatomic, strong) UILabel *timeLabel;

/*分割线*/
@property (nonatomic, strong) UIImageView *lineView;

/*图片1*/
@property (nonatomic, strong) UIImageView *imgView1;

/*图片2*/
@property (nonatomic, strong) UIImageView *imgView2;

/*图片3*/
@property (nonatomic, strong) UIImageView *imgView3;

@end

/*********** 一张图cell ***********/
@interface OnePicArticleCell : ArticleCell

- (void)layoutCellWithLayout:(OnePicArticleCellLayout *)layout;

@end




