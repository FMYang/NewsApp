//
//  ArticleCellLayout.m
//  UrunNews
//
//  Created by 杨方明 on 16/4/1.
//  Copyright © 2016年 URUN. All rights reserved.
//

#import "ArticleCellLayout.h"

#import "NSString+Expand.h"

@implementation ArticleCellLayout

- (instancetype)initWithNewsModel:(NewsModel *)model
{
    if(self = [super init])
    {
        _model = model;
    }
    
    return self;
}

- (void)layout
{
    //do nothing
    //子类差异化实现
}

+ (ArticleCellLayout *)getLayoutByModel:(NewsModel *)model
{
    ArticleCellLayout *layout = [[OnePicArticleCellLayout alloc]initWithNewsModel:model];
    [layout layout];
    return layout;
}

@end

/*********** 一张图cell布局对象 ***********/
@implementation OnePicArticleCellLayout

- (void)layout
{
    float titleRealHeight = [self.model.title getHeightByWidth:kOnePicTitleWidth font:SystemFont_16];
    
    float oneLineHeight = ceil(SystemFont_16.lineHeight);
    
    float titleMaxHeight = 3*oneLineHeight;
    
    self.titleHeight = MIN(titleMaxHeight, titleRealHeight);
    
    self.titleHeight = (self.titleHeight < kOnePicHeight-20)?(kOnePicHeight-20):self.titleHeight;
    
    self.cellHeight = self.titleHeight + kBottomTagHeight + 2*kSpaceHeight;
}

@end

