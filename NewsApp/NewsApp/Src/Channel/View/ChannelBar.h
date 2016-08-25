//
//  ChannelBar.h
//  NewsApp
//
//  Created by 杨方明 on 16/4/28.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChannelModel.h"

#import "ChannelList.h"

#define kBarHeight 40

#define kNormatFont [UIFont systemFontOfSize:18]

#define kSelectFont [UIFont systemFontOfSize:20]

typedef void (^ItemClickBlock)(NSInteger index);

typedef void (^ItemChangeBlock)(NSMutableArray<ChannelModel *> *topChannelModels, NSMutableArray<ChannelModel *> *bottomChannelModels, NSInteger selectedIndex);

@interface ChannelBar : UIView

@property (nonatomic, copy) ItemClickBlock itemClickBlock;

@property (nonatomic, copy) ItemChangeBlock itemChangeBlock;

@property (nonatomic, strong) NSMutableArray<ChannelModel *> *channelModels;

@property (nonatomic, strong) NSMutableArray<ChannelModel *> *topChannelModels;

@property (nonatomic, strong) NSMutableArray<ChannelModel *> *bottomChannelModels;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIButton *selectedItem;

@end
