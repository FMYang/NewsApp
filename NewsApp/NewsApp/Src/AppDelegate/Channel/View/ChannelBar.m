//
//  ChannelBar.m
//  NewsApp
//
//  Created by 杨方明 on 16/4/28.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "ChannelBar.h"

#import "ChannelModel.h"

@interface ChannelBar() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *channelContainerView;

@property (nonatomic, strong) NSMutableArray<ChannelModel *> *channelModels;

@end

@implementation ChannelBar

- (UIScrollView *)channelContainerView
{
    if(!_channelContainerView)
    {
        _channelContainerView = [[UIScrollView alloc]init];
        _channelContainerView.frame = CGRectMake(0, 0, ScreenWith, kBarHeight);
        _channelContainerView.showsHorizontalScrollIndicator = NO;
        _channelContainerView.showsVerticalScrollIndicator = NO;
        [self addSubview:_channelContainerView];
    }
    return _channelContainerView;
}

- (void)setChannelModels:(NSMutableArray *)channelModels
{
    self.channelModels = channelModels;
    
    self.channelContainerView.contentSize = CGSizeMake(ScreenWith*self.channelModels.count, kBarHeight);
    
    [self setupItemBars];
}

- (void)setupItemBars
{
    [self.channelModels enumerateObjectsUsingBlock:^(ChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *item = [self makeItemBarWithTitle:obj.channelName font:kFormatFont index:idx];
        [_channelContainerView addSubview:item];
    }];
}

- (UIButton *)makeItemBarWithTitle:(NSString *)title font:(UIFont *)font index:(NSInteger)index
{
    float itemWidth = [title getWidthByHeight:kBarHeight font:font];
    CGRect btnFrame = CGRectMake(0, 0, itemWidth, kBarHeight);
    UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    btn.frame = btnFrame;
    btn.tag = index;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)itemClick:(UIButton *)btn
{
    if(self.itemClickBlock)
    {
        self.itemClickBlock(btn.tag);
    }
}

@end
