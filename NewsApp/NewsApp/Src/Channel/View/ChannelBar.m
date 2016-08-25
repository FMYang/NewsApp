//
//  ChannelBar.m
//  NewsApp
//
//  Created by 杨方明 on 16/4/28.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import "ChannelBar.h"

#define kAddBtnWidth 40

static NSInteger maxWidth = 10;

@interface ChannelBar() <UIScrollViewDelegate, ChannelListDelegate>

@property (nonatomic, strong) UIScrollView *channelContainerView;

@property (nonatomic, strong) UIButton *addChannelBtn;

@property (nonatomic, strong) UIView *addBtnLeftView;

@property (nonatomic, strong) NSMutableArray<UIButton *> *items;

@end

@implementation ChannelBar

- (UIView *)addBtnLeftView
{
    if(!_addBtnLeftView)
    {
        _addBtnLeftView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWith-kAddBtnWidth, 0, 10, kBarHeight)];
        _addBtnLeftView.backgroundColor = [UIColor backgoundLightGrayColor];
        _addBtnLeftView.alpha = 0.8;
    }
    return _addBtnLeftView;
}

- (UIButton *)addChannelBtn
{
    if(!_addChannelBtn)
    {
        _addChannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addChannelBtn.backgroundColor = [UIColor backgoundLightGrayColor];
        _addChannelBtn.frame = CGRectMake(ScreenWith-kAddBtnWidth+10, 0, kAddBtnWidth-10, kBarHeight);
        [_addChannelBtn setImage:[UIImage imageNamed:@"icon_channel_add_normal"] forState:UIControlStateNormal];
        [_addChannelBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_addChannelBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 10)];        
    }
    return _addChannelBtn;
}

- (UIScrollView *)channelContainerView
{
    if(!_channelContainerView)
    {
        _channelContainerView = [[UIScrollView alloc]init];
        _channelContainerView.scrollsToTop = NO;
        _channelContainerView.backgroundColor = [UIColor backgoundLightGrayColor];
        _channelContainerView.frame = CGRectMake(0, 0, ScreenWith, kBarHeight);
        _channelContainerView.contentSize = CGSizeMake(ScreenWith, kBarHeight);
        _channelContainerView.showsHorizontalScrollIndicator = NO;
        _channelContainerView.showsVerticalScrollIndicator = NO;
        [self addSubview:_channelContainerView];
    }
    return _channelContainerView;
}

- (void)setChannelModels:(NSMutableArray *)channelModels
{
    _channelModels = channelModels;
    
    [self setupItemBars];
    [self setupAddBtn];
}

- (void)setTopChannelModels:(NSMutableArray<ChannelModel *> *)topChannelModels
{
    _topChannelModels = topChannelModels;
    
    [self setupItemBars];
    [self setupAddBtn];
}

- (void)setBottomChannelModels:(NSMutableArray<ChannelModel *> *)bottomChannelModels
{
    _bottomChannelModels = bottomChannelModels;
}

- (void)resetScrollViewSubViews
{
    [self.channelContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.items removeAllObjects];
    maxWidth = 10;
}

- (NSMutableArray<UIButton *> *)items
{
    if(!_items)
    {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    if(self.selectedItem)
    {
        [self.selectedItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.selectedItem.titleLabel.font = kNormatFont;
    }
    
    UIButton *selectedItem = self.items[selectedIndex];
    self.selectedItem = selectedItem;
    [selectedItem setTitleColor:[UIColor navRedColor] forState:UIControlStateNormal];
    selectedItem.titleLabel.font = kSelectFont;
    
    [self scrollToRect:selectedItem];
}

- (void)setupAddBtn
{
    [self addSubview:self.addBtnLeftView];
    [self addSubview:self.addChannelBtn];
}

- (void)setupItemBars
{
    [self.topChannelModels enumerateObjectsUsingBlock:^(ChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *item = [self makeItemBarWithTitle:obj.channelName_cn font:kNormatFont index:idx];
        [self.channelContainerView addSubview:item];
        [self.items addObject:item];
    }];
    
    self.channelContainerView.contentSize = CGSizeMake(maxWidth+kAddBtnWidth, kBarHeight);
}

- (UIButton *)makeItemBarWithTitle:(NSString *)title font:(UIFont *)font index:(NSInteger)index
{
    float itemWidth = [title getWidthByHeight:kBarHeight font:font];
    CGRect btnFrame = CGRectMake(maxWidth, 0, itemWidth+20, kBarHeight);
    maxWidth += (20+itemWidth);
    UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    btn.frame = btnFrame;
    btn.tag = index;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)itemClick:(UIButton *)btn
{
    [self scrollToRect:btn];
    
    if(self.itemClickBlock)
    {
        [self setSelectedIndex:btn.tag];
        self.itemClickBlock(btn.tag);
    }
}

- (void)scrollToRect:(UIButton *)btn
{
    if(btn.center.x < ScreenWith*0.5)
    {
        [self.channelContainerView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if(btn.center.x > ScreenWith*0.5)
    {
        if(self.channelContainerView.contentSize.width-kAddBtnWidth - btn.center.x < ScreenWith*0.5)
        {
            [self.channelContainerView setContentOffset:CGPointMake(self.channelContainerView.contentSize.width-ScreenWith, 0) animated:YES];
        }
        else
        {
            [self.channelContainerView setContentOffset:CGPointMake(btn.center.x-ScreenWith*0.5, 0) animated:YES];
        }
    }
}

- (void)addBtnClick
{
    ChannelList *channelList = [[ChannelList alloc]init];
    channelList.selectedIndex = self.selectedIndex;
    channelList.selectedChannelName = self.topChannelModels[self.selectedIndex].channelName_cn;
    channelList.topChannelModels = self.topChannelModels;
    channelList.bottomChannelModels = self.bottomChannelModels;
    channelList.delegate = self;
    [channelList show];
}

#pragma mark - ChannelList delegate
- (void)didSelectedItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *item = self.items[indexPath.row];
    [self itemClick:item];
}

- (void)didItemChangedTopChannelModels:(NSMutableArray<ChannelModel *> *)topChannelModels bottomChannelModels:(NSMutableArray<ChannelModel *> *)bottomChannelModels selectedIndex:(NSInteger)selectedIndex
{
    maxWidth = 10;
    [self.channelContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];

    [self.items removeAllObjects];
    self.topChannelModels = topChannelModels;
    self.bottomChannelModels = bottomChannelModels;
    
    [self setSelectedIndex:selectedIndex];
    
    if(self.itemChangeBlock)
    {
        self.itemChangeBlock(self.topChannelModels, self.bottomChannelModels, selectedIndex);
    }
}

@end
