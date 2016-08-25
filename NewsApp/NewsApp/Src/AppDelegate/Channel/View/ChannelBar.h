//
//  ChannelBar.h
//  NewsApp
//
//  Created by 杨方明 on 16/4/28.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBarHeight 30

#define kFormatFont [UIFont systemFontOfSize:16]

#define kSelectFont [UIFont systemFontOfSize:18]

typedef void (^ItemClickBlock)(NSInteger index);

@interface ChannelBar : UIView

@property (nonatomic, copy) ItemClickBlock itemClickBlock;

@end
