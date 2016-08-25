//
//  SouHuNewsList.h
//  NewsApp
//
//  Created by 杨方明 on 16/4/27.
//  Copyright © 2016年 杨方明. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChannelModel.h"

#import "NewsListViewStatus.h"

@protocol NewsListContainerVC2Delegate;

@interface SouHuNewsList : UIViewController

@property (nonatomic, strong) UITableView *newsTableView;

/*当前控制器的标记*/
@property (nonatomic, assign) NSInteger indexNumber;

@property (nonatomic, weak) id<NewsListContainerVC2Delegate> delegate;

- (instancetype)initWithChannelModels:(NSMutableArray<ChannelModel *> *)channelModels
                      viewStatusArray:(NSMutableArray<NewsListViewStatus *> *)viewStatus
                          indexNumber:(NSInteger)indexNumber;

@end

@protocol NewsListContainerVC2Delegate <NSObject>

- (void)setCurrentIndex:(NSInteger)index;

@end
