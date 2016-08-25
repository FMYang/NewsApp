//
//  VideoCellLayout.m
//  NewsApp
//
//  Created by 杨方明 on 16/5/12.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "VideoCellLayout.h"

@implementation VideoCellLayout

- (instancetype)initWithModel:(VideoModel *)model
{
    if(self = [super init])
    {
        self.model = model;
        
        _titleHeight = [model.title getHeightByWidth:ScreenWith-20 font:SystemFont_16];
        
        _videoImageWidth = ScreenWith;
        
        _videoImageHeight = ScreenWith*9/16;
        
        _bottomToolHeight = 40;
        
        _cellHeight = _videoImageHeight + _bottomToolHeight;
        
    }
    return self;
}

@end
