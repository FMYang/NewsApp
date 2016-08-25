//
//  ChannelHeadView.m
//  NewsApp
//
//  Created by 杨方明 on 16/5/1.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "ChannelHeadView.h"

@implementation ChannelHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _headLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 30)];
        _headLabel.backgroundColor = [UIColor clearColor];
        _headLabel.textColor = [UIColor blackColor];
        _headLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_headLabel];
        
    }
    return self;
}

@end
